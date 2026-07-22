import 'package:flutter/material.dart';
import 'package:wrapit/theme/theme.dart';
import 'package:wrapit/widgets/premium_button.dart';
import 'package:wrapit/screens/auth_screen.dart';
import 'package:wrapit/animations/page_transitions.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      emoji: '🎁',
      title: 'Discover Premium\nGift Hampers',
      subtitle:
          'Explore our curated collection of luxury hampers crafted for every special moment.',
      gradient: WrapItGradients.blushToRose,
    ),
    _OnboardingPage(
      emoji: '✨',
      title: 'Customize Every\nGift Your Way',
      subtitle:
          'Choose from flowers, chocolates, perfumes & more to build a truly personal hamper.',
      gradient: WrapItGradients.roseToAccent,
    ),
    _OnboardingPage(
      emoji: '🚀',
      title: 'Fast Delivery,\nElegant Packaging',
      subtitle:
          'Premium gift wrapping and express delivery to make your celebrations unforgettable.',
      gradient: WrapItGradients.luxuryPink,
    ),
  ];

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _goToAuth();
    }
  }

  void _goToAuth() {
    Navigator.of(context).pushReplacement(
      WrapItPageTransitions.slideTransition(page: const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Pages
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: 3,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Container(
                decoration: BoxDecoration(gradient: page.gradient),
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    // Emoji illustration
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.8, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) => Transform.scale(
                        scale: value,
                        child: child,
                      ),
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.15),
                              blurRadius: 50,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(page.emoji,
                              style: const TextStyle(fontSize: 72)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: WrapItText.displayLarge().copyWith(
                        color: Colors.white,
                        fontSize: 30,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      page.subtitle,
                      textAlign: TextAlign.center,
                      style: WrapItText.body().copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
              );
            },
          ),

          // Bottom controls
          Positioned(
            bottom: 48,
            left: 32,
            right: 32,
            child: Column(
              children: [
                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == i
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),

                // CTA Button
                PremiumButton(
                  label: _currentPage == 2 ? 'Start Gifting 🎉' : 'Next',
                  width: double.infinity,
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFFFF0F6)],
                  ),
                  onPressed: _nextPage,
                ),

                if (_currentPage < 2) ...[
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _goToAuth,
                    child: Text(
                      'Skip',
                      style: WrapItText.body().copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final String emoji;
  final String title;
  final String subtitle;
  final LinearGradient gradient;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}
