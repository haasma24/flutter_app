// lib/patterns/movie_decorator.dart
import 'package:recommendation_app/model/movie_model.dart';

abstract class MovieRecommendation {
  String getDescription();
  List<Movie> getMovies();
}

class BaseMovieRecommendation implements MovieRecommendation {
  final List<Movie> movies;

  BaseMovieRecommendation(this.movies);

  @override
  String getDescription() => "Recommended Movies";

  @override
  List<Movie> getMovies() => movies;
}

class MoodBasedRecommendationDecorator implements MovieRecommendation {
  final MovieRecommendation recommendation;
  final String mood;

  MoodBasedRecommendationDecorator(this.recommendation, this.mood);

  @override
  String getDescription() => 
      "${recommendation.getDescription()} based on your $mood mood";

  @override
  List<Movie> getMovies() {
    return recommendation.getMovies()
      .where((movie) => _matchesMood(movie.genre, mood))
      .toList();
  }

  bool _matchesMood(String genre, String mood) {
    final moodGenreMap = {
      'happy': ['Comedy', 'Animation', 'Family'],
      'sad': ['Drama', 'Romance'],
      'energetic': ['Action', 'Adventure', 'Sci-Fi'],
      'calm': ['Documentary', 'Drama', 'Biography'],
      'romantic': ['Romance', 'Drama'],
      'angry': ['Action', 'Thriller', 'Horror'],
    };
    
    return moodGenreMap[mood]?.contains(genre) ?? false;
  }
}

class PopularRecommendationDecorator implements MovieRecommendation {
  final MovieRecommendation recommendation;

  PopularRecommendationDecorator(this.recommendation);

  @override
  String getDescription() => 
      "Popular ${recommendation.getDescription()}";

  @override
  List<Movie> getMovies() {
    return recommendation.getMovies()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }
}