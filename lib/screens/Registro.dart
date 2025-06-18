import 'package:flutter/material.dart';
import 'package:proyecto/screens/Inicio.dart';

import '../styles/styles.dart';

// AUTENTICACIÓN
import 'package:firebase_auth/firebase_auth.dart';
// BASE DE DATOS EN TIEMPO REAL
import 'package:firebase_database/firebase_database.dart';

class Registro extends StatelessWidget {
  final VoidCallback onBack;

  const Registro({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    // Controladores para los campos
    final TextEditingController _nombres = TextEditingController();
    final TextEditingController _apellidos = TextEditingController();
    final TextEditingController _edad = TextEditingController();
    final TextEditingController _correo = TextEditingController();
    final TextEditingController _contrasenia = TextEditingController();

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: TextButton(
              onPressed: onBack,
              child: const Text("Regresar", style: AppTextStyles.link),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ajusta al contenido
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Crea una cuenta ", style: AppTextStyles.formTitle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nombres,
                    decoration: AppDecorations.input("Nombres"),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _apellidos,
                    decoration: AppDecorations.input("Apellidos"),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _edad,
                    decoration: AppDecorations.input("Edad"),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _correo,
                    decoration: AppDecorations.input("Correo Electrónico"),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _contrasenia,
                    decoration: AppDecorations.input("Contraseña"),
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: AppButtonStyle.yellowButton,
                    onPressed: () => continuar(
                      _correo.text,
                      _contrasenia.text,
                      context,
                      _nombres.text,
                      _apellidos.text,
                      _edad.text,
                    ),
                    child: const Text("Continuar"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> continuar(
  String correo,
  String contrasenia,
  BuildContext context,
  String nombres,
  String apellidos,
  String edad,
) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: correo,
      password: contrasenia,
    );

    final uid = credential.user?.uid;
    if (uid != null) {
      final ref = FirebaseDatabase.instance.ref("usuarios/$uid");

      await ref.set({
        "nombres": nombres,
        "apellidos": apellidos,
        "edad": edad,
        "correo": correo,
      });
    }

    // Navegar a pantalla de Inicio
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Inicio()),
    );

  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('La contraseña es demasiado débil.');
    } else if (e.code == 'email-already-in-use') {
      print('Ya existe una cuenta con ese correo.');
    } else {
      print('Error de autenticación: ${e.message}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
