class Playlist {
  final int id;
  final int userId;
  final String name;
  final String? coverUrl;
  final String createdAt;

  Playlist({
    required this.id,
    required this.userId,
    required this.name,
    this.coverUrl,
    required this.createdAt,
  });

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      coverUrl: map['coverUrl'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'coverUrl': coverUrl,
      'createdAt': createdAt,
    };
  }
}