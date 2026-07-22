// ─────────────────────────────────────────────────────────────────
// Wrap It — Gradients
// ─────────────────────────────────────────────────────────────────
//
// Predefined linear gradients used across the application for buttons,
// banners, and backgrounds.
// ─────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class WrapItGradients {
  WrapItGradients._();

  static const LinearGradient blushToRose = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8BBD9), Color(0xFFF48FB1)],
  );

  static const LinearGradient roseToAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF48FB1), Color(0xFFEC407A)],
  );

  static const LinearGradient luxuryPink = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFCE4EC), Color(0xFFF8BBD9), Color(0xFFF48FB1)],
  );

  static const LinearGradient softGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFF0F6), Color(0xFFFCE4EC)],
  );

  static const LinearGradient cardShine = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFFFF5FA)],
  );

  static const LinearGradient splash = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF0F6), Color(0xFFF8BBD9), Color(0xFFF48FB1)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient accentButton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFF48FB1), Color(0xFFEC407A)],
  );
}
