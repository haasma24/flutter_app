import 'package:flutter/material.dart';

final appTheme = ThemeData(
  primarySwatch: MaterialColor(0xFF2F68C1, {
    50: Color(0xFFE8EFFA),
    100: Color(0xFFC5D7F2),
    200: Color(0xFF9FBCEA),
    300: Color(0xFF78A1E1),
    400: Color(0xFF5B8CDA),
    500: Color(0xFF3D78D3),
    600: Color(0xFF3770CE),
    700: Color(0xFF2F65C8),
    800: Color(0xFF275BC2),
    900: Color(0xFF1A48B7),
  }),
  primaryColor: Color(0xFF2F68C1),
  secondaryHeaderColor: Color(0xFF9AA8CB),
  scaffoldBackgroundColor: Color(0xFFF5F5F5),
  cardColor: Colors.white,
  textTheme: TextTheme(
    titleLarge: TextStyle(color: Color(0xFF1B0000)),
    bodyLarge: TextStyle(color: Color(0xFF5C3F3F)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF2F68C1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      elevation: 4,
    ),
  ),
);