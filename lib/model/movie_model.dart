// lib/model/movie_model.dart
class Movie {
  final String id;
  final String title;
  final String imageUrl;
  final String plot;
  final List<String> actors;
  final String releaseDate;
  final double rating;
  final String genre;
  bool isInWatchlist;

  Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.plot,
    required this.actors,
    required this.releaseDate,
    required this.rating,
    required this.genre,
    this.isInWatchlist = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'plot': plot,
      'actors': actors.join(','),
      'releaseDate': releaseDate,
      'rating': rating,
      'genre': genre,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      plot: map['plot'],
      actors: (map['actors'] as String).split(','),
      releaseDate: map['releaseDate'],
      rating: map['rating'],
      genre: map['genre'],
      isInWatchlist: map['isInWatchlist'] == 1,
    );
  }
}