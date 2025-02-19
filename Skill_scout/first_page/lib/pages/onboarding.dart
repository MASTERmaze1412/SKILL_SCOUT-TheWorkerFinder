import 'package:first_page/pages/login.dart';
import 'package:first_page/pages/signup.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 140),
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
          children: [
            const Text(
              "Skill Scout",
              style: TextStyle(
                color: Colors.black,
                fontSize: 50.0,
              ),
            ),
            const SizedBox(height: 60.0),
            const Text(
              " Welcome ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
              width: MediaQuery.of(context).size.width,
              // const EdgeInsets.only(: 15.0, horizontal: 30.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0), width: 3.0),
                borderRadius: BorderRadius.circular(20.0),
              ),

              child: Center(
                child: GestureDetector(
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
                      color: Colors.black,
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
              width: MediaQuery.of(context).size.width,
              // const EdgeInsets.only(: 15.0, horizontal: 30.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0), width: 3.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                    ),
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
