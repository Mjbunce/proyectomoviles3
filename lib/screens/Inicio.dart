import 'package:flutter/material.dart';
import '../styles/styles.dart';



class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int selectedIndex = 0;

  final List<String> categorias = [
    'Estrenos',
    'Romance',
    'Comedia',
    'Niños y Familia',
  ];

  final List<Widget> contenidos = [
    Center(child: Text('🎬 Películas de Estreno', style: AppTextStyles.formTitle)),
    Center(child: Text('💕 Películas de Romance', style: AppTextStyles.formTitle)),
    Center(child: Text('😂 Películas de Comedia', style: AppTextStyles.formTitle)),
    Center(child: Text('👨‍👩‍👧‍👦 Niños y Familia', style: AppTextStyles.formTitle)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          children: categorias.asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value;
            final isSelected = index == selectedIndex;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? AppColors.primaryYellow : AppColors.textGrey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => () {
             // boton para regresar ? 
            },
            child: const Text(
              'Cerrar sesión',
              style: AppTextStyles.link,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: contenidos[selectedIndex],
      ),
    );
  }
}
