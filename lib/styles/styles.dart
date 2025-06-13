import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color.fromARGB(255, 0, 0, 0);        // Negro con toque gris
  static const Color primaryYellow = Color(0xFFFFD740);     // Amarillo patito
  static const Color textWhite = Colors.white;
  static const Color textGrey = Colors.white70;
  static const Color inputFill = Color(0xFF2E2E2E);          // Gris oscuro para inputs
}

class AppTextStyles {
  static const TextStyle title = TextStyle(
    color: AppColors.textWhite,
    fontSize: 48,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitle = TextStyle(
    color: AppColors.textGrey,
    fontSize: 20,
  );

  static const TextStyle button = TextStyle(
    color: Colors.black,
    fontSize: 18,
  );

  static const TextStyle link = TextStyle(
    color: AppColors.primaryYellow,
    decoration: TextDecoration.underline,
    fontSize: 16,
  );

  static const TextStyle formTitle = TextStyle(
    color: AppColors.textWhite,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
}

class AppDecorations {
  static InputDecoration input(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textGrey),
      filled: true,
      fillColor: AppColors.inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class AppButtonStyle {
  static ButtonStyle yellowButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryYellow,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    textStyle: AppTextStyles.button,
  );
}
