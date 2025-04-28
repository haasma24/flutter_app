import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');

    return await openDatabase(
      path,
      version: 2, // Incremented to 2 to trigger onUpgrade
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createUserTable(db);
    await _createMusicTable(db);
    await _createHistoryTable(db);
    await _createPlaylistsTable(db); // Ensure playlists table is created
    await _insertSampleMusicData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Create playlists tables if upgrading from version 1
      await _createPlaylistsTable(db);
    }
    // Add future upgrades here if needed
  }

  Future<void> _createUserTable(Database db) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        lastName TEXT,
        email TEXT UNIQUE,
        gender TEXT,
        password TEXT
      )
    ''');
  }

  Future<void> _createMusicTable(Database db) async {
    await db.execute('''
      CREATE TABLE musics(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        artist TEXT NOT NULL,
        album TEXT,
        genre TEXT NOT NULL,
        mood TEXT NOT NULL,
        duration INTEGER,
        url TEXT NOT NULL,
        coverUrl TEXT,
        isFavorite INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> _createHistoryTable(Database db) async {
    await db.execute('''
      CREATE TABLE user_music_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        musicId INTEGER,
        playedAt TEXT DEFAULT (datetime('now')),
        FOREIGN KEY (userId) REFERENCES users (id),
        FOREIGN KEY (musicId) REFERENCES musics (id)
      )
    ''');
  }

  Future<void> _createPlaylistsTable(Database db) async {
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS playlists(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER,
          name TEXT NOT NULL,
          coverUrl TEXT,
          createdAt TEXT DEFAULT (datetime('now')),
          FOREIGN KEY (userId) REFERENCES users (id)
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS playlist_musics(
          playlistId INTEGER,
          musicId INTEGER,
          addedAt TEXT DEFAULT (datetime('now')),
          PRIMARY KEY (playlistId, musicId),
          FOREIGN KEY (playlistId) REFERENCES playlists (id),
          FOREIGN KEY (musicId) REFERENCES musics (id)
        )
      ''');
    } catch (e) {
      print('Error creating playlist tables: $e');
      rethrow;
    }
  }

  Future<void> _insertSampleMusicData(Database db) async {
    final sampleMusics = [
      {
        'title': 'Happy Song',
        'artist': 'Artist Name',
        'genre': 'pop',
        'mood': 'happy',
        'duration': 180,
        'url': 'assets/audio/happy_song.mp3', // Updated to match actual asset path
      },
      {
        'title': 'Sad Melody',
        'artist': 'Artist Name',
        'genre': 'blues',
        'mood': 'sad',
        'duration': 200,
        'url': 'assets/audio/sad_song.mp3', // Updated to match actual asset path
      },
      {
        'title': 'Energy Song',
        'artist': 'Artist Name',
        'genre': 'rock',
        'mood': 'energetic',
        'duration': 220,
        'url': 'assets/audio/energy_song.mp3', // Updated to match actual asset path
      },
      {
        'title': 'Calm Song',
        'artist': 'Artist Name',
        'genre': 'ambient',
        'mood': 'calm',
        'duration': 240,
        'url': 'assets/audio/calm_song.mp3', // Updated to match actual asset path
      }
    ];

    // Supprimez d'abord toutes les musiques existantes pour éviter les doublons
    await db.delete('musics');

    // Insérez les nouvelles musiques
    for (final music in sampleMusics) {
      await db.insert('musics', music);
    }
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(String email, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'users',
      data,
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<int> insertMusic(Map<String, dynamic> music) async {
    final db = await database;
    return await db.insert('musics', music);
  }

  Future<List<Map<String, dynamic>>> getMusicsByMood(String mood) async {
    final db = await database;
    return await db.query(
      'musics',
      where: 'mood = ?',
      whereArgs: [mood],
      orderBy: 'title ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getMusicsByMoodAndGenre(
      String mood, String genre) async {
    final db = await database;
    return await db.query(
      'musics',
      where: 'mood = ? AND genre = ?',
      whereArgs: [mood, genre],
      orderBy: 'title ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getFavoriteMusics() async {
    final db = await database;
    return await db.query(
      'musics',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'title ASC',
    );
  }

  Future<int> toggleFavorite(int musicId, bool isFavorite) async {
    final db = await database;
    return await db.update(
      'musics',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [musicId],
    );
  }

  Future<int> addToHistory(int userId, int musicId) async {
    final db = await database;
    return await db.insert('user_music_history', {
      'userId': userId,
      'musicId': musicId,
    });
  }

  Future<List<Map<String, dynamic>>> getUserHistory(int userId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT m.*, h.playedAt 
      FROM musics m
      INNER JOIN user_music_history h ON m.id = h.musicId
      WHERE h.userId = ?
      ORDER BY h.playedAt DESC
      LIMIT 50
    ''', [userId]);
  }

  Future<List<Map<String, dynamic>>> searchMusics(String query) async {
    final db = await database;
    return await db.query(
      'musics',
      where: 'title LIKE ? OR artist LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'title ASC',
    );
  }

  Future<int> updateMusic(int musicId, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'musics',
      data,
      where: 'id = ?',
      whereArgs: [musicId],
    );
  }

  Future<int> deleteMusic(int musicId) async {
    final db = await database;
    return await db.delete(
      'musics',
      where: 'id = ?',
      whereArgs: [musicId],
    );
  }

  Future<int> createPlaylist(int userId, String name, {String? coverUrl}) async {
    final db = await database;
    return await db.insert('playlists', {
      'userId': userId,
      'name': name,
      'coverUrl': coverUrl,
    });
  }

  Future<int> addMusicToPlaylist(int playlistId, int musicId) async {
    final db = await database;
    return await db.insert('playlist_musics', {
      'playlistId': playlistId,
      'musicId': musicId,
    });
  }

  Future<List<Map<String, dynamic>>> getUserPlaylists(int userId) async {
    final db = await database;
    return await db.query(
      'playlists',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getPlaylistMusics(int playlistId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT m.* 
      FROM musics m
      INNER JOIN playlist_musics pm ON m.id = pm.musicId
      WHERE pm.playlistId = ?
      ORDER BY pm.addedAt DESC
    ''', [playlistId]);
  }

  Future<int> removeMusicFromPlaylist(int playlistId, int musicId) async {
    final db = await database;
    return await db.delete(
      'playlist_musics',
      where: 'playlistId = ? AND musicId = ?',
      whereArgs: [playlistId, musicId],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}