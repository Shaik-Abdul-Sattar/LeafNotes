import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData theme = ThemeData(
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: const TextStyle(color: Colors.black),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.blueAccent.shade100,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
    ),
  );
}
