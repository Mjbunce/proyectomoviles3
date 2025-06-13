import 'package:flutter/material.dart';
import 'package:proyecto/screens/Inicio.dart';
import '../styles/styles.dart';

// AUTENTICACIÓN
import 'package:firebase_auth/firebase_auth.dart';

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
                mainAxisSize:
                    MainAxisSize.min, 
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


Future<void> ingresar(correo, contrasenia,context) async {
  try {
  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: correo,
    password: contrasenia
  );

Navigator.push(context, MaterialPageRoute(builder: (context) => Inicio(),));


} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
  }
}
  
}

// pendiente 
// hacer que se borre los datos una vez presionado el boton 
// boton regresar a donde direcciona
// subir imagenes
// 