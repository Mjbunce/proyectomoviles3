import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';  // Firebase Realtime Database
import 'package:proyecto/clases/Galeria.dart';
import 'package:proyecto/screens/Inicio.dart';
import 'package:proyecto/screens/MenorEdad.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../styles/styles.dart';

class Registro extends StatefulWidget {
  final VoidCallback onBack;

  const Registro({super.key, required this.onBack});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final TextEditingController _nombres = TextEditingController();
  final TextEditingController _apellidos = TextEditingController();
  final TextEditingController _edad = TextEditingController();
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _contrasenia = TextEditingController();

  File? _selectedImage;
  String? _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: TextButton(
              onPressed: widget.onBack,
              child: const Text("Regresar", style: AppTextStyles.link),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Crea una cuenta", style: AppTextStyles.formTitle),
                  const SizedBox(height: 20),
                  _buildTextField(_nombres, "Nombres"),
                  const SizedBox(height: 10),
                  _buildTextField(_apellidos, "Apellidos"),
                  const SizedBox(height: 10),
                  _buildTextField(_edad, "Edad", keyboardType: TextInputType.number),
                  const SizedBox(height: 10),
                  _buildTextField(_correo, "Correo Electrónico"),
                  const SizedBox(height: 10),
                  _buildTextField(_contrasenia, "Contraseña", obscureText: true),
                  const SizedBox(height: 30),
                  const Text("Selecciona una imagen para tu perfil", style: AppTextStyles.formTitle),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: AppButtonStyle.yellowButton.copyWith(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(const Size(120, 40)),
                        ),
                        onPressed: () async {
                          File? image = await Galeria().subirFoto();
                          if (image != null) {
                            setState(() => _selectedImage = image);
                            String? imageUrl = await uploadImageToSupabase(image);
                            if (imageUrl != null) {
                              setState(() => _imageUrl = imageUrl);
                              print("Imagen subida con éxito: $imageUrl");
                            } else {
                              print("Error al subir la imagen.");
                            }
                          }
                        },
                        child: const Text("Abrir Galería", style: TextStyle(fontSize: 14)),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        style: AppButtonStyle.yellowButton.copyWith(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(const Size(120, 40)),
                        ),
                        onPressed: () async {
                          File? image = await Galeria().tomarFoto();
                          if (image != null) {
                            setState(() => _selectedImage = image);
                            String? imageUrl = await uploadImageToSupabase(image);
                            if (imageUrl != null) {
                              setState(() => _imageUrl = imageUrl);
                              print("Imagen subida con éxito: $imageUrl");
                            } else {
                              print("Error al subir la imagen.");
                            }
                          }
                        },
                        child: const Text("Abrir Cámara", style: TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_selectedImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _selectedImage!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: AppButtonStyle.yellowButton.copyWith(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(const Size(120, 40)),
                    ),
                    onPressed: () {
                      if (_imageUrl == null) {
                        _showAlert(context, "Selecciona y sube una imagen antes de continuar");
                        return;
                      }

                      final edad = int.tryParse(_edad.text);
                      if (edad == null) {
                        _showAlert(context, "Por favor, introduce una edad válida.");
                        return;
                      }

                      // Si la edad es menor a 18, redirigimos a la pantalla de MenorEdad
                      if (edad < 18) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MenorEdad()), // Redirige si es menor de 18
                        );
                        return;
                      }

                      // Si la edad es válida y mayor o igual a 18, registramos al usuario
                      _registrarUsuario(
                        context,
                        correo: _correo.text,
                        contrasenia: _contrasenia.text,
                        imagenUrl: _imageUrl!,
                      );
                    },
                    child: const Text("Continuar", style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      decoration: AppDecorations.input(label),
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
    );
  }

  // Subir imagen a Supabase y obtener URL pública
  Future<String?> uploadImageToSupabase(File imageFile) async {
    try {
      final supabaseClient = Supabase.instance.client;
      final String fileName = 'avatar/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabaseClient.storage.from('perfiles').upload(
        fileName,
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600'),
      );

      final String publicUrl = supabaseClient.storage.from('perfiles').getPublicUrl(fileName);
      return publicUrl;
    } on StorageException catch (e) {
      print("Error de Supabase Storage al subir la imagen: ${e.message}");
      return null;
    } catch (e) {
      print("Error inesperado al subir la imagen: $e");
      return null;
    }
  }

  // Registrar usuario en Firebase Authentication y almacenar en Firebase Realtime Database
  Future<void> _registrarUsuario(
    BuildContext context, {
    required String correo,
    required String contrasenia,
    required String imagenUrl,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correo,
        password: contrasenia,
      );

      String uid = userCredential.user!.uid;
      DatabaseReference ref = FirebaseDatabase.instance.ref("usuarios/$uid");

      await ref.set({
        "nombres": _nombres.text,
        "apellidos": _apellidos.text,
        "edad": int.parse(_edad.text),
        "correo": correo,
        "imagenUrl": imagenUrl, // Guardamos la URL de la imagen en Realtime Database
      });

      Navigator.push(context, MaterialPageRoute(builder: (_) => Inicio()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showAlert(context, 'La contraseña proporcionada es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        _showAlert(context, 'La cuenta ya existe para ese correo electrónico.');
      } else {
        _showAlert(context, 'Error: ${e.message}');
      }
    } catch (e) {
      _showAlert(context, 'Se produjo un error inesperado: $e');
    }
  }

  // Mostrar mensaje de alerta
  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alerta'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
