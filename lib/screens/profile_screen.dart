import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:theatre_app/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showTickets = true; // State to toggle between tickets and user info

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        body: Column(
          children: [
            // Top Section with Name and Arrow
            Container(
              color: Colors.black,
              // Change this to your desired background color
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                child: Row(
                  children: [
                    // User's Name
                    const Expanded(
                      child: Text(
                        'User Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                // Smooth transition
                child: showTickets ? _buildTicketsView() : _buildUserInfoView(),
              ),
            ),
          ],
        ));
  }

  // "My Tickets" View
  Widget _buildTicketsView() {
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
  }

  Widget _buildUserInfoView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildTextField(label: 'Name', value: 'First Name'),
          _buildTextField(label: 'Surname', value: 'Last Name'),
          _buildDateField(
              label: 'Date of Birth',
              value: DateFormat('dd.MM.yyyy').format(DateTime.now())),
          _buildTextField(label: 'Username', value: 'UserName'),
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
                      backgroundColor: const Color.fromARGB(255, 46, 46, 46),
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
          )
        ],
      ),
    );
  }

// Updated to handle the calendar icon and date picker
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
              if (pickedDate != null) {
                controller.text =
                    "${pickedDate.day.toString().padLeft(2, '0')}.${pickedDate.month.toString().padLeft(2, '0')}.${pickedDate.year}";
              }
            },
          ),
        ),
        style: const TextStyle(color: Colors.white),
        readOnly: true, // Make the field read-only to prevent manual input
      ),
    );
  }

// Helper for text fields
  Widget _buildTextField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Reduced height
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.black,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          // Reduced padding for lower height
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Semi-circle edges
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Semi-circle edges
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
        style: const TextStyle(color: Colors.white),
        controller: TextEditingController(text: value), // Pre-filled value
        readOnly: label ==
            'Date of Birth', // Make it read-only if it's the date field
      ),
    );
  }

// Helper for password fields
  Widget _buildPasswordField({required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Reduced height
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.black,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          // Reduced padding for lower height
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Semi-circle edges
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Semi-circle edges
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
