import 'package:flutter/material.dart';
import 'package:recommendation_app/screens/media_selection_screen.dart';
import 'package:recommendation_app/screens/favorites_screen.dart';
import 'package:recommendation_app/screens/music_recommendations.dart';
import 'package:recommendation_app/screens/playlist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodSelectionScreen extends StatefulWidget {
  final String userEmail;

  const MoodSelectionScreen({super.key, required this.userEmail});

  @override
  _MoodSelectionScreenState createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  String? selectedMood;
  String? selectedGenre;
  List<String>? genres;
  String? userName;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? 'Friend';
    });
  }

  List<String> _getGenresForMood(String mood) {
    final moodGenres = {
      'happy': ['pop', 'disco', 'funk'],
      'sad': ['blues', 'jazz', 'ballad'],
      'energetic': ['rock', 'metal', 'edm'],
      'calm': ['classical', 'ambient', 'lo-fi'],
      'romantic': ['pop', 'r&b', 'soul'],
      'angry': ['metal', 'punk', 'hard rock'],
    };
    return moodGenres[mood] ?? ['pop'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) async {
          setState(() => _currentIndex = index);
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesScreen()),
            ).then((_) => setState(() => _currentIndex = 0));
          } else if (index == 2) {
            final userId = await _getUserId(widget.userEmail);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlaylistScreen(userId: userId)),
            ).then((_) => setState(() => _currentIndex = 0));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.playlist_play), label: 'Playlists'),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
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
                  userName == null
                      ? 'How are you feeling today?\nChoose your mood!\n____________'
                      : 'How are you feeling today?\nChoose your mood!\n____________',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(221, 22, 22, 22),
                    fontFamily: 'Roboto',
                    height: 1.3,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: selectedMood == null
                      ? _buildMoodGrid()
                      : _buildGenreSelection(),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodGrid() {
    final List<Mood> moods = [
      Mood('Happy', '😊', 'happy'),
      Mood('Sad', '😢', 'sad'),
      Mood('Energetic', '🤩', 'energetic'),
      Mood('Calm', '😌', 'calm'),
      Mood('Romantic', '🥰', 'romantic'),
      Mood('Angry', '😠', 'angry'),
    ];

    return GridView.count(
      padding: const EdgeInsets.all(30),
      crossAxisCount: 2,
      mainAxisSpacing: 25,
      crossAxisSpacing: 25,
      childAspectRatio: 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: moods
          .map((mood) => MoodCard(
                mood: mood,
                onTap: () {
                  setState(() {
                    selectedMood = mood.genre;
                    genres = _getGenresForMood(mood.genre);
                  });
                },
              ))
          .toList(),
    );
  }

  Widget _buildGenreSelection() {
    return GridView.count(
      padding: const EdgeInsets.all(30),
      crossAxisCount: 2,
      mainAxisSpacing: 25,
      crossAxisSpacing: 25,
      childAspectRatio: 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: genres
        ?.map((genre) => GenreCard(
              genre: genre,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MusicRecommendationsScreen(
                      mood: selectedMood!,
                      selectedGenre: genre,
                    ),
                  ),
                );
              },
            ))
        ?.toList() ?? [],
  );
}

  Future<int> _getUserId(String email) async {
    // TODO: Implement user ID fetching (e.g., from database or SharedPreferences)
    // Placeholder: Hash email or query database
    return 1;
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
      'happy': const Color(0xFFFFF9C4), // Pastel yellow
      'sad': const Color(0xFFB3E5FC), // Pastel blue
      'energetic': const Color(0xFFFFCCBC), // Pastel orange
      'calm': const Color(0xFFC8E6C9), // Pastel green
      'romantic': const Color(0xFFF8BBD0), // Pastel pink
      'angry': const Color(0xFFFFCDD2), // Light red
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
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: onTap,
            splashColor: Colors.white.withOpacity(0.3),
            child: Container(
              constraints: const BoxConstraints(minWidth: 150, minHeight: 150),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    mood.emoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    mood.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
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

class GenreCard extends StatelessWidget {
  final String genre;
  final VoidCallback onTap;

  const GenreCard({super.key, required this.genre, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: onTap,
            splashColor: Colors.white.withOpacity(0.3),
            child: Container(
              constraints: const BoxConstraints(minWidth: 150, minHeight: 150),
              child: Center(
                child: Text(
                  genre.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}