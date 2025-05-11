import 'package:flutter/material.dart';
import '../models/play.dart';
import '../plays_data.dart';
import './details_screen.dart';
import '../widgets/play_card.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activeTab = "REPERTOIRE";
  String? selectedLocation;
  DateTime? selectedDate;

  List<Play> allPlays = PlayRepository().plays;
  List<Play> filteredPlays = [];

  @override
  void initState() {
    super.initState();
    filteredPlays = allPlays;
  }

  List<String> getUniqueLocations() {
    Set<String> locations = {'All'};
    for (var play in allPlays) {
      locations.add(play.location);
    }
    return locations.toList();
  }

  void _applyFilters() {
    setState(() {
      filteredPlays = allPlays.where((play) {
        bool matchesLocation = selectedLocation == null ||
            selectedLocation == 'All' ||
            play.location.toLowerCase() == selectedLocation!.toLowerCase();

        bool matchesDate = true;
        if (selectedDate != null) {
          DateTime? playDate;

          try {
            playDate = DateFormat('yyyy-MM-dd').parse(play.date);
          } catch (_) {
            return false;
          }

          matchesDate = playDate.year == selectedDate!.year &&
              playDate.month == selectedDate!.month &&
              playDate.day == selectedDate!.day;
        }

        return matchesLocation && matchesDate;
      }).toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        backgroundColor: const Color.fromARGB(255, 46, 46, 46),
        elevation: 0,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['REPERTOIRE', 'SOON'].map((tab) {
                bool isActive = tab == activeTab;
                return Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            activeTab = tab;
                          });
                        },
                        child: Text(
                          tab,
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 3,
                        color: isActive ? Colors.white : const Color.fromARGB(255, 46, 46, 46),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: Column(
            children: [
              Container(
                height: 60,
                color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Location Filter
                      DropdownButton<String>(
                        value: selectedLocation,
                        dropdownColor: Colors.black,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down, color: Color.fromARGB(255, 190, 185, 185)),
                        items: getUniqueLocations()
                            .map((String value) => DropdownMenuItem<String>(
                          value: value == 'All' ? null : value,
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(value, style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ))
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedLocation = value;
                          });
                          _applyFilters();
                        },
                        hint: const Row(
                          children: [
                            Icon(Icons.location_on, color: Color.fromARGB(255, 190, 185, 185), size: 30),
                            SizedBox(width: 8),
                            Text("Locations", style: TextStyle(color: Color.fromARGB(255, 190, 185, 185))),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Date Picker
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                selectedDate == null
                                    ? 'Select Date'
                                    : DateFormat('yyyy-MM-dd').format(selectedDate!),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(height: 2, color: Colors.white),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: GridView.builder(
          itemCount: filteredPlays.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final play = filteredPlays[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailsScreen(play: play)),
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
