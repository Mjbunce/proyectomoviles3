import 'package:flutter/material.dart';
import 'package:proyecto/styles/styles.dart';
import 'package:proyecto/screens/Bienvenida.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MenorDrawer extends StatelessWidget {
  const MenorDrawer({Key? key}) : super(key: key);

  Future<Map<String, dynamic>?> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      final ref = FirebaseDatabase.instance.ref("usuarios/${user.uid}");
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is Map) {
          return {
            "nombres": data["nombres"]?.toString() ?? "Usuario",
            "correo": data["correo"]?.toString() ?? user.email ?? "correo@ejemplo.com",
          };
        }
      }
    } catch (e) {
      debugPrint("Error al obtener los datos del usuario: $e");
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
                nombre = userData["nombres"];
                correo = userData["correo"];
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
                          Navigator.of(context).pop();
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => Bienvenida(onNavigate: (_) {}),
                            ),
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
