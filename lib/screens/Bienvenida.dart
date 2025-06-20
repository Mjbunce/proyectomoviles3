import 'package:flutter/material.dart';
import '../styles/styles.dart';

class Bienvenida extends StatelessWidget {
  final Function(int) onNavigate;

  const Bienvenida({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(18),
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
                const SizedBox(height: 20),
                const Text(
                  "Explora, mira y disfruta",
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: 30),

                // Botones amarillo patito
                ElevatedButton.icon(
                  style: AppButtonStyle.yellowButton.copyWith(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 8, horizontal: 20), // Ajuste de padding
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(Size(130, 40)), // Tamaño mínimo
                  ),
                  onPressed: () => onNavigate(1), // Página login
                  icon: const Icon(Icons.login, color: Colors.black),
                  label: const Text(
                    "Ingreso",
                    style: TextStyle(fontSize: 14), // Reducción de tamaño de texto
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: AppButtonStyle.yellowButton.copyWith(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 8, horizontal: 20), // Ajuste de padding
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(Size(130, 40)), // Tamaño mínimo
                  ),
                  onPressed: () => onNavigate(2), // Página registro
                  icon: const Icon(Icons.person_add, color: Colors.black),
                  label: const Text(
                    "Crear cuenta",
                    style: TextStyle(fontSize: 14), // Reducción de tamaño de texto
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              width: 650,
              height: 650,
              color: Colors.transparent,
              child: Image.asset(
                'assets/imagenes/fondo2.png', // Asegúrate que la ruta sea correcta
                fit: BoxFit.cover, // Puedes cambiar esto según lo que necesites
              ),
            ),
          ),
        ],
      ),
    );
  }
}

