import 'package:flutter/material.dart';

class AppColors {
  // ═══════════════════════════════════════════════
  //  CORE BRAND COLORS (KINETIC)
  // ═══════════════════════════════════════════════
  static const Color primary = Color(0xFF8EFF71);
  static const Color background = Color(0xFF0E0E0E);
  static const Color onPrimaryFixed = Color(0xFF064200);

  // ═══════════════════════════════════════════════
  //  SURFACES (ELITE DARK SYSTEM)
  // ═══════════════════════════════════════════════
  static const Color surfaceContainerLow = Color(0xFF131313);
  static const Color surfaceContainerHigh = Color(0xFF201F1F);
  static const Color surfaceContainerHighest = Color(0xFF262626);
  static const Color surfaceBright = Color(0xFF2C2C2C);
  
  // ═══════════════════════════════════════════════
  //  TEXT & CONTENT
  // ═══════════════════════════════════════════════
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onSurfaceVariant = Color(0xFFADAAAA);
  static const Color textLight = Color(0xFFADAAAA);
  static const Color textDark = Color(0xFFFFFFFF);
  
  // ═══════════════════════════════════════════════
  //  OUTLINES & ACCENTS
  // ═══════════════════════════════════════════════
  static const Color outline = Color(0xFF767575);
  static const Color outlineVariant = Color(0xFF484847);
  
  // ═══════════════════════════════════════════════
  //  LEGACY COMPATIBILITY (ALIASED TO BRAND)
  // ═══════════════════════════════════════════════
  static const Color primaryBlue = primary;
  static const Color primaryGreen = Color(0xFF5ED14A); // A slightly different green for gradients

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}