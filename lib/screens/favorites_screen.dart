import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/play.dart';
import '../widgets/play_card.dart';
import 'details_screen.dart';
import '../plays_data.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Play> favoritePlays = [];
  List<Play> plays = PlayRepository().plays;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchFavoritePlays();
  }

  Future<void> fetchFavoritePlays() async {
    if (user == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        List<dynamic> favoriteTitles =
            userDoc['favorites'] ?? []; // Get list of favorite titles

        // Filter the plays list to include only favorite plays
        setState(() {
          favoritePlays = plays
              .where((play) => favoriteTitles.contains(play.title))
              .toList();
        });
      }
    } catch (e) {
      print("Error fetching favorites: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: favoritePlays.isEmpty
            ? const Center(
                child: Text(
                  'There are no favorite plays',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemCount: favoritePlays.length,
                itemBuilder: (context, index) {
                  final play = favoritePlays[index];
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
