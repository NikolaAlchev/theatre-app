import 'package:flutter/material.dart';
import 'package:theatre_app/screens/home_screen.dart';
import 'package:theatre_app/screens/map_screen.dart';
import 'package:theatre_app/screens/search_screen.dart';
import 'package:theatre_app/screens/favorites_screen.dart';
import 'package:theatre_app/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of pages to display based on selected index
  final List<Widget> _pages = [
    HomeScreen(),
    MapScreen(),
    SearchScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  // This function updates the selected index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 46, 46, 46),
        elevation: 0,
        title: const Center(
          // Center the text
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Theatre",
              style: TextStyle(
                color: Color.fromARGB(255, 190, 185, 185),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: _pages[_selectedIndex], // Render the selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.theater_comedy, size: 30), label: 'Theatre'),
          BottomNavigationBarItem(
              icon: Icon(Icons.map, size: 30), label: 'Map'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded, size: 30), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite, size: 30), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30), label: 'Profile'),
        ],
        selectedItemColor: const Color.fromARGB(255, 182, 0, 0),
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color.fromARGB(255, 46, 46, 46),
      ),
    );
  }
}
