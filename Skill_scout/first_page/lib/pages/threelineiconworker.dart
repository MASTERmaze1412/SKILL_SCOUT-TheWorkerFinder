import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ThreeLineIcons(),
    );
  }
}

class ThreeLineIcons extends StatelessWidget {
  const ThreeLineIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hirer & Worker Notification System'),
      ),
      // Drawer with centered buttons
      drawer: Drawer(
        child: Container(
          height: MediaQuery.of(context).size.height / 2,  // Half of the screen height
          color: Colors.blue[50],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Placeholder for "Join as Worker"
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Join as Worker'),
                ),
                const SizedBox(height: 20), // Add space between buttons
                ElevatedButton(
                  onPressed: () {
                    // Placeholder for "Go to Hirer Page"
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Go to Hirer Page'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Main Content Here',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
