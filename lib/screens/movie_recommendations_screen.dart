import 'package:flutter/material.dart';
import 'package:recommendation_app/model/movie_model.dart';
import 'package:recommendation_app/patterns/movie_decorator.dart';
import 'package:recommendation_app/patterns/movie_state.dart';
import 'package:recommendation_app/database/database_helper.dart';
import 'package:recommendation_app/screens/movie_details_screen.dart';
import 'package:recommendation_app/screens/watchlist_screen.dart';

class MovieRecommendationsScreen extends StatefulWidget {
  final String mood;
  final String genre;

  const MovieRecommendationsScreen({
    Key? key,
    required this.mood,
    required this.genre,
  }) : super(key: key);

  @override
  _MovieRecommendationsScreenState createState() => _MovieRecommendationsScreenState();
}

class _MovieRecommendationsScreenState extends State<MovieRecommendationsScreen> {
  late Future<List<Movie>> _moviesFuture;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    print('MovieRecommendationsScreen initialized with mood: ${widget.mood}, genre: ${widget.genre}');
    _moviesFuture = _loadMovies();
  }

  Future<List<Movie>> _loadMovies() async {
    // Normalize genre to match mock data (e.g., "drama" -> "Drama")
    final normalizedGenre = widget.genre.isNotEmpty
        ? widget.genre[0].toUpperCase() + widget.genre.substring(1).toLowerCase()
        : widget.genre;

    // Movie data with 2 movies per genre
    final mockMovies = [
      // Drama (2 movies)
      Movie(
        id: '1',
        title: 'The Shawshank Redemption',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BMDFkYTc0MGEtZmNhMC00ZDIzLWFmNTEtODM1ZmRlYWMwMWFmXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_.jpg',
        plot: 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
        actors: ['Tim Robbins', 'Morgan Freeman', 'Bob Gunton'],
        releaseDate: '1994-09-23',
        rating: 9.3,
        genre: 'Drama',
      ),
      Movie(
        id: '2',
        title: 'The Godfather',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BM2MyNjYxNmUtYTAwNi00MTYxLWJmNWYtYzZlODY3ZTk3OTFlXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_.jpg',
        plot: 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
        actors: ['Marlon Brando', 'Al Pacino', 'James Caan'],
        releaseDate: '1972-03-24',
        rating: 9.2,
        genre: 'Drama',
      ),
      // Action (2 movies)
      Movie(
        id: '4',
        title: 'The Dark Knight',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_.jpg',
        plot: 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
        actors: ['Christian Bale', 'Heath Ledger', 'Aaron Eckhart'],
        releaseDate: '2008-07-18',
        rating: 9.0,
        genre: 'Action',
      ),
      Movie(
        id: '5',
        title: 'Mad Max: Fury Road',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BN2EwM2I5OWMtMGQyMi00Zjg1LWJkNTctZTdjYTA4OGUwZjMyXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_.jpg',
        plot: 'In a post-apocalyptic wasteland, a woman rebels against a tyrannical ruler in search for her homeland with the aid of a group of female prisoners, a psychotic worshiper, and a drifter named Max.',
        actors: ['Tom Hardy', 'Charlize Theron', 'Nicholas Hoult'],
        releaseDate: '2015-05-15',
        rating: 8.1,
        genre: 'Action',
      ),
      // Comedy (2 movies)
      Movie(
        id: '7',
        title: 'The Hangover',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BNGQwZjg5YmYtY2VkNC00NzliLTljYTctNzI5NmU3MjE2ODQzXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_.jpg',
        plot: 'Three buddies wake up from a bachelor party in Las Vegas, with no memory of the previous night and the bachelor missing.',
        actors: ['Zach Galifianakis', 'Bradley Cooper', 'Ed Helms'],
        releaseDate: '2009-06-05',
        rating: 7.7,
        genre: 'Comedy',
      ),
      Movie(
        id: '8',
        title: 'Superbad',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BMTc0NjIyMjA2OF5BMl5BanBnXkFtZTcwMzIxNDE1MQ@@._V1_.jpg',
        plot: 'Two co-dependent high school seniors are forced to deal with separation anxiety after their plan to stage a booze-soaked party goes awry.',
        actors: ['Michael Cera', 'Jonah Hill', 'Christopher Mintz-Plasse'],
        releaseDate: '2007-08-17',
        rating: 7.6,
        genre: 'Comedy',
      ),
      // Horror (2 movies)
      Movie(
        id: '10',
        title: 'The Conjuring',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BMTM3NjA1NDMyMV5BMl5BanBnXkFtZTcwMDQzNDMzOQ@@._V1_.jpg',
        plot: 'Paranormal investigators Ed and Lorraine Warren work to help a family terrorized by a dark presence in their farmhouse.',
        actors: ['Patrick Wilson', 'Vera Farmiga', 'Ron Livingston'],
        releaseDate: '2013-07-19',
        rating: 7.5,
        genre: 'Horror',
      ),
      Movie(
        id: '12',
        title: 'Get Out',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BMjUxMDQwNjcyNl5BMl5BanBnXkFtZTgwNzcwMzc0MTI@._V1_.jpg',
        plot: 'A young African-American visits his white girlfriend\'s parents for the weekend, where his simmering uneasiness about their reception of him eventually reaches a boiling point.',
        actors: ['Daniel Kaluuya', 'Allison Williams', 'Bradley Whitford'],
        releaseDate: '2017-02-24',
        rating: 7.7,
        genre: 'Horror',
      ),
      // Romance (2 movies)
      Movie(
        id: '13',
        title: 'The Notebook',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BMTk3OTM5Njg5M15BMl5BanBnXkFtZTYwMzA0ODI3._V1_.jpg',
        plot: 'A poor yet passionate young man falls in love with a rich young woman, giving her a sense of freedom, but they are soon separated because of their social differences.',
        actors: ['Ryan Gosling', 'Rachel McAdams', 'James Garner'],
        releaseDate: '2004-06-25',
        rating: 7.8,
        genre: 'Romance',
      ),
      Movie(
        id: '14',
        title: 'La La Land',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BMzUzNDM2NzM2MV5BMl5BanBnXkFtZTgwNTM3NTg4OTE@._V1_.jpg',
        plot: 'While navigating their careers in Los Angeles, a pianist and an actress fall in love while attempting to reconcile their aspirations for the future.',
        actors: ['Ryan Gosling', 'Emma Stone', 'John Legend'],
        releaseDate: '2016-12-09',
        rating: 8.0,
        genre: 'Romance',
      ),
      // Sci-Fi (2 movies)
      Movie(
        id: '16',
        title: 'Inception',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_.jpg',
        plot: 'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
        actors: ['Leonardo DiCaprio', 'Joseph Gordon-Levitt', 'Ellen Page'],
        releaseDate: '2010-07-16',
        rating: 8.8,
        genre: 'Sci-Fi',
      ),
      Movie(
        id: '18',
        title: 'Interstellar',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BZjdkOTU3MDktN2IxOS00OGEyLWFmMjktY2FiMmZkNWIyODZiXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_.jpg',
        plot: 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
        actors: ['Matthew McConaughey', 'Anne Hathaway', 'Jessica Chastain'],
        releaseDate: '2014-11-07',
        rating: 8.6,
        genre: 'Sci-Fi',
      ),
      // Animation (2 movies)
      Movie(
        id: '19',
        title: 'Spirited Away',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BMjlmZmI5MDctNDE2YS00YWE0LWE5ZWItZDBhYWQ0NTcxNWRhXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_.jpg',
        plot: 'During her family\'s move to the suburbs, a sullen 10-year-old girl wanders into a world ruled by gods, witches, and spirits.',
        actors: ['Daveigh Chase', 'Suzanne Pleshette', 'Miyu Irino'],
        releaseDate: '2001-07-20',
        rating: 8.6,
        genre: 'Animation',
      ),
      Movie(
        id: '20',
        title: 'Toy Story',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BMDU2ZWJlMjktMTRhMy00ZTA5LWEzNDgtYmNmZTEwZTViZWJkXkEyXkFqcGdeQXVyNDQ2OTk4MzI@._V1_.jpg',
        plot: 'A cowboy doll is profoundly threatened and jealous when a new spaceman figure supplants him as top toy in a boy\'s room.',
        actors: ['Tom Hanks', 'Tim Allen', 'Don Rickles'],
        releaseDate: '1995-11-22',
        rating: 8.3,
        genre: 'Animation',
      ),
      // Documentary (2 movies)
      Movie(
        id: '22',
        title: 'Free Solo',
        imageUrl: 'https://th.bing.com/th/id/OIP.lr5jRkPgtqsOudWIa6ly5QHaKe?rs=1&pid=ImgDetMain',
        plot: 'Alex Honnold attempts to become the first person to ever free solo climb El Capitan.',
        actors: ['Alex Honnold', 'Tommy Caldwell', 'Jimmy Chin'],
        releaseDate: '2018-09-28',
        rating: 8.1,
        genre: 'Documentary',
      ),
      Movie(
        id: '24',
        title: 'My Octopus Teacher',
        imageUrl: 'https://media.greenmatters.com/brand-img/yOtEvCjId/356x499/my-octopus-teacher-netflix-1619125621657.jpg',
        plot: 'A filmmaker forges an unusual friendship with an octopus living in a South African kelp forest.',
        actors: ['Craig Foster', 'Tom Foster'],
        releaseDate: '2020-09-07',
        rating: 8.1,
        genre: 'Documentary',
      ),
    ];

    // Ensure database is initialized
    await _dbHelper.database;

    // Debug: Check all movies in database
    final db = await _dbHelper.database;
    final allMovies = await db.query('movies');
    print('All movies in database: ${allMovies.length}');

    // Get existing movies for the genre
    final existingMovies = await _dbHelper.getMoviesByGenre(normalizedGenre);
    print('Existing movies for genre $normalizedGenre: ${existingMovies.length}');

    // Insert mock data only if no movies exist for the genre
    if (existingMovies.isEmpty) {
      print('Inserting mock movies');
      await _dbHelper.insertMovies(mockMovies);
    }

    // Get movies from database
    final movies = await _dbHelper.getMoviesByGenre(normalizedGenre);
    print('Loaded movies for genre $normalizedGenre: ${movies.length}');

    // Temporary bypass of decorators to ensure movies display
    return movies;

    // Apply decorator pattern to get recommendations
    // final baseRecommendation = BaseMovieRecommendation(movies);
    // final moodBasedRecommendation = MoodBasedRecommendationDecorator(
    //   baseRecommendation,
    //   widget.mood,
    // );
    // final popularRecommendation = PopularRecommendationDecorator(
    //   moodBasedRecommendation,
    // );
    // final recommendedMovies = popularRecommendation.getMovies();
    // print('Recommended movies after decorators: ${recommendedMovies.length}');
    // return recommendedMovies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '${widget.genre} Movies for ${widget.mood} mood',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/watchlist');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.red));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No movies found for ${widget.genre}', style: TextStyle(color: Colors.white)));
          }

          final movies = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return NetflixMovieCard(movie: movie);
            },
          );
        },
      ),
    );
  }
}

