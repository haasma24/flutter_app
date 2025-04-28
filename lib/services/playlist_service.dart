import 'package:recommendation_app/database/database_helper.dart';

class PlaylistService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> createPlaylist(int userId, String name, {String? coverUrl}) async {
    return await _dbHelper.createPlaylist(userId, name, coverUrl: coverUrl);
  }

  Future<int> addMusicToPlaylist(int playlistId, int musicId) async {
    return await _dbHelper.addMusicToPlaylist(playlistId, musicId);
  }

  Future<List<Map<String, dynamic>>> getUserPlaylists(int userId) async {
    return await _dbHelper.getUserPlaylists(userId);
  }

  Future<List<Map<String, dynamic>>> getPlaylistMusics(int playlistId) async {
    return await _dbHelper.getPlaylistMusics(playlistId);
  }

  Future<int> removeMusicFromPlaylist(int playlistId, int musicId) async {
    return await _dbHelper.removeMusicFromPlaylist(playlistId, musicId);
  }
}