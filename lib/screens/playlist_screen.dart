import 'package:flutter/material.dart';
import 'package:recommendation_app/model/music.dart';
import 'package:recommendation_app/services/playlist_service.dart';

class PlaylistScreen extends StatefulWidget {
  final int userId;

  const PlaylistScreen({required this.userId, Key? key}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final PlaylistService _playlistService = PlaylistService();
  late Future<List<Map<String, dynamic>>> _playlistsFuture;

  @override
  void initState() {
    super.initState();
    print('PlaylistScreen initState: userId = ${widget.userId}');
    _playlistsFuture = _fetchPlaylists();
  }

  Future<List<Map<String, dynamic>>> _fetchPlaylists() async {
    try {
      final playlists = await _playlistService.getUserPlaylists(widget.userId);
      print('Fetched playlists for user ${widget.userId}: $playlists');
      return playlists;
    } catch (e) {
      print('Error fetching playlists: $e');
      return [];
    }
  }

  void _refreshPlaylists() {
    setState(() {
      _playlistsFuture = _fetchPlaylists();
    });
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
                'Mes Playlists',
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
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _playlistsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    print('FutureBuilder error: ${snapshot.error}');
                    return Center(
                      child: Text(
                        'Erreur de chargement: ${snapshot.error}',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final playlists = snapshot.data ?? [];
                  if (playlists.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.playlist_add,
                            size: 60,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Aucune playlist',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Créez votre première playlist',
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
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = playlists[index];
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
                                Colors.white.withOpacity(0.15),
                                Colors.white.withOpacity(0.25),
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
                                Icons.playlist_play,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            title: Text(
                              playlist['name']?.toString() ?? 'Unnamed Playlist',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlaylistDetailScreen(
                                    playlistId: playlist['id'],
                                    playlistName: playlist['name']?.toString() ?? 'Unnamed Playlist',
                                  ),
                                ),
                              ).then((_) => _refreshPlaylists());
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF328E6E),
        onPressed: () => _showCreatePlaylistDialog(context),
      ),
    );
  }

  Future<void> _showCreatePlaylistDialog(BuildContext context) async {
    final nameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Color(0xFFE1EEBC),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Nouvelle Playlist',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF328E6E),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Nom de la playlist',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Annuler',
                        style: TextStyle(color: Color(0xFF328E6E)),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF328E6E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (nameController.text.isNotEmpty) {
                          try {
                            await _playlistService.createPlaylist(
                              widget.userId,
                              nameController.text,
                            );
                            Navigator.pop(context);
                            _refreshPlaylists();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Playlist créée avec succès'),
                                backgroundColor: Color(0xFF328E6E),
                              ),
                            );
                          } catch (e) {
                            print('Error creating playlist: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erreur lors de la création: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                        'Créer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PlaylistDetailScreen extends StatefulWidget {
  final int playlistId;
  final String playlistName;

  const PlaylistDetailScreen({
    required this.playlistId,
    required this.playlistName,
    Key? key,
  }) : super(key: key);

  @override
  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  final PlaylistService _playlistService = PlaylistService();
  late Future<List<Map<String, dynamic>>> _musicsFuture;

  @override
  void initState() {
    super.initState();
    print('PlaylistDetailScreen initState: playlistId = ${widget.playlistId}');
    _musicsFuture = _fetchMusics();
  }

  Future<List<Map<String, dynamic>>> _fetchMusics() async {
    try {
      final musics = await _playlistService.getPlaylistMusics(widget.playlistId);
      print('Fetched musics for playlist ${widget.playlistId}: $musics');
      return musics;
    } catch (e) {
      print('Error fetching playlist musics: $e');
      return [];
    }
  }

  void _refreshMusics() {
    setState(() {
      _musicsFuture = _fetchMusics();
    });
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
                widget.playlistName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _musicsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    print('FutureBuilder error in PlaylistDetailScreen: ${snapshot.error}');
                    return Center(
                      child: Text(
                        'Erreur de chargement: ${snapshot.error}',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final musics = snapshot.data ?? [];
                  if (musics.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.music_off,
                            size: 60,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Playlist vide',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Ajoutez des musiques',
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
                    itemCount: musics.length,
                    itemBuilder: (context, index) {
                      final music = musics[index];
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
                                Colors.white.withOpacity(0.15),
                                Colors.white.withOpacity(0.25),
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
                                Icons.music_note,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              music['title']?.toString() ?? 'Unknown Title',
                              style: TextStyle(
                                color: Colors.black,  // Changé en noir
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              music['artist']?.toString() ?? 'Unknown Artist',
                              style: TextStyle(
                                color: Colors.black87,  // Changé en noir
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red[200],
                              ),
                              onPressed: () async {
                                try {
                                  await _playlistService.removeMusicFromPlaylist(
                                    widget.playlistId,
                                    music['id'],
                                  );
                                  _refreshMusics();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Musique supprimée de la playlist'),
                                      backgroundColor: Color(0xFF328E6E),
                                    ),
                                  );
                                } catch (e) {
                                  print('Error removing music from playlist: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erreur lors de la suppression: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
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