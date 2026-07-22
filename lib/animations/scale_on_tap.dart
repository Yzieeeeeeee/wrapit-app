// ─────────────────────────────────────────────────────────────────
// Wrap It — Scale On Tap Animation
// ─────────────────────────────────────────────────────────────────
//
// A reusable micro-interaction widget that slightly scales down its
// child when tapped, providing immediate, satisfying tactile feedback.
// ─────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class ScaleOnTap extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scaleEnd;
  final Duration duration;

  const ScaleOnTap({
    super.key,
    required this.child,
    required this.onTap,
    this.scaleEnd = 0.95,
    this.duration = const Duration(milliseconds: 150),
  });

  @override
  State<ScaleOnTap> createState() => _ScaleOnTapState();
}

class _ScaleOnTapState extends State<ScaleOnTap> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleEnd).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
