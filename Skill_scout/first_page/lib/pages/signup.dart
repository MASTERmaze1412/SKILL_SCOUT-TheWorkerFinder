import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart'; // Ensure this import points to your login page
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isNotValidate = false;
  String? _errorMessage;

  Future<void> _signUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty || _phoneController.text.isEmpty) {
      setState(() {
        _isNotValidate = true;
        _errorMessage = "Please fill in all required fields";
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match!";
      });
      return;
    }

    var regBody = {
      "name": _nameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "phone": _phoneController.text,
    };

    try {
      var response = await http.post(
        Uri.parse('http://192.168.1.66:8000/SignUp'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          // Save user data to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', jsonResponse['userId']);
          await prefs.setString('name', _nameController.text);
          await prefs.setString('email', _emailController.text);
          await prefs.setString('phone', _phoneController.text);

          // Navigate to Login Screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LogIn(),
            ),
          );
        } else {
          setState(() {
            _errorMessage = jsonResponse['message'] ?? "Something went wrong!";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Server returned an error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to connect to the server: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 30),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6C9EFF),
              Color(0xFFA6E4D0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Text(
                'Create Your\nAccount',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Field
                      const Text(
                        'Name',
                        style: TextStyle(
                          color: Color.fromARGB(255, 76, 131, 239),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: "Enter Your Name",
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Email Field
                      const Text(
                        'Email',
                        style: TextStyle(
                          color: Color.fromARGB(255, 76, 131, 239),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Enter Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: const OutlineInputBorder(),
                          errorText: _isNotValidate && _emailController.text.isEmpty ? "Please enter your email" : null,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Password Field
                      const Text(
                        'Password',
                        style: TextStyle(
                          color: Color.fromARGB(255, 76, 131, 239),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          prefixIcon: const Icon(Icons.password_outlined),
                          border: const OutlineInputBorder(),
                          errorText: _isNotValidate && _passwordController.text.isEmpty ? "Please enter your password" : null,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Confirm Password Field
                      const Text(
                        'Confirm Password',
                        style: TextStyle(
                          color: Color.fromARGB(255, 76, 131, 239),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          prefixIcon: const Icon(Icons.password_outlined),
                          border: const OutlineInputBorder(),
                          errorText: _isNotValidate && _confirmPasswordController.text.isEmpty ? "Please confirm your password" : null,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Phone Number Field
                      const Text(
                        'Phone Number',
                        style: TextStyle(
                          color: Color.fromARGB(255, 76, 131, 239),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          hintText: "Enter Your Phone Number",
                          prefixIcon: Icon(Icons.phone_enabled),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Error Message
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 10),

                      // Sign Up Button
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF6C9EFF),
                              Color(0xFFA6E4D0),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: _signUp,
                            child: const Text(
                              'SIGN UP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),

                      // Log In Redirect
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: Color.fromARGB(115, 0, 0, 0),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LogIn(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "LOG IN",
                                  style: TextStyle(
                                    color: Color.fromARGB(115, 36, 10, 230),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}