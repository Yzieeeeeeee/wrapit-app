// lib/widgets/liquid_glass_nav.dart
//
// Wrap It — Liquid Glass Bottom Navigation Bar (v2 — correct implementation)
//
// Architecture:
//  1. A frosted glass pill (BackdropFilter + custom clip)
//  2. A "liquid blob" selection indicator that spring-animates
//     between tab positions using AnimationController + SpringSimulation
//  3. Per-icon press feedback via individual scale AnimationControllers
//  4. A shimmer/specular overlay via a pure-Dart CustomPainter
//     (no fragment shader — avoids jank and compatibility issues)
//  5. All sizes use ScreenUtil (.w / .h / .sp / .r) for full responsiveness

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wrapit/theme/theme.dart';

// ─── Nav item data ───────────────────────────────────────────────

class LiquidNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const LiquidNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// ─── Main widget ────────────────────────────────────────────────

class LiquidGlassNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<LiquidNavItem> items;

  const LiquidGlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<LiquidGlassNavBar> createState() => _LiquidGlassNavBarState();
}

class _LiquidGlassNavBarState extends State<LiquidGlassNavBar>
    with TickerProviderStateMixin {

  // ── Blob spring animation ────────────────────────────────────────
  // Drives a double from (previous tab index) → (new tab index).
  // We drive it with a SpringSimulation for authentic physics feel.
  late AnimationController _blobCtrl;
  late Animation<double> _blobAnim;
  double _blobFrom = 0;

  // ── Per-icon scale controllers (tap feedback) ────────────────────
  late List<AnimationController> _scaleCtrl;

  // ── Shimmer time controller (drives the specular highlight wave) ──
  late AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();

    _blobFrom = widget.currentIndex.toDouble();

    // Blob controller — duration is managed by SpringSimulation, not us.
    // We set a generous max so the spring has room to play out.
    _blobCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _blobAnim = AlwaysStoppedAnimation(_blobFrom);

    // Scale controllers — one per nav item
    _scaleCtrl = List.generate(
      widget.items.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 120),
        reverseDuration: const Duration(milliseconds: 380),
      ),
    );

    // Shimmer — loops indefinitely, very slow
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void didUpdateWidget(LiquidGlassNavBar old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _springToTab(widget.currentIndex.toDouble());
    }
  }

  // Launches a spring from the current blob position to [target].
  void _springToTab(double target) {
    final from = _blobAnim.value;
    _blobFrom = from;

    final spring = SpringDescription.withDampingRatio(
      mass: 1,
      stiffness: 500,
      ratio: 0.72, // < 1 → slightly underdamped → one tiny overshoot
    );

    final sim = SpringSimulation(spring, 0, 1, 0);

    // Map the spring [0→1] output onto [from→target] via a curved animation.
    _blobCtrl.reset();
    _blobAnim = _blobCtrl
        .drive(CurveTween(curve: Curves.linear))
        .drive(Tween<double>(begin: from, end: target));

    // Drive with the spring simulation (ignores the controller's duration).
    _blobCtrl.animateWith(sim);
  }

  void _onTapDown(int i) => _scaleCtrl[i].forward();
  void _onTapUp(int i) {
    _scaleCtrl[i].reverse();
    widget.onTap(i);
  }
  void _onTapCancel(int i) => _scaleCtrl[i].reverse();

  @override
  void dispose() {
    _blobCtrl.dispose();
    _shimmerCtrl.dispose();
    for (final c in _scaleCtrl) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final barH = 64.h;
    final n = widget.items.length;

    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        bottom: bottomPad + 12.h,
      ),
      child: AnimatedBuilder(
        animation: Listenable.merge([_blobCtrl, _shimmerCtrl]),
        builder: (context, _) {
          final blobIndex = _blobAnim.value; // e.g. 1.34 while animating
          return SizedBox(
            height: barH,
            child: _buildBar(blobIndex, _shimmerCtrl.value, n, barH),
          );
        },
      ),
    );
  }

  Widget _buildBar(double blobIndex, double shimmer, int n, double barH) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barW = constraints.maxWidth;
        final tabW = barW / n;

        // Blob geometry — centered under the animated tab position
        final blobW = tabW * 0.72;
        final blobH = barH * 0.68;
        final blobL = blobIndex * tabW + (tabW - blobW) / 2;

        return Stack(
          clipBehavior: Clip.none,
          children: [

            // ── 1. Frosted glass base ─────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(32.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  width: barW,
                  height: barH,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.68),
                    borderRadius: BorderRadius.circular(32.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.55),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: WrapItColors.primary.withValues(alpha: 0.20),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── 2. Specular sheen (CustomPainter — no shader needed) ──
            ClipRRect(
              borderRadius: BorderRadius.circular(32.r),
              child: CustomPaint(
                size: Size(barW, barH),
                painter: _SpecularPainter(
                  shimmer: shimmer,
                  blobPos: blobIndex / (n - 1), // normalized 0→1
                  accentColor: WrapItColors.accent,
                ),
              ),
            ),

            // ── 3. Liquid blob selection indicator ───────────────────
            AnimatedPositioned(
              duration: Duration.zero, // position is already animated by spring
              left: blobL,
              top: (barH - blobH) / 2,
              child: _LiquidBlob(
                width: blobW,
                height: blobH,
              ),
            ),

            // ── 4. Nav items ──────────────────────────────────────────
            Row(
              children: List.generate(n, (i) {
                final isSelected = widget.currentIndex == i;
                return Expanded(
                  child: GestureDetector(
                    onTapDown: (_) => _onTapDown(i),
                    onTapUp: (_) => _onTapUp(i),
                    onTapCancel: () => _onTapCancel(i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedBuilder(
                      animation: _scaleCtrl[i],
                      builder: (ctx, child) => Transform.scale(
                        scale: 1.0 - _scaleCtrl[i].value * 0.16,
                        child: child,
                      ),
                      child: _NavItemView(
                        item: widget.items[i],
                        isSelected: isSelected,
                      ),
                    ),
                  ),
                );
              }),
            ),

          ],
        );
      },
    );
  }
}

