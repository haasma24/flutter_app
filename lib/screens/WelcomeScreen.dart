import 'package:flutter/material.dart';
import 'package:recommendation_app/screens/favorites_screen.dart';
import 'package:recommendation_app/screens/playlist_screen.dart'; // Import ajouté
import 'package:recommendation_app/screens/mood_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'music_recommendations.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentIndex = 0;
  String? _selectedMood;
  String? _selectedGenre;
  String? _userName;
  bool _showMusicRecommendations = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('username') ?? 'friend';
    });
  }

  void _onMoodSelected(Mood mood, String genre) {
    setState(() {
      _selectedMood = mood.name;
      _selectedGenre = genre;
      _showMusicRecommendations = true;
    });
  }

  void _resetMoodSelection() {
    setState(() {
      _showMusicRecommendations = false;
      _selectedMood = null;
      _selectedGenre = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Mood'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
            ).then((_) => setState(() => _currentIndex = 0));
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlaylistScreen(userId: 1)), // Utilisateur statique avec ID=1
            ).then((_) => setState(() => _currentIndex = 0));
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play),
            label: 'Playlists',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF328E6E),
              Color(0xFF67AE6E),
              Color(0xFF90C67C),
              Color(0xFFE1EEBC),
            ],
          ),
        ),
        child: _userName == null
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to your environment',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: _resetMoodSelection,
                      child: Text(
                        _selectedMood != null
                            ? 'Your mood: $_selectedMood ($_selectedGenre)'
                            : 'What\'s your mood for today, $_userName?',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Expanded(
                      child: _showMusicRecommendations && _selectedMood != null && _selectedGenre != null
                          ? MusicRecommendationsScreen(
                              mood: Mood(_selectedMood!, '', _selectedMood!.toLowerCase()),
                              selectedGenre: _selectedGenre!,
                              onBack: _resetMoodSelection,
                            )
                          : MoodSelectionScreen(
                              isEmbedded: true,
                              onMoodSelected: _onMoodSelected,
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}