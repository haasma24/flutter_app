import 'package:flutter/material.dart';
import 'package:recommendation_app/model/music.dart';
import 'package:recommendation_app/screens/music_tile.dart';
import 'package:recommendation_app/services/music_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _musicService = MusicService();
  final _searchController = TextEditingController();
  List<Music> _results = [];

  void _search(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    
    final results = await _musicService.searchMusic(query);
    setState(() => _results = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher des musiques...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                return MusicTile(music: _results[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}