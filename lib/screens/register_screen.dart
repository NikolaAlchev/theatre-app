import 'package:flutter/material.dart';
import 'package:theatre_app/screens/login_screen.dart';
import 'package:theatre_app/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  bool _isPasswordObscure = true; // Local state to manage password visibility
  bool _isRepeatPasswordObscure = true; // Local state to manage repeat password visibility

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    nameController.dispose();
    surnameController.dispose();
    usernameController.dispose();
    dobController.dispose();
  }

  bool isValidEmail(String email) {
    RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(email);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != initialDate) {
      dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 100, bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "REGISTER",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      focusColor: Colors.green,
                      labelText: "Name",
                      hintText: "Enter Name",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Focused border color
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    cursorColor: Colors.white,
                  ),
                ),
                // Surname
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextFormField(
                    controller: surnameController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      focusColor: Colors.green,
                      labelText: "Surname",
                      hintText: "Enter Surname",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Focused border color
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    cursorColor: Colors.white,
                  ),
                ),
                // Date of Birth
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextFormField(
                    controller: dobController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      focusColor: Colors.green,
                      labelText: "Date of Birth",
                      hintText: "Select Date of Birth",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Focused border color
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    cursorColor: Colors.white,// Text color white
                  ),
                ),
                // Username
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusColor: Colors.green,
                      labelText: "Username",
                      hintText: "Enter Username",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Focused border color
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    cursorColor: Colors.white,
                  ),
                ),
                // EMAIL
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusColor: Colors.green,
                      labelText: "Email",
                      hintText: "Enter Email",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Focused border color
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!isValidEmail(value)) {
                        return 'Email not valid!';
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    cursorColor: Colors.white,
                  ),
                ),
                // PASSWORD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: _isPasswordObscure,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white), // Label text color
                      focusColor: Colors.green,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelText: "Password",
                      hintText: "Enter password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordObscure = !_isPasswordObscure;
                          });
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Focused border color
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password should not have less than 6 characters.';
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    cursorColor: Colors.white,
                  ),
                ),
                // Repeat Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextFormField(
                    controller: repeatPasswordController,
                    obscureText: _isRepeatPasswordObscure,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white), // Label text color
                      focusColor: Colors.green,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelText: "Repeat Password",
                      hintText: "Re-enter password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isRepeatPasswordObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isRepeatPasswordObscure = !_isRepeatPasswordObscure;
                          });
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Focused border color
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please repeat your password';
                      } else if (value != passwordController.text) {
                        return 'Passwords do not match!';
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    cursorColor: Colors.white,
                  ),
                ),
                // Register button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String? result = await AuthService().register(
                            emailController.text,
                            passwordController.text,
                            "${nameController.text} ${surnameController.text}",
                            usernameController.text,
                            dobController.text,
                            context,
                          );
                          if (result == 'Success') {
                            print("User registered successfully!");
                          } else {
                            print("Error: $result");
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill input'),
                            ),
                          );
                        }
                      },
                      label: const Text('REGISTER', style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 46, 46, 46),
                      ),
                    ),
                  ),
                ),

                // Link to Login screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text("Already have an account? Sign In!", style: TextStyle(color: Color.fromARGB(255,122, 122, 122)),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
