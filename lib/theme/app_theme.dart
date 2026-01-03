import 'package:flutter/material.dart';

class AppTheme {
  // ---------- LIGHT THEME ----------
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: Colors.white,

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3797EF),
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
    ),

    iconTheme: const IconThemeData(color: Colors.black, size: 24),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black, height: 1.4),
      bodySmall: TextStyle(fontSize: 13, color: Color(0xFF8E8E8E)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3797EF),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      hintStyle: const TextStyle(color: Color(0xFF8E8E8E)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF3797EF), width: 1.2),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 0.6,
    ),
  );

  // ---------- DARK THEME ----------
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF000000),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF3797EF),
      onPrimary: Colors.white,
      surface: Color(0xFF121212),
      onSurface: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF000000),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    iconTheme: const IconThemeData(color: Colors.white, size: 24),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white, height: 1.4),
      bodySmall: TextStyle(fontSize: 13, color: Color(0xFFB0B0B0)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF1A1A1A),
      hintStyle: const TextStyle(color: Color(0xFF8E8E8E)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF3797EF), width: 1.2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3797EF),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xFF2A2A2A),
      thickness: 0.6,
    ),
  );
}
