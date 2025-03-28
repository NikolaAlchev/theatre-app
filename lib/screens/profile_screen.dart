import 'package:flutter/material.dart';
import 'package:theatre_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/play.dart';
import '../plays_data.dart';
import '../widgets/play_card.dart';
import 'details_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showTickets = true;
  late final Future<Map<String, String>> _userDataFuture;

  List<Play> boughtPlays = [];
  List<Play> plays = PlayRepository().plays;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchBoughtPlays();
    _userDataFuture = AuthService.getCurrentUser();
  }

  Future<void> fetchBoughtPlays() async {
    if (user == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        List<dynamic> boughtPlaysTitles =
            userDoc['boughtPlays'] ?? []; // Get list of boughtPlays titles

        // Filter the plays list to include only favorite plays
        setState(() {
          boughtPlays = plays
              .where((play) => boughtPlaysTitles.contains(play.title))
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
      body: Column(
        children: [
          // Top Section with Name and Arrow
          Container(
            color: Colors.black,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  // User's Name
                  Expanded(
                    child: FutureBuilder<Map<String, String>>(
                      future: _userDataFuture,
                      builder: (context, snapshot) {
                        String fullName = '';
                        if (snapshot.hasData) {
                          fullName = snapshot.data!['fullName'] ?? 'N/A';
                        } else if (snapshot.hasError) {
                          fullName = 'Error loading name';
                        }
                        return Text(
                          fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  // Arrow Icon Button
                  IconButton(
                    icon: Icon(
                      showTickets
                          ? Icons.arrow_forward_ios
                          : Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        showTickets = !showTickets;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: showTickets ? _buildTicketsView() : _buildUserInfoView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsView() {
    if (boughtPlays.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.theaters,
              size: 70,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              'My Tickets',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Column(
          children: [
            // Title for bought tickets
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'My Bought Tickets',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10), // Add some space between title and grid
            // Grid of bought tickets
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemCount: boughtPlays.length,
                itemBuilder: (context, index) {
                  final play = boughtPlays[index];
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
          ],
        ),
      );
    }
  }

  Widget _buildUserInfoView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FutureBuilder<Map<String, String>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user data found.'));
          }

          final userData = snapshot.data!;
          String fullName = userData['fullName'] ?? 'N/A';
          List<String> nameParts = fullName.split(' ');
          String name = nameParts.isNotEmpty ? nameParts[0] : 'N/A';
          String surname =
              nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'N/A';
          String dateOfBirth = userData['dateOfBirth'] ?? 'N/A';
          String username = userData['username'] ?? 'N/A';

          return Column(
            children: [
              _buildTextField(label: 'Name', value: name),
              _buildTextField(label: 'Surname', value: surname),
              _buildDateField(label: 'Date of Birth', value: dateOfBirth),
              _buildTextField(label: 'Username', value: username),
              _buildPasswordField(label: 'Current Password'),
              _buildPasswordField(label: 'New Password'),
              const SizedBox(height: 20),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 250,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await AuthService().logout(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 46, 46, 46),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'LOG OUT',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateField({required String label, required String value}) {
    TextEditingController controller = TextEditingController(text: value);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.black,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              controller.text =
                  "${pickedDate?.day.toString().padLeft(2, '0')}.${pickedDate?.month.toString().padLeft(2, '0')}.${pickedDate?.year}";
            },
          ),
        ),
        style: const TextStyle(color: Colors.white),
        readOnly: true,
      ),
    );
  }

  Widget _buildTextField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.black,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
        style: const TextStyle(color: Colors.white),
        controller: TextEditingController(text: value),
        readOnly: label == 'Date of Birth',
      ),
    );
  }

  Widget _buildPasswordField({required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.black,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
