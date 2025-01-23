import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10), // Reduced height
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                fillColor: Colors.black,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded edges
                  borderSide: const BorderSide(color: Colors.white, width: 1.5), // White border
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded edges
                  borderSide: const BorderSide(color: Colors.white, width: 1.5), // White border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded edges
                  borderSide: const BorderSide(color: Colors.white, width: 1.5), // White border
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: Center(
                child: Text(
                  'No search results yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}