import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  // Initial camera position (example: Kathmandu)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(27.7172, 85.3240),
    zoom: 14,
  );

  // List of markers on the map
  final Set<Marker> _markers = {};

  // Function to get the user's current location + location permission
  Future<Position> getUserCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled, prompt the user to enable them
      print('Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle accordingly
        print('Location permissions are denied.');
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle accordingly
      print('Location permissions are permanently denied.');
      return Future.error('Location permissions are permanently denied.');
    }

    // If permissions are granted, get the current location
    Position position = await Geolocator.getCurrentPosition();
    print('Current Location: ${position.latitude}, ${position.longitude}');
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Map with Current Location'),
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Get the user's current location
            Position value = await getUserCurrentLocation();
            print('My current location: ${value.latitude}, ${value.longitude}');

            // Add a marker for the current location
            setState(() {
              _markers.add(
                Marker(
                  markerId: const MarkerId('current_location'),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: const InfoWindow(
                    title: 'My Current Location',
                  ),
                ),
              );
            });

            // Move the camera to the current location
            CameraPosition cameraPosition = CameraPosition(
              zoom: 14,
              target: LatLng(value.latitude, value.longitude),
            );

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
          } catch (e) {
            // Handle errors (e.g., permissions denied, location services disabled)
            print('Error: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}