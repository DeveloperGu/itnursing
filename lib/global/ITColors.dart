import 'package:flutter/material.dart';

class ITColors {
  static const blue900 = Color(0xFF05192F);
  static const blue800 = Color(0xFF0A2F4F);
  static const blue700 = Color(0xFF0F5C8D);
  static const blue500 = Color(0xFF1C7ED6);
  static const blue100 = Color(0xFFE8F2FB);
  static const gray900 = Color(0xFF0B2540);
  static const gray700 = Color(0xFF41536B);
  static const gray500 = Color(0xFF7C8BA1);
  static const gray200 = Color(0xFFD9E1EC);
  static const gray100 = Color(0xFFF5F7FB);
  static const success = Color(0xFF2F9E44);
  static const danger = Color(0xFFE03131);
  static const warning = Color(0xFFF08C00);
  static const surface = Colors.white;
  static const surfaceAlt = Color(0xFFF6F9FE);

  static const gradientPrimary = LinearGradient(
    colors: [blue900, blue700],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientAccent = LinearGradient(
    colors: [blue700, blue500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}