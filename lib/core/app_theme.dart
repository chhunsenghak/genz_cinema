import 'package:flutter/material.dart';

class AppColors {
  // --- PRIMARY THEME (Cinematic Red) ---
  static const Color background = Color(0xFF000000); // Pure Black
  static const Color richBlack = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFF292929);
  static const Color primary = Color(0xFFC4161C); // Bright Red
  static const Color primaryDark = Color(0xFF840307); // Deep Red
  static const Color accent = Color(0xFFC4161C);
  static const Color textHigh = Color(0xFFFFFFFF);
  static const Color textMedium = Color(0xFFBCBCBC);
  static const Color textLow = Color(0xFF636363);

  // --- SECONDARY THEME (Cyber Purple - Legacy) ---
  static const Color secondaryBackground = Color(0xFF0F0C29);
  static const Color secondarySurface = Color(0xFF1E1B3A);
  static const Color secondaryPrimary = Color(0xFF7B61FF);
  static const Color secondaryAccent = Color(0xFF00F0FF);

  // Aliases for backward compatibility
  static const Color textPrimary = textHigh;
  static const Color textSecondary = textMedium;
  static const Color cardGradientStart = Color(0xFF121212);
  static const Color cardGradientEnd = Color(0xFF000000);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.primaryDark,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textMedium,
        error: Colors.redAccent,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textHigh,
          letterSpacing: 1.2,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: AppColors.textMedium,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
