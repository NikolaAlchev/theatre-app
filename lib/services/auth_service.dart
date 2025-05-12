import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import '../screens/login_screen.dart';
import '../services/shared_pref.dart';

class AuthService {
  final SharedPref _sharedPref = SharedPref.instance;

  Future<String?> register(String email, String password, String fullName,
      String username, String dateOfBirth, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'username': username,
          'email': email,
          'boughtPlays': [],
          'favorites': [],
          'dateOfBirth': dateOfBirth,
          'createdAt': FieldValue.serverTimestamp()
        });

        _sharedPref.setEmail(email);

        await Future.delayed(const Duration(seconds: 1));

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));

        return 'Success';
      } else {
        return 'User registration failed. Please try again.';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _sharedPref.setEmail(email);
      await _sharedPref.getLogged() == false
          ? _sharedPref.setLogged(true)
          : null;
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(builder: (_) => const MainScreen()));
      });
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        return 'Invalid login credentials.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      _sharedPref.setLogged(false);
      _sharedPref.setEmail(null);
      return true;
    } catch (e) {
      print('Logout failed: $e');
      return false;
    }
  }

  Future<String?> getEmail() async {
    String? email;
    try {
      email = await _sharedPref.getEmail();
      return email;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      return e.message.toString();
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  static Future<Map<String, String>> getCurrentUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("No user is logged in.");
      }

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        var data = userData.data() as Map<String, dynamic>;
        return {
          'fullName': data['fullName'] ?? 'N/A',
          'username': data['username'] ?? 'N/A',
          'email': data['email'] ?? 'N/A',
          'dateOfBirth': data['dateOfBirth'] ?? 'N/A',
        };
      } else {
        throw Exception("User data not found.");
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getFavoritePlays() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  static Future<void> updatePassword(
      String currentPassword, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(
        code: 'no-current-user', message: 'No user is currently signed in.');

    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);
    await user.reauthenticateWithCredential(cred);

    await user.updatePassword(newPassword);
  }
}
