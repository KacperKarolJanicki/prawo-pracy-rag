import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Attachments {

  final picker = ImagePicker();

  Future<File> fromCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if(image == null){
      return File('');
    } else {
      return File(image.path);
    }
  }

  Future<File> fromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image == null){
      return File('');
    } else {
      return File(image.path);
    }
  }
}