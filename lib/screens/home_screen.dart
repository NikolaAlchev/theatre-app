import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/play.dart';
import '../plays_data.dart';
import './details_screen.dart';
import '../widgets/play_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activeTab = "REPERTOIRE";

  List<Play> plays = PlayRepository().plays;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        titleSpacing: 0,
        backgroundColor: const Color.fromARGB(255, 46, 46, 46),
        elevation: 0,
        title: Column(
          children: [
            Column(
              children: [
                // Row for REPERTOIRE and SOON
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // First Column: REPERTOIRE
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                activeTab = "REPERTOIRE";
                              });
                            },
                            child: Text(
                              "REPERTOIRE",
                              style: TextStyle(
                                color: activeTab == "REPERTOIRE"
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontSize: 16,
                                fontWeight: activeTab == "REPERTOIRE"
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6), // Add some space
                          Container(
                            height: 3,
                            color: activeTab == "REPERTOIRE"
                                ? Colors.white
                                : const Color.fromARGB(255, 46, 46, 46),
                          ),
                        ],
                      ),
                    ),

                    // Second Column: SOON
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                activeTab = "SOON";
                              });
                            },
                            child: Text(
                              "SOON",
                              style: TextStyle(
                                color: activeTab == "SOON"
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontSize: 16,
                                fontWeight: activeTab == "SOON"
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 3,
                            color: activeTab == "SOON"
                                ? Colors.white
                                : const Color.fromARGB(255, 46, 46, 46),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(25.0),
          child: Column(
            children: [
              Container(
                height: 50,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        dropdownColor: Colors.black,
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 190, 185, 185),
                        ),
                        items: <String>[
                          'Location 1',
                          'Location 2',
                          'Location 3'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                // Space between icon and text
                                Text(
                                  value,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {},
                        hint: const Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Color.fromARGB(255, 190, 185, 185),
                              size: 30,
                            ),
                            SizedBox(width: 8), // Space between icon and text
                            Text(
                              "Locations",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 190, 185, 185)),
                            ),
                          ],
                        ),
                      ),
                      DropdownButton<String>(
                        dropdownColor: Colors.black,
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.arrow_drop_down, // Show default dropdown arrow
                          color: Color.fromARGB(255, 190, 185, 185),
                        ),
                        items: <String>['Today', 'Tomorrow', 'Next Week']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                // Space between icon and text
                                Text(
                                  value,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {},
                        hint: const Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Color.fromARGB(255, 190, 185, 185),
                              size: 25,
                            ),
                            SizedBox(width: 8), // Space between icon and text
                            Text(
                              "Today",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 190, 185, 185)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // White line under the container
              Container(
                height: 2, // Height of the line
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
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
