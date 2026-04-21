import 'package:flutter/material.dart';

/// The design system for the Calculator app, optimized for WCAG accessibility
/// and high-fidelity UI aesthetics.
class AppTheme {
  // Dark Mode Palette (High Contrast)
  static const Color darkBg = Color(0xFF0E0E10);
  static const Color darkSurface = Color(0xFF17171C);
  static const Color numberColorDark = Color(0xFF25252B); // Lighter for elevation
  static const Color operatorColorDark = Color(0xFF323344); // Brightened for contrast
  static const Color actionColorDark = Color(0xFF4A4B5A); // Brightened

  // Light Mode Palette (High Contrast)
  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF1F2F3);
  static const Color numberColorLight = Color(0xFFFFFFFF);
  static const Color operatorColorLight = Color(0xFFD2D3DA); // Distinct contrast for operators
  static const Color actionColorLight = Color(0xFFE5E5E5);

  // Signature Action Colors
  static const Color acColor = Color(0xFFFF2D55); //  Red/Pink for All Clear
  static const Color cColor = Color(0xFF637381); // Muted Slate for Clear Entry
  static const Color signColor = Color(0xFF637381); // Slate gray for standard operations

  // Equals Signature Gradient
  static const List<Color> equalsGradient = [Color(0xFFFF2D55), Color(0xFFFF9500)];

  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBg,
    colorScheme: const ColorScheme.light(primary: Color(0xFFFF2D55), surface: lightSurface, onSurface: Colors.black),
    useMaterial3: true,
    fontFamily: 'Inter',
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    colorScheme: const ColorScheme.dark(primary: Color(0xFFFF2D55), surface: darkSurface, onSurface: Colors.white),
    useMaterial3: true,
    fontFamily: 'Inter',
  );
}
