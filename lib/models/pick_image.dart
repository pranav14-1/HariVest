import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> pickImage(BuildContext context) async {
  final ImagePicker picker = ImagePicker();

  showModalBottomSheet(
    context: context,
    builder: (BuildContext ctx) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.of(ctx).pop();
                final XFile? image = await picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  // Handle the captured image (e.g., upload)
                  print('Image captured: ${image.path}');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.of(ctx).pop();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  // Handle the selected image (e.g., upload)
                  print('Image selected: ${image.path}');
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
