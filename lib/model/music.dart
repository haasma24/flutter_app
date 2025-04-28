class Music {
  final int id;
  final String title;
  final String artist;
  final String genre;
  final String mood;
  final String url;
  final int userId;
  final String? album;
  final String? coverUrl;
  final int? duration;
  final bool isFavorite;

  Music({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.mood,
    required this.url,
    required this.userId,
    this.album,
    this.coverUrl,
    this.duration,
    this.isFavorite = false,
  });

  factory Music.fromMap(Map<String, dynamic> map) {
    return Music(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      genre: map['genre'],
      mood: map['mood'],
      url: map['url'],
      userId: map['userId'] ?? 1, // Default to 1 if not provided
      album: map['album'],
      coverUrl: map['coverUrl'],
      duration: map['duration'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'genre': genre,
      'mood': mood,
      'url': url,
      'userId': userId,
      'album': album,
      'coverUrl': coverUrl,
      'duration': duration,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  String get formattedDuration {
    if (duration == null) return '0:00';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Music copyWith({
    int? id,
    String? title,
    String? artist,
    String? genre,
    String? mood,
    String? url,
    int? userId,
    String? album,
    String? coverUrl,
    int? duration,
    bool? isFavorite,
  }) {
    return Music(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      genre: genre ?? this.genre,
      mood: mood ?? this.mood,
      url: url ?? this.url,
      userId: userId ?? this.userId,
      album: album ?? this.album,
      coverUrl: coverUrl ?? this.coverUrl,
      duration: duration ?? this.duration,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'Music{id: $id, title: $title, artist: $artist, genre: $genre, '
        'mood: $mood, url: $url, userId: $userId, album: $album, '
        'coverUrl: $coverUrl, duration: $duration, isFavorite: $isFavorite}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Music &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          artist == other.artist &&
          genre == other.genre &&
          mood == other.mood &&
          url == other.url &&
          userId == other.userId &&
          album == other.album &&
          coverUrl == other.coverUrl &&
          duration == other.duration &&
          isFavorite == other.isFavorite;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      artist.hashCode ^
      genre.hashCode ^
      mood.hashCode ^
      url.hashCode ^
      userId.hashCode ^
      album.hashCode ^
      coverUrl.hashCode ^
      duration.hashCode ^
      isFavorite.hashCode;
}