// ─────────────────────────────────────────────────────────────────
// Wrap It — Brand Color Palette
// ─────────────────────────────────────────────────────────────────
//
// All color constants for the Wrap It luxury gift hamper marketplace.
// Organized by purpose: core brand → semantic → neutrals → glass effects.
//
// Usage:
//   import 'package:wrapit/theme/colors.dart';
//   Container(color: WrapItColors.primary)
// ─────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class WrapItColors {
  WrapItColors._();

  // ── Core Brand ──────────────────────────────────────────────
  // Soft blush pink — primary brand color used for backgrounds and highlights.
  static const Color primary = Color(0xFFF8BBD9);

  // Rose pink — secondary brand color for medium-emphasis elements.
  static const Color secondary = Color(0xFFF48FB1);

  // Luxury pink — accent color for CTAs, badges, and active states.
  static const Color accent = Color(0xFFEC407A);

  // ── Backgrounds ─────────────────────────────────────────────
  // Warm off-white with a subtle pink undertone.
  static const Color background = Color(0xFFFFF8FB);

  // Pure white for card surfaces.
  static const Color cardWhite = Color(0xFFFFFFFF);

  // White with a light rose tint for secondary card areas.
  static const Color cardTint = Color(0xFFFFF0F6);

  // ── Semantic ────────────────────────────────────────────────
  // Mint green — used for success states, confirmations, and ratings.
  static const Color success = Color(0xFF7ED6A7);

  // Soft coral red — used for error states and destructive actions.
  static const Color error = Color(0xFFFF6B81);

  // Warm yellow — used for warnings and cautionary states.
  static const Color warning = Color(0xFFFFD93D);

  // Soft blue — used for informational messages.
  static const Color info = Color(0xFF74B9FF);

  // ── Neutrals ────────────────────────────────────────────────
  // Dark charcoal — primary text color for headings and body text.
  static const Color textDark = Color(0xFF2D2D3A);

  // Medium grey — secondary text color for descriptions and subtitles.
  static const Color textMedium = Color(0xFF6B6B80);

  // Light grey — tertiary text color for hints, captions, and placeholders.
  static const Color textLight = Color(0xFFA0A0B5);

  // Soft pink-grey — used for dividers, borders, and separators.
  static const Color divider = Color(0xFFF0E6EE);

  // Light pink shimmer — used for loading skeleton placeholders.
  static const Color shimmer = Color(0xFFFCE4EC);

  // ── Glass Effects ───────────────────────────────────────────
  // Semi-transparent white for frosted glass backgrounds.
  static const Color glassWhite = Color(0x40FFFFFF);

  // Semi-transparent pink for tinted glass panels.
  static const Color glassPink = Color(0x20F8BBD9);

  // Semi-transparent white for glass border highlights.
  static const Color glassBorder = Color(0x30FFFFFF);
}
