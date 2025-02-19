import 'package:first_page/pages/mappage.dart';
import 'package:first_page/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart';
// Import the HomePage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Scout',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Onboarding(), // Use HomePage
    );
  }
}