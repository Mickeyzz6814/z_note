import 'package:flutter/material.dart';

class AppTheme {
  static const Color color = Color.fromARGB(255, 201, 235, 234);

  static ThemeData lightMode() {
    ThemeData light = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: color),
      brightness: Brightness.light,
    );
    return light;
  }

  static ThemeData darkMode() {
    ThemeData dark = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        brightness: Brightness.dark,
      ),
    );
    return dark;
  }
}
