import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:recommendation_app/model/music.dart';
import 'package:recommendation_app/services/music_service.dart';
import 'package:recommendation_app/services/playlist_service.dart';

class MusicRecommendationsScreen extends StatefulWidget {
  final String mood;
  final String selectedGenre;

  const MusicRecommendationsScreen({
    super.key,
    required this.mood,
    required this.selectedGenre,
  });

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

  @override
  void initState() {
    super.initState();
    _musicFuture = _loadMusic();
    _setupAudioPlayer();
  }

  Future<List<Music>> _loadMusic() async {
    try {
      return await _musicService.getMusicByMoodAndGenre(
        widget.mood,
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
      final userId = 1; // Replace with dynamic userId
      final playlists = await _playlistService.getUserPlaylists(userId);
      
      if (playlists.isEmpty) {
        final playlistId = await _playlistService.createPlaylist(userId, 'My Playlist');
        await _playlistService.addMusicToPlaylist(playlistId, music.id);
      } else {
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
    final userId = 1; // Replace with dynamic userId
    final playlists = await _playlistService.getUserPlaylists(userId);
    
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Playlist'),
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
              child: const Text('Cancel'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Recommendations'),
        backgroundColor: const Color.fromARGB(255, 203, 202, 202),
      ),
      body: Container(
        color: const Color.fromARGB(255, 235, 227, 227),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${widget.mood.toUpperCase()} • ${widget.selectedGenre.toUpperCase()}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Music>>(
                future: _musicFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError || snapshot.data == null) {
                    return const Center(child: Text('Error loading music', style: TextStyle(color: Colors.black54)));
                  }
                  
                  final musics = snapshot.data!;
                  if (musics.isEmpty) {
                    return const Center(child: Text('No music found', style: TextStyle(color: Colors.black54)));
                  }

                  return ListView.builder(
                    itemCount: musics.length,
                    itemBuilder: (context, index) {
                      final music = musics[index];
                      final isPlaying = _currentlyPlayingId == music.id && 
                                      _playerState == PlayerState.playing;
                  
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              music.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: music.isFavorite ? Colors.red : Colors.black54,
                            ),
                            onPressed: () async {
                              await _musicService.toggleFavorite(music.id, !music.isFavorite);
                              setState(() {});
                            },
                          ),
                          title: Text(
                            music.title,
                            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            music.artist,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.playlist_add, color: Colors.black54),
                                onPressed: () => _addToPlaylist(music),
                              ),
                              IconButton(
                                icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.black54,
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
        ),
      ),
    );
  }
}