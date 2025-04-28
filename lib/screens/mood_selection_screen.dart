import 'package:flutter/material.dart';
import 'package:recommendation_app/screens/music_recommendations.dart';

class MoodSelectionScreen extends StatefulWidget {
  final bool isEmbedded;
  final Function(Mood, String)? onMoodSelected;

  const MoodSelectionScreen({
    this.isEmbedded = false,
    this.onMoodSelected,
    Key? key,
  }) : super(key: key);

  @override
  _MoodSelectionScreenState createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  final List<Mood> moods = [
    Mood('Happy', '😊', 'happy'),
    Mood('Sad', '😢', 'sad'),
    Mood('Energetic', '⚡', 'energetic'),
    Mood('Calm', '🌿', 'calm'),
    Mood('Romantic', '❤️', 'romantic'),
    Mood('Angry', '😠', 'angry'),
  ];

  String? selectedMood;
  String? selectedGenre;
  List<String>? genres;
  bool showMusicRecommendations = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!widget.isEmbedded)
            AppBar(
              title: Text('How are you feeling today?'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          
          if (showMusicRecommendations && selectedMood != null && selectedGenre != null) ...[
            _buildMusicHeader(),
            Expanded(
              child: MusicRecommendationsScreen(
                mood: moods.firstWhere((m) => m.genre == selectedMood),
                selectedGenre: selectedGenre!,
                onBack: () {
                  setState(() {
                    showMusicRecommendations = false;
                  });
                },
              ),
            ),
          ] else if (selectedMood == null) ...[
            _buildMoodGrid(),
          ] else ...[
            _buildGenreSelection(),
          ],
        ],
      ),
    );
  }

  Widget _buildMusicHeader() {
    final mood = moods.firstWhere((m) => m.genre == selectedMood);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            '${mood.name} ${mood.emoji} • ${selectedGenre!.toUpperCase()}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                showMusicRecommendations = false;
              });
            },
            child: Text(
              '← Change genre',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodGrid() {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
        ),
        itemCount: moods.length,
        itemBuilder: (context, index) {
          final mood = moods[index];
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              setState(() {
                selectedMood = mood.genre;
                genres = _getGenresForMood(mood.genre);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(mood.emoji, style: TextStyle(fontSize: 40)),
                  SizedBox(height: 8),
                  Text(
                    mood.name,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenreSelection() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              selectedMood == 'sad'
                  ? 'Let\'s change your mood with some music'
                  : 'What do you want to hear today?',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: genres?.length ?? 0,
              itemBuilder: (context, index) {
                final genre = genres![index];
                return Card(
                  color: Colors.white.withOpacity(0.1),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      genre.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right, color: Colors.white),
                    onTap: () {
                      setState(() {
                        selectedGenre = genre;
                        showMusicRecommendations = true;
                      });
                      if (widget.onMoodSelected != null) {
                        final mood = moods.firstWhere((m) => m.genre == selectedMood);
                        widget.onMoodSelected!(mood, genre);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
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
}

class Mood {
  final String name;
  final String emoji;
  final String genre;

  Mood(this.name, this.emoji, this.genre);
}