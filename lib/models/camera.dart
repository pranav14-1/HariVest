import 'package:image_picker/image_picker.dart';
Future<void> openCamera() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.camera);

  if (image != null) {
    print('Image captured: ${image.path}');
  }
}
