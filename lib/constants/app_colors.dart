import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF5B2EFF);
  static const Color primaryLight = Color(0xFF7B52FF);
  static const Color primaryDark = Color(0xFF3D1FCC);

  // Secondary
  static const Color secondary = Color(0xFF8B6FF5);

  // Background
  static const Color background = Color(0xFF0A0B1E);
  static const Color backgroundSecondary = Color(0xFF0F1230);
  static const Color surface = Color(0xFF1A1B3A);
  static const Color surfaceLight = Color(0xFF252650);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B3CC);
  static const Color textHint = Color(0xFF6B6E8A);

  // Toggle
  static const Color toggleActive = Color(0xFF5B2EFF);
  static const Color toggleInactive = Color(0xFF3A3B5C);

  // Gradient
  static const List<Color> backgroundGradient = [
    Color(0xFF0A0B1E),
    Color(0xFF0D1033),
    Color(0xFF0A1628),
  ];

  static const List<Color> cardGradient = [
    Color(0xFF1E2045),
    Color(0xFF161838),
  ];
}
