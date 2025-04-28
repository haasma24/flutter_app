import 'package:flutter/material.dart';
import 'package:recommendation_app/screens/mood_selection_screen.dart';
import 'package:recommendation_app/screens/movie_genre_selection_screen.dart';
import 'package:recommendation_app/screens/music_recommendations.dart';

class MediaSelectionScreen extends StatelessWidget {
  final String mood;
  final String genre;

  const MediaSelectionScreen({
    super.key,
    required this.mood,
    this.genre = 'pop', // Default genre for backward compatibility
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What would you like to explore?'),
        backgroundColor: const Color.fromARGB(255, 203, 202, 202),
      ),
      body: Container(
        color: const Color.fromARGB(255, 235, 227, 227),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Music Section (Top Half)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                      Navigator.push(
                       context,
                       MaterialPageRoute(
                       builder: (context) => MoodSelectionScreen(
                       userEmail: '', // Pass empty or get from context
                        ),
                       ),
                     );
                    },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 28, 175, 82), // green
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.music_note, size: 80, color: Colors.white),
                          SizedBox(height: 20),
                          Text(
                            'MUSIC',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Discover songs that match your mood',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Movies Section (Bottom Half)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieGenreSelectionScreen(mood: mood),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFC92E2E), // Pastel red
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.movie, size: 80, color: Colors.white),
                          SizedBox(height: 20),
                          Text(
                            'MOVIES',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Find films that suit your current vibe',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}