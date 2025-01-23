import 'package:flutter/material.dart';
import '../models/play.dart';

class PlayCard extends StatefulWidget {
  final Play play;

  PlayCard({required this.play});

  @override
  _PlayCardState createState() => _PlayCardState();
}

class _PlayCardState extends State<PlayCard> {
  // Variable to track whether the play is in favorites or not
  bool isFavorite = false;

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
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
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
                onPressed: () {
                  // Toggle the favorite state
                  setState(() {
                    isFavorite = !isFavorite;
                  });

                  // Add your logic here to handle adding/removing from favorites
                  print(isFavorite ? 'Added to favorites' : 'Removed from favorites');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
