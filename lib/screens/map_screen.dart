import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../google_maps.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // List of Macedonian theatres with names and coordinates
  final List<Map<String, dynamic>> macedonianTheatres = [
    {'name': 'Macedonian National Theatre', 'lat': 41.9961, 'lng': 21.4316},
    {'name': 'Drama Theatre Skopje', 'lat': 41.9945, 'lng': 21.4398},
    {'name': 'Theatre for Children and Youth', 'lat': 41.9956, 'lng': 21.4332},
    {'name': 'Bitola National Theatre', 'lat': 41.0328, 'lng': 21.3420},
    {'name': 'Vojdan Chernodrinski Theatre', 'lat': 41.3328, 'lng': 21.5553},
  ];

  String title = 'Choose a Theatre'; // Default title
  int? selectedIndex; // To store the currently selected index
  final MapController _mapController = MapController(); // MapController for controlling the map
  final double zoomInLevel = 15.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              title, // Dynamic title
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlutterMap(
                mapController: _mapController, // Pass the controller to the map
                options: const MapOptions(
                  initialCenter: LatLng(41.9981, 21.4254),
                  initialZoom: 7, // Zoomed out to see multiple pins
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'mk.ukim.finki.mis',
                  ),
                  MarkerLayer(
                    markers: macedonianTheatres.map((theatre) {
                      int index = macedonianTheatres.indexOf(theatre);
                      bool isSelected = selectedIndex == index;
                      return Marker(
                        point: LatLng(theatre['lat'], theatre['lng']),
                        width: 100,
                        height: 100,
                        child: GestureDetector(
                          onTap: () {
                            if (selectedIndex == index) {
                              // If the clicked pin is the selected one, show the dialog
                              _showAlertDialog(theatre['name'], theatre['lat'], theatre['lng']);
                            } else {
                              // If it's a new pin, update the title and select it
                              setState(() {
                                title = theatre['name'];
                                selectedIndex = index;
                              });
                              // Smoothly zoom into the selected pin
                              _zoomToLocation(LatLng(theatre['lat'], theatre['lng']));
                            }
                          },
                          child: Icon(
                            Icons.theater_comedy,
                            color: isSelected ? Colors.red : Colors.black,
                            size: 30,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Smooth zoom to a location with animation
  void _zoomToLocation(LatLng targetLocation) {
    double zoomLevel = zoomInLevel;
    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      // Gradually zoom in and move to the new location
      if (_mapController.zoom < zoomLevel) {
        _mapController.move(targetLocation, _mapController.zoom + 0.18);
      } else {
        _mapController.move(targetLocation, zoomLevel); // Set exact zoom level
        timer.cancel(); // Stop the timer once zoom is reached
      }
    });
  }

  // Function to show an alert dialog with theatre name
  Future<void> _showAlertDialog(String name, double lat, double lng) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 27, 27, 27), // Dark background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          title: Text(
            'Visit $name?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Do you want to open Google Maps for routing?',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                GoogleMaps.openGoogleMaps(lat, lng);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Open',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
