import 'package:flutter/material.dart';
import 'package:recommendation_app/model/movie_model.dart';
import 'package:recommendation_app/database/database_helper.dart';
import 'package:recommendation_app/screens/movie_details_screen.dart';

class WatchlistScreen extends StatefulWidget {
  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  late Future<List<Movie>> _watchlistFuture;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _watchlistFuture = _loadWatchlist();
  }

  Future<List<Movie>> _loadWatchlist() async {
    const userId = 1;
    return await _dbHelper.getWatchlistMovies(userId);
  }

  Future<void> _refresh() async {
    setState(() {
      _watchlistFuture = _loadWatchlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('My Watchlist', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Movie>>(
          future: _watchlistFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.red));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading watchlist', style: TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Your watchlist is empty', style: TextStyle(color: Colors.white)));
            }

            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final movie = snapshot.data![index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        movie.imageUrl,
                        width: 50,
                        height: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(Icons.movie, color: Colors.white),
                      ),
                    ),
                    title: Text(movie.title, style: TextStyle(color: Colors.white)),
                    subtitle: Text('⭐ ${movie.rating}', style: TextStyle(color: Colors.white70)),
                    trailing: IconButton(
                      icon: Icon(Icons.bookmark, color: Colors.red),
                      onPressed: () => _removeFromWatchlist(movie),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieDetailsScreen(movie: movie),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _removeFromWatchlist(Movie movie) async {
    const userId = 1;
    await _dbHelper.removeFromWatchlist(movie.id, userId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed from watchlist')),
    );
    _refresh();
  }
}