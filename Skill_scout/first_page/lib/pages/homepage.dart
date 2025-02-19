import 'package:first_page/pages/mappage.dart';
import 'package:first_page/pages/workerpage.dart';
import 'package:first_page/pages/workersignuppage.dart';
import 'package:first_page/pages/profilescreen.dart'; // Import ProfileScreen
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0; // Tracks selected tab
  String? _selectedProfession; // Tracks selected profession
  GoogleMapController? _controller; // GoogleMap controller

  // List of professions for the dropdown
  final List<String> _professions = [
    'Plumber',
    'Electrician',
    'Cleaner',
    'Carpenter',
  ];

  // Initial position for the Google Map
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(27.7172, 85.3240), // Example coordinates (Kathmandu)
    zoom: 14,
  );

  // Handles bottom navigation tab switch
  void _onItemTapped(int index) {
    if (index == 2) {
      // Navigate to ProfileScreen when Profile tab is clicked
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Handles the menu button click
  void _onMenuTapped() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5, // Half screen height
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkerSignupPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Join as a Worker"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Workerpage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Go to the Worker Page"),
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
        title: const Text(
          'Skill Scout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 30.0),
            icon: const Icon(Icons.menu),
            onPressed: _onMenuTapped,
            color: Colors.black,
          ),
        ],
      ),

      // Body changes based on selected tab
      body: _selectedIndex == 0
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedProfession,
                          decoration: InputDecoration(
                            labelText: 'Select a Profession',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: _professions.map((String profession) {
                            return DropdownMenuItem<String>(
                              value: profession,
                              child: Text(profession),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedProfession = value;
                            });
                            debugPrint('Selected profession: $value');
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedProfession != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapPage(),
                              ),
                            );
                          } else {
                            debugPrint('Please select a profession to search.');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Search'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GoogleMap(
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
                  ),
                ),
              ],
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
            icon: Icon(Icons.home),
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