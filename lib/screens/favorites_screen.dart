import 'package:flutter/material.dart';

import '../models/play.dart';
import '../widgets/play_card.dart';
import 'details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  final List<Play> plays = [
    Play(
      title: 'To the Show',
      duration: '2h 30min',
      genre: 'Drama, Comedy',
      location: 'Skopje, Macedonian National Theatre',
      description:
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse vitae turpis a libero.',
      imageUrl:
      'https://img.freepik.com/free-vector/hand-drawn-theatre-show-poster_23-2149828597.jpg', // Replace with actual image URL
    ),
    Play(
      title: 'Mystery Night',
      duration: '1h 45min',
      genre: 'Mystery, Thriller',
      location: 'Bitola, National Theatre',
      description:
      'A suspenseful drama that keeps you on the edge of your seat from start to finish.',
      imageUrl:
      'https://img.freepik.com/free-vector/hand-drawn-theatre-show-poster_23-2149828597.jpg', // Replace with actual image URL
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0), // Add 20px padding at the top
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
          ),
          itemCount: plays.length,
          itemBuilder: (context, index) {
            final play = plays[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(play: play),
                  ),
                );
              },
              child: PlayCard(play: play),
            );
          },
        ),
      ),
    );
  }
}