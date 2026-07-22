// ─────────────────────────────────────────────────────────────────
// Wrap It — App Theme
// ─────────────────────────────────────────────────────────────────
//
// Material ThemeData configuration tying all design tokens together.
// ─────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'radius.dart';
import 'text_styles.dart';

ThemeData wrapItTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: WrapItColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: WrapItColors.accent,
      brightness: Brightness.light,
      primary: WrapItColors.accent,
      secondary: WrapItColors.secondary,
      surface: WrapItColors.cardWhite,
      error: WrapItColors.error,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: WrapItText.subheading(),
      iconTheme: const IconThemeData(color: WrapItColors.textDark),
    ),
    cardTheme: CardThemeData(
      color: WrapItColors.cardWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(WrapItRadius.xl)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(WrapItRadius.lg),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(WrapItRadius.lg),
        borderSide: const BorderSide(color: WrapItColors.divider, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(WrapItRadius.lg),
        borderSide: const BorderSide(color: WrapItColors.secondary, width: 2),
      ),
      hintStyle: WrapItText.body().copyWith(color: WrapItColors.textLight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: WrapItColors.accent,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(WrapItRadius.pill)),
        textStyle: WrapItText.button(),
      ),
    ),
  );
}
