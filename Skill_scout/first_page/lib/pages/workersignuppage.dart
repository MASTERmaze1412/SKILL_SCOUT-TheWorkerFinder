
import 'package:first_page/pages/workerpage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Ensure image_picker is imported
// Ensure this is correctly imported

class WorkerSignupPage extends StatefulWidget {
  const WorkerSignupPage({super.key});

  @override
  State<WorkerSignupPage> createState() => _WorkerSignupPageState();
}

class _WorkerSignupPageState extends State<WorkerSignupPage> {
  File? _frontCitizenshipImage;
  File? _backCitizenshipImage;
  File? _documentImage;

  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _professionController = TextEditingController();

  // Pick Image Function
  Future<String?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile?.path;
  }

  // Select image function for different fields
  Future<void> _selectImage(String type) async {
    String? imagePath = await pickImage();
    if (imagePath != null) {
      setState(() {
        if (type == 'frontCitizenship') {
          _frontCitizenshipImage = File(imagePath);
        } else if (type == 'backCitizenship') {
          _backCitizenshipImage = File(imagePath);
        } else if (type == 'document') {
          _documentImage = File(imagePath);
        }
      });
    }
  }

  // Use the corrected frontend code provided earlier with proper error handling.
// Ensure the `_submitForm` function is updated as shown below:
Future<void> _submitForm() async {
    try {
        // Form validation
        if (_firstnameController.text.isEmpty ||
            _lastnameController.text.isEmpty ||
            _emailController.text.isEmpty ||
            _addressController.text.isEmpty ||
            _phoneController.text.isEmpty ||
            _professionController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill out all fields')),
            );
            return;
        }

        // Prepare form data
        final formData = {
            'firstname': _firstnameController.text,
            'lastname': _lastnameController.text,
            'email': _emailController.text,
            'address': _addressController.text,
            'phone': _phoneController.text,
            'profession': _professionController.text,
        };

        // Prepare multipart request
        final uri = Uri.parse('http://192.168.1.66:8000/workerSignUp');
        final request = http.MultipartRequest('POST', uri);

        // Add form fields
        request.fields.addAll(formData);

        // Add image files
        if (_frontCitizenshipImage != null) {
            request.files.add(await http.MultipartFile.fromPath(
                'frontCitizenship',
                _frontCitizenshipImage!.path,
            ));
        }
        if (_backCitizenshipImage != null) {
            request.files.add(await http.MultipartFile.fromPath(
                'backCitizenship',
                _backCitizenshipImage!.path,
            ));
        }
        if (_documentImage != null) {
            request.files.add(await http.MultipartFile.fromPath(
                'document',
                _documentImage!.path,
            ));
        }

        // Send request
        final response = await request.send();
        if (response.statusCode == 200) {
            print('Worker registered successfully!');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Workerpage()),
            );
        } else {
            final responseBody = await response.stream.bytesToString();
            print('Error registering worker: ${response.reasonPhrase}');
            print('Response body: $responseBody');
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registration failed: ${response.reasonPhrase}')),
            );
        }
    } catch (e) {
        print('Error during form submission: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
        );
    }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: const EdgeInsets.only(top: 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6C9EFF),
              Color(0xFFA6E4D0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'SIGN UP\nAs A WORKER',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20.0),
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
                      _buildTextField(
                        label: 'First Name',
                        hint: 'Enter Your First Name',
                        icon: Icons.person_outline,
                        controller: _firstnameController,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        label: 'Last Name',
                        hint: 'Enter Your Last Name',
                        icon: Icons.person_outline,
                        controller: _lastnameController,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        label: 'Email',
                        hint: 'Enter Your Email',
                        icon: Icons.email_outlined,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        label: 'Current Address',
                        hint: 'Enter Your Address',
                        icon: Icons.location_on,
                        controller: _addressController,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        label: 'Phone Number',
                        hint: 'Enter Your Phone Number',
                        icon: Icons.phone,
                        controller: _phoneController,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Choose Your Profession',
                        style: TextStyle(
                          color: Color.fromARGB(255, 76, 131, 239),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          hintText: 'Select Your Profession',
                          prefixIcon: Icon(Icons.work),
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'Plumber', child: Text('Plumber')),
                          DropdownMenuItem(
                              value: 'Electrician', child: Text('Electrician')),
                          DropdownMenuItem(
                              value: 'Home Cleaner', child: Text('Home Cleaner')),
                        ],
                        onChanged: (value) {
                          _professionController.text = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildUploadSection(
                        label: 'Front Side of Citizenship',
                        onTap: () => _selectImage('frontCitizenship'),
                        image: _frontCitizenshipImage,
                      ),
                      const SizedBox(height: 20),
                      _buildUploadSection(
                        label: 'Back Side of Citizenship',
                        onTap: () => _selectImage('backCitizenship'),
                        image: _backCitizenshipImage,
                      ),
                      const SizedBox(height: 20),
                      _buildUploadSection(
                        label: 'Document (optional)',
                        onTap: () => _selectImage('document'),
                        image: _documentImage,
                        isOptional: true,
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: GestureDetector(
                          onTap: _submitForm,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF6C9EFF),
                                  Color(0xFFA6E4D0),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'SIGN UP',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 76, 131, 239),
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadSection({
    required String label,
    required Function onTap,
    bool isOptional = false,
    File? image,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 76, 131, 239),
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => onTap(),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: image == null
                ? const Center(child: Text('Tap to upload'))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      image,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        if (isOptional)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Optional',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ),
      ],
    );
  }
}
