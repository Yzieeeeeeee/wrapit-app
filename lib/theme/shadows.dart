// ─────────────────────────────────────────────────────────────────
// Wrap It — Shadows
// ─────────────────────────────────────────────────────────────────
//
// Predefined box shadows to maintain consistent elevation and depth
// across the application.
// ─────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class WrapItShadows {
  WrapItShadows._();

  static List<BoxShadow> get soft => [
        BoxShadow(
          color: const Color(0xFFF8BBD9).withValues(alpha: 0.18),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get medium => [
        BoxShadow(
          color: const Color(0xFFF48FB1).withValues(alpha: 0.15),
          blurRadius: 30,
          offset: const Offset(0, 12),
        ),
      ];

  static List<BoxShadow> get glow => [
        BoxShadow(
          color: const Color(0xFFEC407A).withValues(alpha: 0.25),
          blurRadius: 24,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: const Color(0xFFF8BBD9).withValues(alpha: 0.08),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.06),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: const Color(0xFFF8BBD9).withValues(alpha: 0.12),
          blurRadius: 48,
          offset: const Offset(0, 16),
        ),
      ];
}
