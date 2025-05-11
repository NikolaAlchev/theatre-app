import 'package:flutter/material.dart';
import '../models/play.dart';
import '../plays_data.dart'; // This gives access to PlayRepository
import './details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Play> _allPlays = [];
  List<Play> _filteredPlays = [];

  @override
  void initState() {
    super.initState();
    _allPlays = PlayRepository().plays;
    _filteredPlays = _allPlays;
  }

  void _filterPlays(String query) {
    setState(() {
      _filteredPlays = _allPlays.where((play) {
        final lowerQuery = query.toLowerCase();
        return play.title.toLowerCase().contains(lowerQuery) ||
            play.description.toLowerCase().contains(lowerQuery) ||
            play.location.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: _filterPlays,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                fillColor: Colors.black,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _filteredPlays.isEmpty
                  ? const Center(
                child: Text('No results found.', style: TextStyle(color: Colors.grey)),
              )
                  : ListView.builder(
                itemCount: _filteredPlays.length,
                itemBuilder: (context, index) {
                  final play = _filteredPlays[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    leading: Image.network(play.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(play.title, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(play.location, style: const TextStyle(color: Colors.grey)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(play: play),
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
