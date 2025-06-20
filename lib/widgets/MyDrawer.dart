import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:proyecto/genero/Accion.dart';
import 'package:proyecto/genero/Comedia.dart';
import 'package:proyecto/genero/Infantil.dart';
import 'package:proyecto/genero/Terror.dart';
import 'package:proyecto/screens/inicio.dart';
import 'package:proyecto/screens/bienvenida.dart';
import 'package:proyecto/styles/styles.dart';

class MyDrawer extends StatelessWidget {
  final BuildContext parentContext;
  const MyDrawer({Key? key, required this.parentContext}) : super(key: key);

  Future<Map<String, dynamic>?> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      final ref = FirebaseDatabase.instance.ref("usuarios/${user.uid}");
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is Map) {
          return Map<String, dynamic>.from(data as Map);
        }
      }
    } catch (e) {
      debugPrint("Error obteniendo datos del usuario: $e");
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: ListView(
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: _getUserData(),
            builder: (context, snapshot) {
              String nombre = 'Usuario';
              String correo = 'usuario@ejemplo.com';

              if (snapshot.connectionState == ConnectionState.waiting) {
                nombre = 'Cargando...';
                correo = '';
              } else if (snapshot.hasError) {
                nombre = 'Error al cargar';
                correo = '';
              } else if (snapshot.hasData && snapshot.data != null) {
                final userData = snapshot.data!;
                nombre = userData["nombres"] ?? "Usuario";
                correo = userData["correo"] ?? "correo@ejemplo.com";
              }

              return DrawerHeader(
                decoration: BoxDecoration(color: AppColors.inputFill),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryYellow,
                      radius: 30,
                      child: Icon(Icons.person, color: Colors.black, size: 30),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Hola! $nombre',
                      style: AppTextStyles.subtitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      correo,
                      style: AppTextStyles.subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.sentiment_very_satisfied, color: AppColors.primaryYellow),
            title: Text('Comedia', style: AppTextStyles.subtitle),
            onTap: () {
              Navigator.pop(parentContext);
              Navigator.push(parentContext, MaterialPageRoute(builder: (_) => Comedia()));
            },
          ),
          ListTile(
            leading: Icon(Icons.child_care, color: AppColors.primaryYellow),
            title: Text('Infantil', style: AppTextStyles.subtitle),
            onTap: () {
              Navigator.pop(parentContext);
              Navigator.push(parentContext, MaterialPageRoute(builder: (_) => Infantil()));
            },
          ),
          ListTile(
            leading: Icon(Icons.nightlight_round, color: AppColors.primaryYellow),
            title: Text('Terror', style: AppTextStyles.subtitle),
            onTap: () {
              Navigator.pop(parentContext);
              Navigator.push(parentContext, MaterialPageRoute(builder: (_) => Terror()));
            },
          ),
          ListTile(
            leading: Icon(Icons.flash_on, color: AppColors.primaryYellow),
            title: Text('Acción', style: AppTextStyles.subtitle),
            onTap: () {
              Navigator.pop(parentContext);
              Navigator.push(parentContext, MaterialPageRoute(builder: (_) => Accion()));
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.home, color: AppColors.primaryYellow),
            title: Text('Inicio', style: AppTextStyles.subtitle),
            onTap: () {
              Navigator.pop(parentContext);
              Navigator.pushAndRemoveUntil(
                parentContext,
                MaterialPageRoute(builder: (_) => Inicio()),
                (route) => false,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.primaryYellow),
            title: Text('Cerrar sesión', style: AppTextStyles.subtitle),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirmación'),
                    content: Text('¿Estás seguro que deseas salir?'),
                    actions: [
                      TextButton(
                        child: Text('No'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: Text('Sí'),
                        onPressed: () async {
                          Navigator.of(context).pop(); // Cierra el diálogo
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => Bienvenida(onNavigate: (_) {})),
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
