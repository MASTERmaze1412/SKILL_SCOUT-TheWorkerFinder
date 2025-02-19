import 'package:first_page/pages/homepage.dart';
import 'package:first_page/pages/profilescreen.dart'; // Import ProfileScreen
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Workerpage extends StatefulWidget {
  const Workerpage({super.key});

  @override
  State<Workerpage> createState() => _WorkerpageState();
}

class _WorkerpageState extends State<Workerpage> {
  int _selectedIndex = 0; // Tracks the selected tab (default is Home)
  bool _isOn = false; // Tracks the ON/OFF button state
  GoogleMapController? _controller; // GoogleMap controller

  // Placeholder data for fullname and email
  final String fullname = 'Bibek Poudel';  // Replace with actual fullname
  final String email = 'bibek@example.com';  // Replace with actual email

  // Initial camera position for the map
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(27.7172, 85.3240), // Example coordinates (Kathmandu)
    zoom: 14,
  );

  // Handles navigation between bottom navigation items
  void _onItemTapped(int index) {
    if (index == 2) {
      // Navigate to ProfileScreen when Profile button is tapped
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Displays a modal bottom sheet with "Go to the Hirer Page" button
  void _onMenuTapped() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5, // Half-screen height
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  debugPrint("Go to the Hirer page button pressed");
                  // Add navigation logic here
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Homepage(),
                      ),
                    );
                  },
                  child: const Text("Go to the Hirer Page"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        title: Row(
          children: [
            const Spacer(),
            Transform.scale(
              scale: 1.2,
              child: SizedBox(
                width: 150,
                child: Switch(
                  value: _isOn,
                  onChanged: (value) {
                    setState(() {
                      _isOn = value;
                    });
                  },
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              padding: const EdgeInsets.only(right: 30.0),
              icon: const Icon(Icons.menu),
              onPressed: _onMenuTapped,
              color: Colors.black,
            ),
          ],
        ),
      ),

      // Body changes based on selected tab
      body: _selectedIndex == 0
          ? GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              markers: {
                const Marker(
                  markerId: MarkerId('1'),
                  position: LatLng(27.7172, 85.3240),
                  infoWindow: InfoWindow(title: 'Kathmandu'),
                ),
              },
            )
          : _selectedIndex == 1
              ? const Center(child: Text('Notifications Page'))
              : const Center(child: Text('Profile Page')),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
