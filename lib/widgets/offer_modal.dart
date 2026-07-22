// lib/widgets/offer_modal.dart
//
// Wrap It — Flipkart-style Full-Screen Offer Notification
//
// A premium, dismissible full-screen promotional overlay that appears
// on app launch. The user can:
//   • Tap "Claim Offer" to navigate to the relevant offer screen.
//   • Tap the X button or the background dimmer to dismiss.
//
// Animation behavior:
//   • Entry:  slides up from bottom + fades in (400ms, easeOutCubic)
//   • Exit:   slides back down + fades out (300ms, easeInCubic)

import 'package:flutter/material.dart';
import 'package:wrapit/theme/theme.dart';

// Data model for a single offer.
class OfferData {
  final String id;
  final String emoji;
  final String badge;        // e.g. "LIMITED TIME"
  final String title;
  final String subtitle;
  final String description;
  final String ctaLabel;
  final String discountText; // e.g. "UP TO 40% OFF"
  final Color accentColor;
  final List<Color> gradientColors;
  final VoidCallback? onClaim;

  const OfferData({
    required this.id,
    required this.emoji,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.ctaLabel,
    required this.discountText,
    required this.accentColor,
    required this.gradientColors,
    this.onClaim,
  });
}

// ─── Predefined offers ───────────────────────────────────────────────────────

final List<OfferData> sampleOffers = [
  OfferData(
    id: 'monsoon_sale',
    emoji: '🎁',
    badge: 'EXCLUSIVE DEAL',
    title: 'Monsoon Gifting\nFestival',
    subtitle: 'The biggest sale of the season',
    description:
        'Get premium gift hampers with FREE express delivery and luxury wrapping. Limited time offer — only 127 hampers left!',
    ctaLabel: 'Claim Offer Now',
    discountText: 'UP TO 40% OFF',
    accentColor: const Color(0xFFEC407A),
    gradientColors: [const Color(0xFFFCE4EC), const Color(0xFFF8BBD9), const Color(0xFFF48FB1)],
  ),
  OfferData(
    id: 'birthday_bundle',
    emoji: '🎂',
    badge: 'TRENDING',
    title: 'Birthday Surprise\nBundle',
    subtitle: 'Complete birthday celebration pack',
    description:
        'Balloons, cake candles, personalized hamper & a special greeting card — everything in one gorgeous box.',
    ctaLabel: 'Shop Bundle',
    discountText: 'SAVE ₹800',
    accentColor: const Color(0xFF8E24AA),
    gradientColors: [const Color(0xFFF3E5F5), const Color(0xFFCE93D8), const Color(0xFFAB47BC)],
  ),
];

// ─── Main widget ─────────────────────────────────────────────────────────────

class OfferModal extends StatefulWidget {
  final OfferData offer;
  final VoidCallback onDismiss;
  final VoidCallback onClaim;

  const OfferModal({
    super.key,
    required this.offer,
    required this.onDismiss,
    required this.onClaim,
  });

  // Convenience: show the modal as an overlay route.
  static void show(
    BuildContext context, {
    OfferData? offer,
    VoidCallback? onClaim,
  }) {
    final data = offer ?? sampleOffers.first;
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (ctx, animation, secondaryAnimation) {
          return OfferModal(
            offer: data,
            onDismiss: () => Navigator.of(ctx).pop(),
            onClaim: onClaim ?? () => Navigator.of(ctx).pop(),
          );
        },
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  State<OfferModal> createState() => _OfferModalState();
}

class _OfferModalState extends State<OfferModal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _barrierFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
      reverseDuration: const Duration(milliseconds: 300),
    );

    _barrierFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );

    _slideAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.1, 1.0, curve: Curves.easeOutCubic)),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.1, 0.7, curve: Curves.easeOut)),
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.1, 1.0, curve: Curves.easeOutBack)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  Future<void> _claim() async {
    await _controller.reverse();
    widget.onClaim();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // ── Dimmer background ──────────────────────────────────
            GestureDetector(
              onTap: _dismiss,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withValues(alpha: _barrierFade.value * 0.65),
              ),
            ),

            // ── Offer card ────────────────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Transform.translate(
                offset: Offset(0, _slideAnimation.value * size.height * 0.55),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    alignment: Alignment.bottomCenter,
                    child: _buildCard(context),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(BuildContext context) {
    final offer = widget.offer;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: bottomPad + 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(WrapItRadius.xxl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: offer.gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: offer.accentColor.withValues(alpha: 0.35),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [

          // ── Background decorative circles ──────────────────────
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: offer.accentColor.withValues(alpha: 0.15),
              ),
            ),
          ),

          // ── Card content ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                // Top row: badge + close button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: offer.accentColor,
                        borderRadius: BorderRadius.circular(WrapItRadius.pill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 14),
                          const SizedBox(width: 5),
                          Text(offer.badge, style: WrapItText.caption().copyWith(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _dismiss,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Emoji + discount pill
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(offer.emoji, style: const TextStyle(fontSize: 64)),
                    const Spacer(),
                    // Discount badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.30),
                        borderRadius: BorderRadius.circular(WrapItRadius.pill),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.50), width: 1.5),
                      ),
                      child: Text(
                        offer.discountText,
                        style: WrapItText.label().copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Title
                Text(
                  offer.title,
                  style: WrapItText.displayMedium().copyWith(
                    color: Colors.white,
                    fontSize: 28,
                    height: 1.1,
                    shadows: [
                      Shadow(
                        color: offer.accentColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // Subtitle
                Text(
                  offer.subtitle,
                  style: WrapItText.body().copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  offer.description,
                  style: WrapItText.bodySmall().copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // Divider
                Divider(color: Colors.white.withValues(alpha: 0.20), height: 1),

                const SizedBox(height: 20),

                // CTA + dismiss row
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _claim,
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(WrapItRadius.pill),
                            boxShadow: [
                              BoxShadow(
                                color: offer.accentColor.withValues(alpha: 0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              offer.ctaLabel,
                              style: WrapItText.button().copyWith(color: offer.accentColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    GestureDetector(
                      onTap: _dismiss,
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(WrapItRadius.pill),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.40), width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            'Not Now',
                            style: WrapItText.body().copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
