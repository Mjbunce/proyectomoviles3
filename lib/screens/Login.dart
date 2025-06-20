import 'package:flutter/material.dart';
import 'package:proyecto/screens/Inicio.dart';
import 'package:proyecto/screens/MenorEdad.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../styles/styles.dart';

class Login extends StatelessWidget {
  final VoidCallback onBack;

  const Login({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    TextEditingController _correo = TextEditingController();
    TextEditingController _contrasenia = TextEditingController();

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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Iniciar Sesión', style: AppTextStyles.formTitle),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _correo,
                    decoration: AppDecorations.input("Correo Electrónico"),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _contrasenia,
                    obscureText: true,
                    decoration: AppDecorations.input("Contraseña"),
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: AppTextStyles.link,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: AppButtonStyle.yellowButton,
                    onPressed: () => ingresar(_correo.text, _contrasenia.text, context),
                    child: const Text("Ingresar"),
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

Future<void> ingresar(String correo, String contrasenia, BuildContext context) async {
  try {
    // 1. Iniciar sesión con Firebase Auth
    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: correo,
      password: contrasenia,
    );

    final user = cred.user;
    if (user == null) throw Exception('Usuario no válido');

    final uid = user.uid;

    // 2. Leer edad desde Realtime Database
    final ref = FirebaseDatabase.instance.ref("usuarios/$uid/edad");
    final snapshot = await ref.get();

    if (!snapshot.exists) {
      throw Exception("Edad no encontrada en el perfil.");
    }

    final edadStr = snapshot.value.toString();
    final edad = int.tryParse(edadStr);

    if (edad == null) {
      throw Exception("Edad inválida en el perfil.");
    }

    // 3. Redireccionar según la edad
    if (edad < 18) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MenorEdad()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Inicio()),
      );
    }
  } on FirebaseAuthException catch (e) {
    String mensaje = 'Error de autenticación.';
    if (e.code == 'user-not-found') {
      mensaje = 'No existe un usuario con ese correo.';
    } else if (e.code == 'wrong-password') {
      mensaje = 'La contraseña es incorrecta.';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
  }
}
