import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF7F9FC);
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryGreen = Color(0xFF00C897);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color textDark = Color(0xFF1E293B);
  static const Color textLight = Color(0xFF64748B);
}