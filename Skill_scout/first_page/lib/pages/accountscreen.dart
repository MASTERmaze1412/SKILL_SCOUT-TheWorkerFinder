import 'package:flutter/material.dart';
import 'imagepicker.dart'; // Import your updated Image Picker method
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _isEditing = false; // Track edit mode
  late String fullName;
  late String email;
  late String phone;
  String profileImage = "https://via.placeholder.com/150"; // Default profile picture

  // Controllers for editing mode
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      phone = prefs.getString('phone') ?? '';
    });
  }

  // Switch to edit mode
  void _startEditing() {
    setState(() {
      _isEditing = true;
      _nameController.text = fullName;
      _emailController.text = email;
      _phoneController.text = phone;
    });
  }

  // Save updated values
  Future<void> _saveChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');

    var updateBody = {
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
    };

    try {
      var response = await http.put(
        Uri.parse('http://192.168.1.73:8000/updateUser/$userId'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updateBody),
      );

      if (response.statusCode == 200) {
        setState(() {
          fullName = _nameController.text;
          email = _emailController.text;
          phone = _phoneController.text;
          _isEditing = false;
        });

        await prefs.setString('name', fullName);
        await prefs.setString('email', email);
        await prefs.setString('phone', phone);
      }
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  // Function to update profile picture
  Future<void> _changeProfilePicture() async {
    String? newImage = await pickImage(); // Use the global pickImage() method
    if (newImage != null) {
      setState(() {
        profileImage = newImage; // Set the new profile image
      });

      // Upload image to Google Drive and update user profile
      var request = http.MultipartRequest('POST', Uri.parse('http://192.168.1.73:8000/uploadImage'));
      request.files.add(await http.MultipartFile.fromPath('file', newImage));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        setState(() {
          profileImage = jsonResponse['fileUrl'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Account",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profile",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Profile Section (View Mode)
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(profileImage),
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _changeProfilePicture,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueAccent,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: InkWell(
                    onTap: _startEditing,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Edit Profile",
                          style: TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.edit, color: Colors.blueAccent),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Show Profile Details in View Mode
            if (!_isEditing) ...[
              _buildProfileInfo(Icons.person, "Full Name", fullName),
              _buildProfileInfo(Icons.email, "Email Address", email),
              _buildProfileInfo(Icons.phone, "Phone Number", phone),
            ],

            // Edit Profile Fields
            if (_isEditing) ...[
              _buildTextField("Full Name", _nameController, Icons.person),
              _buildTextField("Email Address", _emailController, Icons.email),
              _buildTextField("Phone Number", _phoneController, Icons.phone),
              const SizedBox(height: 20),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Profile Info (View Mode)
  Widget _buildProfileInfo(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blueAccent),
          const SizedBox(width: 15),
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  // Editable TextField (Edit Mode)
  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
