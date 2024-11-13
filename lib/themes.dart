import 'package:flutter/material.dart';

const Color primary = Color(0xFF975EFF);
const Color secondaryL = Color(0xFFF3F4F4);
const Color secondaryD = Color(0xFF262626);
const Color success = Color(0xFF00A01A);
const Color danger = Color(0xFFFF0050);

class GlobalThemeData {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);
  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);
  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
        colorScheme: colorScheme,
        canvasColor: colorScheme.surface,
        scaffoldBackgroundColor: colorScheme.surface,
        highlightColor: Colors.transparent,
        focusColor: focusColor);
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xFF975EFF),
    onPrimary: Colors.black,
    secondary: Color(0xFFEAEAF0),
    onSecondary: Color(0xFF1A1B20),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF090A10),
    brightness: Brightness.light,
  );
  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xFF975EFF),
    onPrimary: Colors.white,
    secondary: Color(0xFF26272B),
    onSecondary: Colors.white,
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color(0xFF090A10),
    onSurface: Colors.white,
    brightness: Brightness.dark,
  );
}
