import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:recommendation_app/model/music.dart';
import 'package:recommendation_app/services/music_service.dart';

class MusicTile extends StatefulWidget {
  final Music music;

  const MusicTile({required this.music});

  @override
  _MusicTileState createState() => _MusicTileState();
}

class _MusicTileState extends State<MusicTile> {
  final _musicService = MusicService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isFavorite = false;
  PlayerState _playerState = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    // _isFavorite = widget.music.isFavorite;
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _playerState = state);
      }
    });
  }

  void _playMusic() async {
    try {
      if (_playerState == PlayerState.playing) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(AssetSource('assets/audio/${widget.music.url}'));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de lecture: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xFF67AE6E).withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.music_note, color: Color(0xFF328E6E)),
      ),
      title: Text(widget.music.title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(widget.music.artist),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () async {
              await _musicService.toggleFavorite(widget.music.id!, !_isFavorite);
              setState(() => _isFavorite = !_isFavorite);
            },
          ),
          IconButton(
            icon: Icon(
              _playerState == PlayerState.playing ? Icons.pause : Icons.play_arrow,
              color: Color(0xFF328E6E),
            ),
            onPressed: _playMusic,
          ),
        ],
      ),
    );
  }
}