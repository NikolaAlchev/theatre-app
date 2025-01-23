import 'package:flutter/material.dart';
import 'package:theatre_app/screens/map_screen.dart';
import 'package:theatre_app/screens/profile_screen.dart';
import 'package:theatre_app/screens/search_screen.dart';
import 'package:theatre_app/screens/favorites_screen.dart';
import 'package:theatre_app/screens/home_screen.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigationBarWidget({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: (index) {
        onItemTapped(index);
        // Handle navigation based on selected index
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MapScreen()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
            );
            break;
          case 4:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
            break;
          default:
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.theater_comedy, size: 30), label: 'Theatre'),
        BottomNavigationBarItem(icon: Icon(Icons.map, size: 30), label: 'Map'),
        BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded, size: 30), label: 'Search'),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: 30), label: 'Favorites'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30), label: 'Profile'),
      ],
      selectedItemColor: const Color.fromARGB(255, 182, 0, 0),
      unselectedItemColor: Colors.grey,
    );
  }
}
