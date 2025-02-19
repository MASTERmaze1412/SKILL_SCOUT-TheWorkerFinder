import 'package:image_picker/image_picker.dart';

Future<String?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  try {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile.path; // Return the file path as a String
    } else {
      return null;
    }
  } catch (e) {
    print('Error picking image: $e');
    return null;
  }
}
