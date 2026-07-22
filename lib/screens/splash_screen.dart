import 'package:flutter/material.dart';
import 'package:wrapit/theme/theme.dart';
import 'package:wrapit/screens/onboarding_screen.dart';
import 'package:wrapit/animations/floating_particles.dart';
import 'package:wrapit/animations/page_transitions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)),
    );

    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.5, 0.8, curve: Curves.easeOut)),
    );

    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          WrapItPageTransitions.fadeTransition(page: const OnboardingScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: WrapItGradients.splash),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Extracted reusable particles animation
            const FloatingParticles(
              emojis: ['🎀', '✨', '💝', '🎗️', '💫', '🌸'],
              count: 6,
            ),

            // Main logo content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo icon
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoFade.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.25),
                      boxShadow: [
                        BoxShadow(
                          color: WrapItColors.accent.withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🎁', style: TextStyle(fontSize: 52)),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // App name
                AnimatedBuilder(
                  animation: _logoFade,
                  builder: (context, child) => Opacity(
                    opacity: _logoFade.value,
                    child: child,
                  ),
                  child: Text(
                    'Wrap It',
                    style: WrapItText.displayLarge().copyWith(
                      color: Colors.white,
                      fontSize: 38,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Tagline
                AnimatedBuilder(
                  animation: _taglineFade,
                  builder: (context, child) => Opacity(
                    opacity: _taglineFade.value,
                    child: child,
                  ),
                  child: Text(
                    'Wrapped with Love, Delivered with Care.',
                    style: WrapItText.body().copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