class NetflixMovieCard extends StatefulWidget {
  final Movie movie;

  const NetflixMovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  _NetflixMovieCardState createState() => _NetflixMovieCardState();
}

class _NetflixMovieCardState extends State<NetflixMovieCard> {
  final MovieStateContext _stateContext = MovieStateContext();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () => _stateContext.handle(context, widget.movie),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.movie.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 250,
                    color: Colors.grey[800],
                    child: Center(child: Icon(Icons.error, color: Colors.white)),
                  ),
                ),
              ),
              // Gradient overlay
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              // Movie info
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.movie.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 18),
                        SizedBox(width: 4),
                        Text(
                          '${widget.movie.rating}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(width: 16),
                        Text(
                          widget.movie.releaseDate.substring(0, 4),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Watchlist button
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: Icon(
                    widget.movie.isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                    color: widget.movie.isInWatchlist ? Colors.red : Colors.white,
                    size: 32,
                  ),
                  onPressed: () => _toggleWatchlist(),
                ),
              ),
              // Hover effect
              if (_isHovering)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(0.4),
                      border: Border.all(color: Colors.red, width: 3),
                    ),
                    child: Center(
                      child: Icon(Icons.play_arrow, color: Colors.white, size: 60),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleWatchlist() async {
    const userId = 1; // In a real app, use actual user ID

    setState(() {
      widget.movie.isInWatchlist = !widget.movie.isInWatchlist;
    });

    if (widget.movie.isInWatchlist) {
      await _dbHelper.addToWatchlist(widget.movie.id, userId);
      _stateContext.setState(WatchlistMovieState());
      _stateContext.handle(context, widget.movie);
    } else {
      await _dbHelper.removeFromWatchlist(widget.movie.id, userId);
      _stateContext.setState(DefaultMovieState());
    }
  }
}