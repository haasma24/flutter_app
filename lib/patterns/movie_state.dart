// lib/patterns/movie_state.dart
import 'package:flutter/material.dart';
import 'package:recommendation_app/model/movie_model.dart';
import 'package:recommendation_app/screens/movie_details_screen.dart';

abstract class MovieState {
  void handleState(BuildContext context, Movie movie);
}

class DefaultMovieState implements MovieState {
  @override
  void handleState(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
    );
  }
}

class WatchlistMovieState implements MovieState {
  @override
  void handleState(BuildContext context, Movie movie) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${movie.title} added to watchlist!')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
    );
  }
}

class MovieStateContext {
  MovieState _state = DefaultMovieState();

  void setState(MovieState state) {
    _state = state;
  }

  void handle(BuildContext context, Movie movie) {
    _state.handleState(context, movie);
  }
}