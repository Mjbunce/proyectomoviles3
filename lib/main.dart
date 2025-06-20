import 'package:flutter/material.dart';
import 'package:proyecto/screens/Bienvenida.dart';
import 'package:proyecto/screens/Login.dart';
import 'package:proyecto/screens/Registro.dart';



// FIREBASE
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart';


// SUPABASE
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> main() async {
  // se agrego estas lineas antes de run 
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);


 // Inicializa Supabase
  await Supabase.initialize(
    url: 'https://ocnthmxuyvlcmdvnhvfp.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9jbnRobXh1eXZsY21kdm5odmZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAzNDMxMTgsImV4cCI6MjA2NTkxOTExOH0.TUMJffuj9gcc_zgyZv75_JNX2OgV6yHXdNOhvIk2BHI',         
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
