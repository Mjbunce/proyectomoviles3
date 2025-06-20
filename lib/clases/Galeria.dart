import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Galeria {
  // Instancia de ImagePicker para manejar la cámara o la galería
  final ImagePicker _picker = ImagePicker();

  // Método para seleccionar una imagen desde la galería
  Future<File?> subirFoto() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Método para tomar una foto con la cámara
  Future<File?> tomarFoto() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
