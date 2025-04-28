import 'package:recommendation_app/database/database_helper.dart';
import 'package:recommendation_app/model/Playlist.dart';
import 'package:recommendation_app/model/music.dart';

class MusicService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Music>> getMusicByMoodAndGenre(String mood, String genre) async {
    final musicsMap = await _dbHelper.getMusicsByMoodAndGenre(mood, genre);
    return musicsMap.map((map) => Music.fromMap(map)).toList();
  }

  Future<int> addMusicToLibrary(Music music) async {
    return await _dbHelper.insertMusic(music.toMap());
  }



Future<List<Music>> getFavoriteMusics() async {
    final musicsMap = await _dbHelper.getFavoriteMusics();
    return musicsMap.map((map) => Music.fromMap(map)).toList();
  }
 Future<int> toggleFavorite(int musicId, bool isFavorite) async {
  return await _dbHelper.toggleFavorite(musicId, isFavorite);
}

  Future<List<Music>> searchMusic(String query) async {
    final maps = await _dbHelper.searchMusics(query);
    return maps.map(Music.fromMap).toList();
  }

  Future<List<Music>> getUserHistory(int userId) async {
    final maps = await _dbHelper.getUserHistory(userId);
    return maps.map((map) => Music.fromMap(map)).toList();
  }

  Future<List<Playlist>> getUserPlaylists(int userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'playlists',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps.map((map) => Playlist.fromMap(map)).toList();
  }

  
}