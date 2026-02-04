import 'package:flutter/material.dart';

/// App color palette - matches React prototype
class AppColors {
  // Primary - Emerald
  static const emerald50 = Color(0xFFECFDF5);
  static const emerald100 = Color(0xFFD1FAE5);
  static const emerald200 = Color(0xFFA7F3D0);
  static const emerald400 = Color(0xFF34D399);
  static const emerald500 = Color(0xFF10B981);
  static const emerald600 = Color(0xFF059669);
  static const emerald700 = Color(0xFF047857);
  static const emerald800 = Color(0xFF065F46);
  static const emerald900 = Color(0xFF064E3B);

  // Accent - Lime
  static const lime300 = Color(0xFFBEF264);
  static const lime400 = Color(0xFFA3E635);

  // Neutrals - Slate
  static const slate50 = Color(0xFFF8FAFC);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate600 = Color(0xFF475569);
  static const slate700 = Color(0xFF334155);
  static const slate800 = Color(0xFF1E293B);
  static const slate900 = Color(0xFF0F172A);

  // Semantic
  static const red50 = Color(0xFFFEF2F2);
  static const red100 = Color(0xFFFEE2E2);
  static const red500 = Color(0xFFEF4444);
  static const red600 = Color(0xFFDC2626);

  static const amber100 = Color(0xFFFEF3C7);
  static const amber400 = Color(0xFFFBBF24);
  static const amber500 = Color(0xFFF59E0B);
  static const amber600 = Color(0xFFD97706);
  static const amber700 = Color(0xFFB45309);

  static const indigo900 = Color(0xFF312E81);

  // Surface
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
}

/// App theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      
      // Color scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.emerald600,
        secondary: AppColors.lime400,
        surface: AppColors.white,
        error: AppColors.red500,
        onPrimary: AppColors.white,
        onSecondary: AppColors.emerald900,
        onSurface: AppColors.slate900,
      ),

      scaffoldBackgroundColor: AppColors.slate50,

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.emerald700,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.slate100, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.slate200, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.slate200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.emerald500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.red500, width: 1),
        ),
        contentPadding: const EdgeInsets.all(16),
        hintStyle: const TextStyle(
          color: AppColors.slate300,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emerald600,
          foregroundColor: AppColors.white,
          elevation: 4,
          shadowColor: AppColors.emerald600.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.slate500,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.emerald800,
          backgroundColor: AppColors.emerald50,
          side: const BorderSide(color: AppColors.emerald100, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ),

      // Text theme
      textTheme: const TextTheme(
        // Display
        displayLarge: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: AppColors.slate900,
          height: 1.1,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: AppColors.slate900,
          height: 1.2,
        ),
        displaySmall: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.slate900,
          height: 1.2,
        ),

        // Headline
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.slate900,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.slate900,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.slate900,
          height: 1.4,
        ),

        // Title
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.slate900,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.slate900,
          height: 1.4,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.slate900,
          height: 1.4,
        ),

        // Body
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.slate700,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.slate600,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.slate500,
          height: 1.5,
        ),

        // Label
        labelLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.slate400,
          letterSpacing: 0.5,
          height: 1.4,
        ),
        labelMedium: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.slate400,
          letterSpacing: 0.5,
          height: 1.4,
        ),
        labelSmall: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: AppColors.slate400,
          letterSpacing: 0.5,
          height: 1.4,
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.emerald600,
        unselectedItemColor: AppColors.slate400,
        selectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  // Shadow styles matching React prototype
  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: AppColors.slate900.withOpacity(0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: AppColors.slate900.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: AppColors.slate900.withOpacity(0.1),
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowXl => [
        BoxShadow(
          color: AppColors.slate900.withOpacity(0.15),
          blurRadius: 25,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> shadowColored(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
      ];
}