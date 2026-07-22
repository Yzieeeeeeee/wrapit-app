import 'package:flutter/material.dart';
import 'package:wrapit/theme/theme.dart';
import 'package:wrapit/animations/scale_on_tap.dart';

// A luxury gradient button with spring-scale animation and soft glow effect.
class PremiumButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final double? width;
  final double height;
  final Gradient? gradient;
  final bool isLoading;
  final bool outlined;

  const PremiumButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.width,
    this.height = 56,
    this.gradient,
    this.isLoading = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final grad = gradient ?? WrapItGradients.accentButton;
    return ScaleOnTap(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: outlined ? null : grad,
          borderRadius: BorderRadius.circular(WrapItRadius.pill),
          border: outlined
              ? Border.all(color: WrapItColors.accent, width: 2)
              : null,
          boxShadow: outlined ? null : WrapItShadows.glow,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: outlined ? WrapItColors.accent : Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: WrapItText.button().copyWith(
                        color: outlined ? WrapItColors.accent : Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// A small chip-style action button for inline actions like "Add to Cart".
class MiniActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? color;

  const MiniActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? WrapItColors.accent;
    return ScaleOnTap(
      onTap: onPressed,
      child: Material(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(WrapItRadius.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: c),
                const SizedBox(width: 6),
              ],
              Text(label,
                  style: WrapItText.label().copyWith(color: c, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
