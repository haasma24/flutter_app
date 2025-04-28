// lib/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recommendation_app/model/movie_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  // Current database version - increment when changing schema
  static const int _databaseVersion = 2; 
  
  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');  // Keep original database name

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Create all tables from scratch for new installs
    await _createUserTable(db);
    await _createMovieTables(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle incremental upgrades
    if (oldVersion < 2) {
      await _createMovieTables(db);
    }
  }

  Future _createUserTable(Database db) async {
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

  Future _createMovieTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS movies(
        id TEXT PRIMARY KEY,
        title TEXT,
        imageUrl TEXT,
        plot TEXT,
        actors TEXT,
        releaseDate TEXT,
        rating REAL,
        genre TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS watchlist(
        movieId TEXT,
        userId INTEGER,
        FOREIGN KEY(movieId) REFERENCES movies(id),
        FOREIGN KEY(userId) REFERENCES users(id),
        PRIMARY KEY (movieId, userId)
      )
    ''');
  }

  // ============ USER AUTHENTICATION METHODS ============ //

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(
      'users', 
      user,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<Map<String, dynamic>?> authenticateUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
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

  // ============ MOVIE METHODS ============ //

  Future<void> insertMovies(List<Movie> movies) async {
    final db = await database;
    final batch = db.batch();
    
    for (final movie in movies) {
      batch.insert(
        'movies',
        movie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit(noResult: true);
  }

  Future<List<Movie>> getMoviesByGenre(String genre) async {
    final db = await database;
    final result = await db.query(
      'movies',
      where: 'genre = ?',
      whereArgs: [genre],
    );
    return result.map((map) => Movie.fromMap(map)).toList();
  }

  // ============ WATCHLIST METHODS ============ //

  Future<bool> addToWatchlist(String movieId, int userId) async {
    final db = await database;
    try {
      await db.insert(
        'watchlist',
        {
          'movieId': movieId,
          'userId': userId,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromWatchlist(String movieId, int userId) async {
    final db = await database;
    final count = await db.delete(
      'watchlist',
      where: 'movieId = ? AND userId = ?',
      whereArgs: [movieId, userId],
    );
    return count > 0;
  }

  Future<List<Movie>> getWatchlistMovies(int userId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT m.* FROM movies m
      JOIN watchlist w ON m.id = w.movieId
      WHERE w.userId = ?
    ''', [userId]);
    
    return result.map((map) => Movie.fromMap(map)).toList();
  }
}