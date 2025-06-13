import 'package:flutter/material.dart';
import 'package:proyecto/screens/Inicio.dart';

import '../styles/styles.dart';

// AUTENTICACIÓN
import 'package:firebase_auth/firebase_auth.dart';

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
                mainAxisSize: MainAxisSize.min, // MainAxisSize: Ajusta al contenido
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
                    // llamo a la función 
                    onPressed: () => continuar(_correo.text, _contrasenia.text, context),
                    child: Text("Continuar")
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

// creo una funcion continuar

Future<void> continuar(String correo, String contrasenia, context )async {
  try {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: correo,
          password: contrasenia,
        );
//si el codigo es correcto ingresa aqui 

Navigator.push(context, MaterialPageRoute(builder: (context) => Inicio(),));

// mensajes de alerta PENDIENTE por configurar 
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}
