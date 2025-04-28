import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:recommendation_app/model/music.dart';
import 'package:recommendation_app/services/music_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Music>> _favoritesFuture;
  final MusicService _musicService = MusicService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _currentlyPlayingId;

  @override
  void initState() {
    super.initState();
    _refreshFavorites();
  }

  void _refreshFavorites() {
    setState(() {
      _favoritesFuture = _musicService.getFavoriteMusics();
    });
  }

  Future<void> _playMusic(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          children: [
            AppBar(
              title: Text(
                'Musiques Favorites',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            Expanded(
              child: FutureBuilder<List<Music>>(
                future: _favoritesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erreur de chargement',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final favorites = snapshot.data ?? [];
                  
                  if (favorites.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 60,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Aucune musique favorite',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Ajoutez des musiques à vos favoris',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final music = favorites[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.5),  // Plus clair pour mieux voir le texte noir
                                Colors.white.withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _currentlyPlayingId == music.id 
                                    ? Icons.pause 
                                    : Icons.play_arrow,
                                color: Colors.black,  // Icône en noir
                              ),
                            ),
                            title: Text(
                              music.title,
                              style: TextStyle(
                                color: Colors.black,  // Texte en noir
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              music.artist,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),  // Texte en gris foncé
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.red[400],
                              ),
                              onPressed: () async {
                                await _musicService.toggleFavorite(music.id, false);
                                _refreshFavorites();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Retiré des favoris'),
                                    backgroundColor: Color(0xFF328E6E),
                                  ),
                                );
                              },
                            ),
                            onTap: () async {
                              setState(() {
                                _currentlyPlayingId = 
                                    _currentlyPlayingId == music.id ? null : music.id;
                              });
                              if (_currentlyPlayingId == music.id) {
                                // await _playMusic(music.audioUrl);
                              } else {
                                await _audioPlayer.stop();
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}