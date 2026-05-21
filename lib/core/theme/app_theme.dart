import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color onyxBlack = Color(0xFF0B0B0E);
  static const Color electricIndigo = Color(0xFF7C7CE6);
  static const Color darkSlateGrey = Color(0xFF16161F);
  static const Color pearlWhite = Color(0xFFF5F5FA);
  static const Color dimmedAlloyGrey = Color(0xFF8E8E9F);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: onyxBlack,
      primaryColor: electricIndigo,
      colorScheme: const ColorScheme.dark(
        primary: electricIndigo,
        surface: darkSlateGrey,
        onPrimary: pearlWhite,
        onSurface: pearlWhite,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        bodyLarge: GoogleFonts.inter(color: pearlWhite),
        bodyMedium: GoogleFonts.inter(color: pearlWhite),
        bodySmall: GoogleFonts.inter(color: dimmedAlloyGrey),
        headlineLarge: GoogleFonts.outfit(color: pearlWhite, fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.outfit(color: pearlWhite, fontWeight: FontWeight.w600),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
