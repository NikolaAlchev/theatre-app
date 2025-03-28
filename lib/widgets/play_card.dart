import 'package:flutter/material.dart';
import '../models/play.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlayCard extends StatefulWidget {
  final Play play;

  PlayCard({required this.play});

  @override
  _PlayCardState createState() => _PlayCardState();
}

class _PlayCardState extends State<PlayCard> {
  bool isFavorite = false;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  // Check if the play is in the user's favorites
  Future<void> _checkIfFavorite() async {
    if (user == null) return;

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);
    final userDoc = await userRef.get();

    List<String> favoriteTitles = List<String>.from(userDoc['favorites'] ?? []);

    setState(() {
      isFavorite = favoriteTitles.contains(widget.play.title);
    });
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String title) async {
    if (user == null) return;

    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);
    DocumentSnapshot userDoc = await userRef.get();

    List<String> favoriteTitles = [];

    // Check if 'favorites' field exists
    if (userDoc.exists && userDoc.data() is Map<String, dynamic>) {
      var data = userDoc.data() as Map<String, dynamic>;
      if (data.containsKey('favorites')) {
        favoriteTitles = List<String>.from(data['favorites']);
      }
    }

    setState(() {
      if (favoriteTitles.contains(title)) {
        favoriteTitles.remove(title);
        isFavorite = false;
      } else {
        favoriteTitles.add(title);
        isFavorite = true;
      }
    });

    // Update or create the 'favorites' field
    await userRef.set({'favorites': favoriteTitles}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  widget.play.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child:
                        Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            child: Container(
              height: 45.0,
              width: 45.0,
              decoration: const BoxDecoration(
                color: Color.fromARGB(160, 28, 28, 28),
                shape: BoxShape.rectangle,
              ),
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: const Color.fromARGB(255, 182, 0, 0),
                  size: 30.0,
                ),
                onPressed: () => toggleFavorite(widget.play.title),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
