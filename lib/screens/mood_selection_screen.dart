// lib/screens/mood_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:recommendation_app/screens/media_selection_screen.dart';

class MoodSelectionScreen extends StatelessWidget {
  final String userEmail;

  MoodSelectionScreen({super.key, required this.userEmail});

  final List<Mood> moods = [
    Mood('Happy', '😊', 'happy'),
    Mood('Sad', '😢', 'sad'),
    Mood('Energetic', '🤩', 'energetic'),
    Mood('Calm', '😌', 'calm'),
    Mood('Romantic', '🥰', 'romantic'),
    Mood('Angry', '😠', 'angry'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB2EBF2), // Pastel blue
              Color(0xFFB2DFDB), // Pastel teal
              Color(0xFFF8BBD0), // Pastel pink
            ],
            stops: [0.1, 0.5, 0.9],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  'How are you feeling today?\nChoose your mood!\n____________',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28, // Bigger
                    fontWeight: FontWeight.w800, // Bolder
                    color: const Color.fromARGB(221, 22, 22, 22), // Darker
                    fontFamily: 'Roboto',
                    height: 1.3, // Better line spacing
                  ),
                ),
              ),
              
              Expanded(
                child: Center(
                  child: GridView.count(
                    padding: EdgeInsets.all(30),
                    crossAxisCount: 2, // 2 per row
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 25,
                    childAspectRatio: 1,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: moods.map((mood) => 
                      MoodCard(
                        mood: mood,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MediaSelectionScreen(mood: mood.genre),
                            ),
                          );
                        },
                      ),
                    ).toList(),
                  ),
                ),
              ),
              
              SizedBox(height: 30), // Bottom spacing
            ],
          ),
        ),
      ),
    );
  }
}

class Mood {
  final String name;
  final String emoji;
  final String genre;

  Mood(this.name, this.emoji, this.genre);
}

class MoodCard extends StatelessWidget {
  final Mood mood;
  final VoidCallback onTap;

  const MoodCard({super.key, required this.mood, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorMap = {
      'happy': Color(0xFFFFF9C4), // Pastel yellow
      'sad': Color(0xFFB3E5FC), // Pastel blue
      'energetic': Color(0xFFFFCCBC), // Pastel orange
      'calm': Color(0xFFC8E6C9), // Pastel green
      'romantic': Color(0xFFF8BBD0), // Pastel pink
      'angry': Color(0xFFFFCDD2), // Light red
    };

    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: colorMap[mood.genre],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: onTap,
            splashColor: Colors.white.withOpacity(0.3),
            child: Container(
              constraints: BoxConstraints(
                minWidth: 150, // Minimum size
                minHeight: 150,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    mood.emoji,
                    style: TextStyle(fontSize: 48), // Bigger emoji
                  ),
                  SizedBox(height: 10),
                  Text(
                    mood.name,
                    style: TextStyle(
                      fontSize: 20, // Bigger text
                      fontWeight: FontWeight.w600, // Bolder
                      color: Colors.black87, // Darker
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}