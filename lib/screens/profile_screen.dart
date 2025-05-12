import 'package:flutter/material.dart';
import 'package:theatre_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/play.dart';
import '../plays_data.dart';
import '../widgets/play_card.dart';
import 'details_screen.dart';
import 'login_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showTickets = true;
  bool _hasChanged = false;
  bool _isInitializing = true;
  bool _isLoggingOut = false;

  late final Future<Map<String, String>> _userDataFuture;

  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _dobController;
  late TextEditingController _usernameController;
  late TextEditingController _currentPwdController;
  late TextEditingController _newPwdController;

  String _origFullName = '';
  String _origDateOfBirth = '';
  String _origUsername = '';

  List<Play> boughtPlays = [];
  List<Play> plays = PlayRepository().plays;
  final User? user = FirebaseAuth.instance.currentUser;

  bool _isSaving = false;
  String? _saveError;

  @override
  void initState() {
    super.initState();
    fetchBoughtPlays();
    _userDataFuture = AuthService.getCurrentUser();

    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _dobController = TextEditingController();
    _usernameController = TextEditingController();
    _currentPwdController = TextEditingController();
    _newPwdController = TextEditingController();

    for (var c in [
      _nameController,
      _surnameController,
      _dobController,
      _usernameController,
      _currentPwdController,
      _newPwdController
    ]) {
      c.addListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() {
    if (_isInitializing) return;
    final fullName = '${_nameController.text} ${_surnameController.text}'.trim();
    final dob = _dobController.text;
    final username = _usernameController.text;
    final pwdChanged =
        _currentPwdController.text.isNotEmpty && _newPwdController.text.isNotEmpty;

    final changed = fullName != _origFullName ||
        dob != _origDateOfBirth ||
        username != _origUsername ||
        pwdChanged;

    if (changed != _hasChanged) {
      setState(() => _hasChanged = changed);
    }
  }

  Future<void> fetchBoughtPlays() async {
    if (user == null) return;
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userDoc.exists) {
        final titles = List<String>.from(userDoc['boughtPlays'] ?? []);
        setState(() {
          boughtPlays = plays.where((p) => titles.contains(p.title)).toList();
        });
      }
    } catch (e) {
      print('Error fetching plays: $e');
    }
  }

  Future<void> _saveProfile() async {
    final fullName = '${_nameController.text} ${_surnameController.text}'.trim();
    final dob = _dobController.text;
    final username = _usernameController.text;
    final currentPwd = _currentPwdController.text;
    final newPwd = _newPwdController.text;

    setState(() {
      _isSaving = true;
      _saveError = null;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'fullName': fullName,
        'dateOfBirth': dob,
        'username': username,
      });
      if (currentPwd.isNotEmpty && newPwd.isNotEmpty) {
        await AuthService.updatePassword(currentPwd, newPwd);
      }

      setState(() {
        _origFullName = fullName;
        _origDateOfBirth = dob;
        _origUsername = username;
        _currentPwdController.clear();
        _newPwdController.clear();
        _hasChanged = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile saved.')));
    } catch (e) {
      setState(() {
        _saveError = e.toString();
      });
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: Column(
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: FutureBuilder<Map<String, String>>(
                    future: _userDataFuture,
                    builder: (context, snap) {
                      if (snap.hasData && _isInitializing) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final data = snap.data!;
                          final parts = (data['fullName'] ?? '').split(' ');
                          _nameController.text = parts.first;
                          _surnameController.text = parts.length > 1
                              ? parts.sublist(1).join(' ')
                              : '';
                          _dobController.text = data['dateOfBirth']!;
                          _usernameController.text = data['username']!;

                          _origFullName = data['fullName']!;
                          _origDateOfBirth = data['dateOfBirth']!;
                          _origUsername = data['username']!;
                          _isInitializing = false;
                        });
                      }
                      return Text(
                        snap.data?['fullName'] ?? 'N/A',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                      showTickets
                          ? Icons.arrow_forward_ios
                          : Icons.arrow_back_ios,
                      color: Colors.white),
                  onPressed: () => setState(() => showTickets = !showTickets),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: showTickets ? _ticketsView() : _infoView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ticketsView() {
    if (boughtPlays.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.theaters, size: 70, color: Colors.white),
            SizedBox(height: 10),
            Text('My Tickets', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      );
    }
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'My Bought Tickets',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.7),
            itemCount: boughtPlays.length,
            itemBuilder: (ctx, i) {
              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailsScreen(play: boughtPlays[i]))),
                child: PlayCard(play: boughtPlays[i]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _infoView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _field('Name', _nameController),
          _field('Surname', _surnameController),
          _dateField('Date of Birth', _dobController),
          _field('Username', _usernameController),
          _pwField('Current Password', _currentPwdController),
          _pwField('New Password', _newPwdController),
          const SizedBox(height: 20),

          if (_hasChanged)
            Center(
              child: _isSaving
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E2E2E),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'SAVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          if (_saveError != null) ...[
            const SizedBox(height: 12),
            Text(
              _saveError!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],

          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: _isLoggingOut
                    ? null
                    : () async {
                  setState(() {
                    _isLoggingOut = true;
                  });

                  final success = await AuthService().logout(context);

                  if (success) {
                    await Future.delayed(const Duration(seconds: 2));
                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  } else {
                    setState(() {
                      _isLoggingOut = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E2E2E),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isLoggingOut
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2.5,
                  ),
                )
                    : const Text(
                  'LOG OUT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctr) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextField(
      controller: ctr,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.black,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white)),
      ),
    ),
  );

  Widget _dateField(String label, TextEditingController ctr) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextField(
      controller: ctr,
      readOnly: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.black,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.white),
          onPressed: () async {
            final dt = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100));
            if (dt != null) {
              ctr.text =
              "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}";
            }
          },
        ),
      ),
    ),
  );

  Widget _pwField(String label, TextEditingController ctr) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextField(
      controller: ctr,
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.black,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white)),
      ),
    ),
  );
}
