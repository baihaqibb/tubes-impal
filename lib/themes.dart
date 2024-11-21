import 'package:flutter/material.dart';

const Color primary = Color(0xFF975EFF);
const Color secondaryL = Color(0xFFF3F4F4);
const Color secondaryD = Color(0xFF262626);
const Color success = Color(0xFF00A01A);
const Color danger = Colors.redAccent;

const TextStyle textStyleTitle =
    TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
const TextStyle textStyleSubtitle =
    TextStyle(fontSize: 22, fontWeight: FontWeight.normal);
const TextStyle textStyleHeader1 =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const TextStyle textStyleSubheader1 =
    TextStyle(fontSize: 18, fontWeight: FontWeight.normal);
const TextStyle textStyleHeader2 =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
const TextStyle textStyleSubheader2 =
    TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
const TextStyle textStyleNormal =
    TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
const TextStyle textStyleSmall =
    TextStyle(fontSize: 12, fontWeight: FontWeight.normal);

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
    primary: primary,
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
    primary: primary,
    onPrimary: Colors.white,
    secondary: Color(0xFF26272B),
    onSecondary: Colors.white,
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color(0xFF171518),
    onSurface: Colors.white,
    brightness: Brightness.dark,
  );
}
