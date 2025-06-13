import 'package:flutter/material.dart';
import '../styles/styles.dart';

class Bienvenida extends StatelessWidget {
  final Function(int) onNavigate;

  const Bienvenida({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Parte izquierda con texto y botones
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Todo a la izquierda
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("SpotMovie", style: AppTextStyles.title),
                const SizedBox(height: 12),
                const Text(
                  "Explora, mira y disfruta",
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: 30),

                // Botones amarillo patito
                ElevatedButton.icon(
                  style: AppButtonStyle.yellowButton,
                  onPressed: () => onNavigate(1), // Página login
                  icon: const Icon(Icons.login, color: Colors.black),
                  label: const Text("Inicio de sesión"),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: AppButtonStyle.yellowButton,
                  onPressed: () => onNavigate(2), // Página registro
                  icon: const Icon(Icons.person_add, color: Colors.black),
                  label: const Text("Crear cuenta"),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              width: 750,
              height: 750,
              color: Colors.transparent,
              child: Image.asset(
                'assets/imagenes/fondo.png', // Asegúrate que la ruta sea correcta
                fit: BoxFit.contain, // Puedes cambiar esto según lo que necesites
              ),
            ),
          ),
        ],
      ),
    );
  }
}
