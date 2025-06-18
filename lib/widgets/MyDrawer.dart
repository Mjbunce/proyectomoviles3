import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:proyecto/genero/Accion.dart';
import 'package:proyecto/genero/Comedia.dart';
import 'package:proyecto/genero/Infantil.dart';
import 'package:proyecto/genero/Terror.dart';
import 'package:proyecto/screens/inicio.dart';
import 'package:proyecto/screens/bienvenida.dart'; // <-- Importa aquí tu pantalla de bienvenida
import 'package:proyecto/styles/styles.dart';

class MyDrawer extends StatelessWidget {
  final BuildContext parentContext;
  const MyDrawer({Key? key, required this.parentContext}) : super(key: key);

  Future<Map<String, dynamic>?> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final ref = FirebaseDatabase.instance.ref("usuarios/${user.uid}");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.map((key, value) => MapEntry(key.toString(), value));
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                return UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: AppColors.inputFill),
                  accountName: Text('Cargando...', style: AppTextStyles.subtitle),
                  accountEmail: Text('', style: AppTextStyles.subtitle),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: AppColors.primaryYellow,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                final userData = snapshot.data!;
                final nombre = userData["nombres"] ?? "Usuario";
                final correo = userData["correo"] ?? "correo@ejemplo.com";

                return UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: AppColors.inputFill),
                  accountName: Text(nombre, style: AppTextStyles.subtitle),
                  accountEmail: Text(correo, style: AppTextStyles.subtitle),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: AppColors.primaryYellow,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                );
              } else {
                return UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: AppColors.inputFill),
                  accountName: Text('Usuario', style: AppTextStyles.subtitle),
                  accountEmail: Text('usuario@ejemplo.com', style: AppTextStyles.subtitle),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: AppColors.primaryYellow,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                );
              }
            },
          ),

          // Tus opciones existentes
          ListTile(
            leading: Icon(
              Icons.sentiment_very_satisfied,
              color: AppColors.primaryYellow,
            ),
            title: Text('Comedia', style: AppTextStyles.subtitle),
            onTap: () {
              Navigator.pop(parentContext);
              Navigator.push(
                parentContext,
                MaterialPageRoute(builder: (_) => Comedia()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.child_care, color: AppColors.primaryYellow),
            title: Text('Infantil', style: AppTextStyles.subtitle),
            onTap: () {
              Navigator.pop(parentContext);
              Navigator.push(
                parentContext,
                MaterialPageRoute(builder: (_) => Infantil()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.nightlight_round, color: AppColors.primaryYellow,
            ),
            title: Text('Terror', style: AppTextStyles.subtitle),
            onTap: () {
              Navigator.pop(parentContext);
              Navigator.push(
                parentContext,
                MaterialPageRoute(builder: (_) => Terror()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.flash_on, color: AppColors.primaryYellow),
            title: Text('Acción', style: AppTextStyles.subtitle),
            onTap: () {
              Navigator.pop(parentContext);
              Navigator.push(
                parentContext,
                MaterialPageRoute(builder: (_) => Accion()),
              );
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

          const Divider(color: Colors.grey),

          // Aquí la opción Cerrar sesión
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.primaryYellow),
            title: Text('Cerrar sesión', style: AppTextStyles.subtitle),
            onTap: () => ()
          ),
        ],
      ),
    );
  }
}
