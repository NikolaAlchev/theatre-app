import 'package:flutter/material.dart';

import '../models/play.dart';

class DetailsScreen extends StatelessWidget {
  final Play play;

  DetailsScreen({required this.play});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        title: Text(play.title, style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              play.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
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
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),
            Text(
              play.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              '${play.duration} • ${play.genre}',
              style: TextStyle(color: Colors.grey[400]),
            ),
            SizedBox(height: 8),
            Text(
              'Location: ${play.location}',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              play.description,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Handle Buy Ticket functionality
          },
          child: Text('BUY TICKET', style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 182, 0, 0), // Make the button red
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }
}
