import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:recommendation_app/model/music.dart';
import 'package:recommendation_app/screens/mood_selection_screen.dart';
import 'package:recommendation_app/services/music_service.dart';
import 'package:recommendation_app/services/playlist_service.dart';

class MusicRecommendationsScreen extends StatefulWidget {
  final Mood mood;
  final String selectedGenre;
  final VoidCallback? onBack;

  const MusicRecommendationsScreen({
    required this.mood,
    required this.selectedGenre,
    this.onBack,
    Key? key,
  }) : super(key: key);

  @override
  _MusicRecommendationsScreenState createState() => _MusicRecommendationsScreenState();
}

class _MusicRecommendationsScreenState extends State<MusicRecommendationsScreen> {
  late Future<List<Music>> _musicFuture;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final MusicService _musicService = MusicService();
  final PlaylistService _playlistService = PlaylistService();
  int? _currentlyPlayingId;
  PlayerState _playerState = PlayerState.stopped;
  int? _selectedPlaylistId;

  @override
  void initState() {
    super.initState();
    _musicFuture = _loadMusic();
    _setupAudioPlayer();
  }

  Future<List<Music>> _loadMusic() async {
    try {
      return await _musicService.getMusicByMoodAndGenre(
        widget.mood.genre,
        widget.selectedGenre,
      );
    } catch (e) {
      debugPrint('Error loading music: $e');
      return [];
    }
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _playerState = state);
      }
    });
  }

  Future<void> _playMusic(Music music) async {
    try {
      if (_currentlyPlayingId == music.id && _playerState == PlayerState.playing) {
        await _audioPlayer.pause();
        return;
      }

      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/${music.url}'));
      
      setState(() => _currentlyPlayingId = music.id);
    } catch (e) {
      debugPrint('Playback error: $e');
    }
  }

  Future<void> _addToPlaylist(Music music) async {
    try {
      // Ici vous devriez avoir l'ID de l'utilisateur connecté
      final userId = 1; // Remplacez par l'ID réel de l'utilisateur
      final playlists = await _playlistService.getUserPlaylists(userId);
      
      if (playlists.isEmpty) {
        // Créer une playlist par défaut si aucune n'existe
        final playlistId = await _playlistService.createPlaylist(userId, 'My Playlist');
        await _playlistService.addMusicToPlaylist(playlistId, music.id);
      } else {
        // Afficher un dialogue pour choisir la playlist
        await _showPlaylistSelectionDialog(context, music);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to playlist')),
      );
    } catch (e) {
      debugPrint('Error adding to playlist: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding to playlist')),
      );
    }
  }

  Future<void> _showPlaylistSelectionDialog(BuildContext context, Music music) async {
    final userId = 1; // Remplacez par l'ID réel de l'utilisateur
    final playlists = await _playlistService.getUserPlaylists(userId);
    
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Playlist'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return ListTile(
                  title: Text(playlist['name']),
                  onTap: () async {
                    await _playlistService.addMusicToPlaylist(playlist['id'], music.id);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.onBack != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: widget.onBack,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${widget.mood.name} ${widget.mood.emoji} • ${widget.selectedGenre.toUpperCase()}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Music>>(
            future: _musicFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: Colors.white));
              }
              
              if (snapshot.hasError || snapshot.data == null) {
                return Center(child: Text('Error loading music', style: TextStyle(color: Colors.white)));
              }
              
              final musics = snapshot.data!;
              if (musics.isEmpty) {
                return Center(child: Text('No music found', style: TextStyle(color: Colors.white)));
              }

              return ListView.builder(
                itemCount: musics.length,
                itemBuilder: (context, index) {
                  final music = musics[index];
                  final isPlaying = _currentlyPlayingId == music.id && 
                                  _playerState == PlayerState.playing;
                  
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(
                          music.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: music.isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: () async {
                          await _musicService.toggleFavorite(music.id, !music.isFavorite);
                          setState(() {});
                        },
                      ),
                      title: Text(
                        music.title,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        music.artist,
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.playlist_add, color: Colors.white),
                            onPressed: () => _addToPlaylist(music),
                          ),
                          IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () => _playMusic(music),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}