import 'package:flutter/material.dart';
import 'package:recommendation_app/screens/home_screen.dart';
import 'package:recommendation_app/screens/media_selection_screen.dart';
import 'package:recommendation_app/screens/movie_genre_selection_screen.dart';
import 'package:recommendation_app/screens/movie_recommendations_screen.dart';
import 'package:recommendation_app/screens/watchlist_screen.dart';
import 'package:recommendation_app/screens/movie_details_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recommendation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white70),
        ),
      ),
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(
              builder: (context) => HomeScreen(),
            );
          case '/mediaSelection':
            return MaterialPageRoute(
              builder: (context) => MediaSelectionScreen(mood: '',),
            );
          case '/genreSelection':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => MovieGenreSelectionScreen(
                mood: args?['mood'] ?? 'Happy',
              ),
            );
          case '/movieRecommendations':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => MovieRecommendationsScreen(
                mood: args?['mood'] ?? 'Happy',
                genre: args?['genre'] ?? 'Drama',
              ),
            );
          case '/watchlist':
            return MaterialPageRoute(
              builder: (context) => WatchlistScreen(),
            );
          case '/movieDetails':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(
                movie: args?['movie'],
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(child: Text('Route not found')),
              ),
            );
        }
      },
    );
  }
}