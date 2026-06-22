import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _primary = Color(0xFFE53935);
  static const _secondary = Color(0xFFFFB300);
  static const _surface = Color(0xFF1A1A2E);
  static const _background = Color(0xFF0F0F1A);
  static const _cardColor = Color(0xFF1E1E35);
  static const _inputFill = Color(0xFF252540);
  static const _inputBorder = Color(0xFF3A3A5C);
  static const _textMuted = Color(0xFF8888AA);

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
      primary: _primary,
      secondary: _secondary,
      surface: _surface,
      error: const Color(0xFFCF6679),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _background,
      appBarTheme: const AppBarTheme(
        backgroundColor: _surface,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: _cardColor,
        elevation: 8,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          elevation: 4,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primary,
          side: const BorderSide(color: _primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _inputBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 2),
        ),
        labelStyle: const TextStyle(color: _textMuted),
        hintStyle: const TextStyle(color: Color(0xFF555577)),
        prefixIconColor: _textMuted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _surface,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _inputFill,
        labelStyle: const TextStyle(color: Colors.white70, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A2A4A),
        thickness: 1,
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Colors.white70),
        titleSmall: TextStyle(color: Colors.white60),
        bodyLarge: TextStyle(color: Color(0xDEFFFFFF)),
        bodyMedium: TextStyle(color: Colors.white70),
        bodySmall: TextStyle(color: Colors.white54),
        labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        labelMedium: TextStyle(color: Colors.white70),
        labelSmall: TextStyle(color: Colors.white54),
      ),
    );
  }
}
