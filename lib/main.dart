import 'package:flutter/material.dart';
import 'package:proyecto/screens/Bienvenida.dart';
import 'package:proyecto/screens/Login.dart';
import 'package:proyecto/screens/Registro.dart';

// FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  // se agrego estas lineas antes de run 
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(const MovieApp());
}



class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Cuerpo(),
    );
  }
}

class Cuerpo extends StatefulWidget {
  const Cuerpo({super.key});

  @override
  State<Cuerpo> createState() => _Portada();
}

class _Portada extends State<Cuerpo> {
  int index = 0;

  void cambiarPagina(int nuevoIndex) {
    setState(() {
      index = nuevoIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> paginas = [
      Bienvenida(onNavigate: cambiarPagina), 
      Login(onBack: () => cambiarPagina(0)),                       
      Registro(onBack: () => cambiarPagina(0)),                     
    ];

    return Scaffold(
      body: paginas[index],
    );
  }
}
