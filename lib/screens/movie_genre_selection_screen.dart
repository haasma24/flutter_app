import 'package:flutter/material.dart';
import 'package:recommendation_app/screens/watchlist_screen.dart';

class MovieGenreSelectionScreen extends StatelessWidget {
  final String mood;
  final List<Map<String, String>> genres = const [
    {
      'name': 'Action',
      'desc': 'High-energy films with physical stunts and chases'
    },
    {
      'name': 'Comedy',
      'desc': 'Light-hearted stories designed to amuse and entertain'
    },
    {
      'name': 'Drama',
      'desc': 'Serious, plot-driven stories portraying realistic characters'
    },
    {
      'name': 'Horror',
      'desc': 'Films designed to frighten and invoke our fears'
    },
    {
      'name': 'Romance',
      'desc': 'Stories of love and emotional relationships'
    },
    {
      'name': 'Sci-Fi',
      'desc': 'Futuristic concepts of science and technology'
    },
    {
      'name': 'Animation',
      'desc': 'Artistically animated stories for all ages'
    },
    {
      'name': 'Documentary',
      'desc': 'Non-fictional motion pictures documenting reality'
    },
  ];

  const MovieGenreSelectionScreen({Key? key, required this.mood}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Genre', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF222222),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/watchlist');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.grey[900]!],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Movie Recommendations',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Here are the following genres. Select any genre you like to watch and you\'ll get a gallery of movies recommended just for you!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 30),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.9,
                ),
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  return GenreCard(
                    genre: genres[index]['name']!,
                    description: genres[index]['desc']!,
                    color: _getGenreColor(genres[index]['name']!),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/movieRecommendations',
                        arguments: {
                          'mood': mood,
                          'genre': genres[index]['name']!,
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getGenreColor(String genre) {
    switch (genre) {
      case 'Action':
        return Color(0xFFFF5252); // Red
      case 'Comedy':
        return Color(0xFFFFD740); // Amber
      case 'Drama':
        return Color(0xFF64B5F6); // Blue
      case 'Horror':
        return Color(0xFFBA68C8); // Purple
      case 'Romance':
        return Color(0xFFF06292); // Pink
      case 'Sci-Fi':
        return Color(0xFF4DB6AC); // Teal
      case 'Animation':
        return Color(0xFFFF8A65); // Deep Orange
      case 'Documentary':
        return Color(0xFF9575CD); // Deep Purple
      default:
        return Colors.grey;
    }
  }
}

class GenreCard extends StatelessWidget {
  final String genre;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const GenreCard({
    required this.genre,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                genre,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  fontFamily: 'Roboto',
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.chevron_right,
                  size: 30,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}