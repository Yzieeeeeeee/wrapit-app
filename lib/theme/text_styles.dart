// ─────────────────────────────────────────────────────────────────
// Wrap It — Text Styles
// ─────────────────────────────────────────────────────────────────
//
// Typography system using Google Fonts (Plus Jakarta Sans).
// ─────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class WrapItText {
  WrapItText._();

  static TextStyle _base() => GoogleFonts.plusJakartaSans();

  static TextStyle displayLarge() =>
      _base().copyWith(fontSize: 32, fontWeight: FontWeight.w800, color: WrapItColors.textDark, height: 1.2, letterSpacing: -0.5);

  static TextStyle displayMedium() =>
      _base().copyWith(fontSize: 26, fontWeight: FontWeight.w700, color: WrapItColors.textDark, height: 1.25);

  static TextStyle heading() =>
      _base().copyWith(fontSize: 22, fontWeight: FontWeight.w700, color: WrapItColors.textDark, height: 1.3);

  static TextStyle subheading() =>
      _base().copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: WrapItColors.textDark, height: 1.35);

  static TextStyle body() =>
      _base().copyWith(fontSize: 15, fontWeight: FontWeight.w500, color: WrapItColors.textMedium, height: 1.5);

  static TextStyle bodySmall() =>
      _base().copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: WrapItColors.textLight, height: 1.4);

  static TextStyle button() =>
      _base().copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.3);

  static TextStyle price() =>
      _base().copyWith(fontSize: 20, fontWeight: FontWeight.w800, color: WrapItColors.accent, letterSpacing: 0.5);

  static TextStyle priceOld() =>
      _base().copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: WrapItColors.textLight, decoration: TextDecoration.lineThrough);

  static TextStyle caption() =>
      _base().copyWith(fontSize: 11, fontWeight: FontWeight.w600, color: WrapItColors.textLight, letterSpacing: 0.5);

  static TextStyle label() =>
      _base().copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: WrapItColors.accent, letterSpacing: 0.3);
}