// ─── Liquid blob (selection indicator) ──────────────────────────

class _LiquidBlob extends StatelessWidget {
  final double width;
  final double height;

  const _LiquidBlob({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            WrapItColors.accent.withValues(alpha: 0.16),
            WrapItColors.secondary.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(
          color: WrapItColors.accent.withValues(alpha: 0.22),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: WrapItColors.accent.withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }
}

// ─── Specular overlay CustomPainter ─────────────────────────────
//
// Draws three layered effects without a fragment shader:
//  1. Top highlight arc — the "liquid rim" light
//  2. Selected-tab glow — a soft pink radial bloom
//  3. Bottom thin edge reflection

class _SpecularPainter extends CustomPainter {
  final double shimmer;  // 0→1 loops
  final double blobPos;  // 0→1, normalized selected tab position
  final Color accentColor;

  const _SpecularPainter({
    required this.shimmer,
    required this.blobPos,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Top specular arc ────────────────────────────────────────
    final specY = h * 0.08;
    final specH = h * 0.20;
    final shimmerOffset = math.sin(shimmer * 2 * math.pi) * w * 0.08;

    final topPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.38 + 0.12 * math.sin(shimmer * math.pi)),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(shimmerOffset, specY, w, specH));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, specY, w, specH),
        const Radius.circular(4),
      ),
      topPaint,
    );

    // ── Selected tab glow ────────────────────────────────────────
    final glowX = blobPos * w;
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          accentColor.withValues(alpha: 0.20),
          accentColor.withValues(alpha: 0.0),
        ],
        radius: 0.4,
      ).createShader(Rect.fromCenter(
        center: Offset(glowX, h * 0.5),
        width: w * 0.55,
        height: h * 1.2,
      ));

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), glowPaint);

    // ── Bottom edge reflection ────────────────────────────────────
    final bottomPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.20),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, h - 4, w, 4));

    canvas.drawRect(Rect.fromLTWH(0, h - 4, w, 4), bottomPaint);
  }

  @override
  bool shouldRepaint(_SpecularPainter old) =>
      old.shimmer != shimmer || old.blobPos != blobPos;
}

// ─── Single nav item ─────────────────────────────────────────────

class _NavItemView extends StatelessWidget {
  final LiquidNavItem item;
  final bool isSelected;

  const _NavItemView({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: anim,
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: Icon(
            isSelected ? item.activeIcon : item.icon,
            key: ValueKey(isSelected),
            size: isSelected ? 24.r : 22.r,
            color: isSelected ? WrapItColors.accent : WrapItColors.textLight,
          ),
        ),
        SizedBox(height: 3.h),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 220),
          style: TextStyle(
            fontSize: isSelected ? 10.sp : 9.5.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? WrapItColors.accent : WrapItColors.textLight,
          ),
          child: Text(item.label),
        ),
      ],
    );
  }
}
