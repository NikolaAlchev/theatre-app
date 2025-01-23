import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String eMail = 'username';
  static const isLogged = 'isLogged';

  SharedPref._instantiate();
  static final SharedPref instance = SharedPref._instantiate();

  // Set email to local storage
  Future<bool> setEmail(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      if (value != null) {
        await prefs.setString(eMail, value);
        print("Email is set to local storage $value");
        return true;
      } else {
        print("Email value is null");
        return false;
      }
    } catch (e) {
      print("Error $e");
      return false;
    }
  }

  // Get email from local storage
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString(eMail);
    print("Email in shared prefs $email");
    return email; // Can be null if no email is saved
  }

  // Set logged status to local storage
  Future<bool> setLogged(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setBool(isLogged, value);
      print("Logged status is set to local storage $value");
      return true;
    } catch (e) {
      print("Error $e");
      return false;
    }
  }

  // Get logged status from local storage
  Future<bool> getLogged() async {
    final prefs = await SharedPreferences.getInstance();
    bool? logged = prefs.getBool(isLogged);
    if (logged == null) {
      // Return false if the value is not set
      print("Logged status not found, returning false");
      return false;
    }
    print("Logged in shared prefs $logged");
    return logged;
  }
}
