import 'package:first_page/pages/joinasaworker.dart';
import 'package:first_page/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// Import the AccountScreen

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
Future<void> _login() async {
  if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
    setState(() {
      _errorMessage = "Please enter both email and password";
    });
    return;
  }

  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  var loginBody = {
    "email": _emailController.text,
    "password": _passwordController.text,
  };

  try {
    var response = await http.post(
      Uri.parse('http://192.168.1.66:8000/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(loginBody),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); // Debug the response body

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('Parsed JSON: $jsonResponse'); // Debug the parsed JSON

      if (jsonResponse['status'] == true) {
        // Validate that all required fields are present
        if (jsonResponse['userId'] == null ||
            jsonResponse['name'] == null ||
            jsonResponse['email'] == null ||
            jsonResponse['phone'] == null) {
          setState(() {
            _errorMessage = "Server response is missing required fields!";
          });
          return;
        }

        // Save user data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', jsonResponse['userId'] ?? '');
        await prefs.setString('name', jsonResponse['name'] ?? '');
        await prefs.setString('email', jsonResponse['email'] ?? '');
        await prefs.setString('phone', jsonResponse['phone'] ?? '');

        // Navigate to AccountScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Joinasaworker()),
        );
      } else {
        setState(() {
          _errorMessage = jsonResponse['message'] ?? "Invalid credentials!";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Server error: ${response.statusCode}";
      });
    }
  } catch (e) {
    setState(() {
      _errorMessage = "Failed to connect to server: $e";
    });
  } finally {
    setState(() {
      _isLoading = false;
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
                'Hello\nLog In!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        decoration: const InputDecoration(
                          hintText: "Enter Email",
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 30),
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
                        decoration: const InputDecoration(
                          hintText: "Enter Password",
                          prefixIcon: Icon(Icons.password_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 40),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C9EFF), Color(0xFFA6E4D0)],
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : GestureDetector(
                                  onTap: _login,
                                  child: const Text(
                                    'LOG IN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "Don't have an account?",
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
                                      builder: (context) => const SignUp(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "SIGN UP",
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