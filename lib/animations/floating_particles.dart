// Wrap It — Floating Particles Animation
//
// A reusable background animation that spawns floating emoji/text
// particles that gently drift and rotate, ideal for splash screens.

import 'dart:math';
import 'package:flutter/material.dart';

class FloatingParticles extends StatefulWidget {
  final List<String> emojis;
  final int count;

  const FloatingParticles({
    super.key,
    required this.emojis,
    this.count = 6,
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles> with SingleTickerProviderStateMixin {
  late AnimationController _ribbonController;
  late Animation<double> _ribbonRotation;

  @override
  void initState() {
    super.initState();
    _ribbonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _ribbonRotation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _ribbonController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _ribbonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(widget.count, (i) => _FloatingRibbonItem(
        animation: _ribbonRotation,
        index: i,
        emojis: widget.emojis,
      )),
    );
  }
}

class _FloatingRibbonItem extends StatelessWidget {
  final Animation<double> animation;
  final int index;
  final List<String> emojis;

  const _FloatingRibbonItem({
    required this.animation,
    required this.index,
    required this.emojis,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final random = Random(index * 42);
    final startX = random.nextDouble() * size.width;
    final startY = random.nextDouble() * size.height;
    final ribbonSize = 16.0 + random.nextDouble() * 20;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final offset = sin(animation.value + index * 1.2) * 30;
        final yOffset = cos(animation.value + index * 0.8) * 20;
        return Positioned(
          left: startX + offset,
          top: startY + yOffset,
          child: Opacity(
            opacity: 0.3 + sin(animation.value + index) * 0.2,
            child: Text(
              emojis[index % emojis.length],
              style: TextStyle(fontSize: ribbonSize),
            ),
          ),
        );
      },
    );
  }
}
