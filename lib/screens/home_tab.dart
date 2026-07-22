import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wrapit/theme/theme.dart';
import 'package:wrapit/state/app_state.dart';
import 'package:wrapit/widgets/premium_button.dart';
import 'package:wrapit/animations/scale_on_tap.dart';

class HomeTab extends StatefulWidget {
  final AppState appState;
  const HomeTab({super.key, required this.appState});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  final _bannerController = PageController(viewportFraction: 0.88);
  int _bannerPage = 0;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_bannerController.hasClients) {
        final next = (_bannerPage + 1) % 4;
        _bannerController.animateToPage(next,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic);
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.appState;
    final topPad = MediaQuery.of(context).padding.top;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Top Header ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, topPad + 16, 24, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${state.userName} 👋',
                        style: WrapItText.heading(),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'What are we celebrating today?',
                        style: WrapItText.body(),
                      ),
                    ],
                  ),
                ),
                _HeaderIcon(icon: Icons.favorite_border_rounded, onTap: () {}),
                const SizedBox(width: 8),
                _HeaderIcon(icon: Icons.notifications_none_rounded, onTap: () {}),
              ],
            ),
          ),
        ),

        // ── Search Bar ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(WrapItRadius.xl),
                  boxShadow: WrapItShadows.soft,
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: WrapItColors.secondary, size: 22),
                    const SizedBox(width: 12),
                    Text('Search hampers, gifts, occasions…', style: WrapItText.body().copyWith(color: WrapItColors.textLight)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: WrapItColors.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(WrapItRadius.sm),
                      ),
                      child: const Icon(Icons.tune_rounded, color: WrapItColors.accent, size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── Hero Banner Carousel ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              children: [
                SizedBox(
                  height: 185,
                  child: PageView.builder(
                    controller: _bannerController,
                    onPageChanged: (i) => setState(() => _bannerPage = i),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final banners = [
                        _BannerData('🎂', 'Birthday Collection', 'Up to 30% Off', WrapItGradients.blushToRose),
                        _BannerData('💒', 'Wedding Specials', 'Exclusive Hampers', WrapItGradients.roseToAccent),
                        _BannerData('🍫', 'Luxury Chocolates', 'Premium Selection', WrapItGradients.luxuryPink),
                        _BannerData('🎄', 'Festive Collection', 'Limited Edition', WrapItGradients.accentButton),
                      ];
                      final banner = banners[index];
                      return AnimatedBuilder(
                        animation: _bannerController,
                        builder: (context, child) {
                          double scale = 1.0;
                          if (_bannerController.position.haveDimensions) {
                            final page = _bannerController.page ?? _bannerPage.toDouble();
                            scale = (1 - (page - index).abs() * 0.08).clamp(0.88, 1.0);
                          }
                          return Transform.scale(scale: scale, child: child);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            gradient: banner.gradient,
                            borderRadius: BorderRadius.circular(WrapItRadius.xl),
                            boxShadow: WrapItShadows.medium,
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.25),
                                        borderRadius: BorderRadius.circular(WrapItRadius.pill),
                                      ),
                                      child: Text(banner.subtitle,
                                          style: WrapItText.caption().copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(banner.title,
                                        style: WrapItText.heading().copyWith(color: Colors.white, fontSize: 20)),
                                    const SizedBox(height: 14),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(WrapItRadius.pill),
                                      ),
                                      child: Text('Shop Now',
                                          style: WrapItText.label().copyWith(fontSize: 13)),
                                    ),
                                  ],
                                ),
                              ),
                              Text(banner.emoji, style: const TextStyle(fontSize: 64)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _bannerPage == i ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: _bannerPage == i ? WrapItColors.accent : WrapItColors.primary.withValues(alpha: 0.4),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),

        // ── Categories ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shop by Occasion', style: WrapItText.subheading()),
                    GestureDetector(
                      onTap: () => state.setTab(1),
                      child: Text('See All', style: WrapItText.label()),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: const [
                      _CategoryBubble(emoji: '🎂', label: 'Birthday'),
                      _CategoryBubble(emoji: '💕', label: 'Anniversary'),
                      _CategoryBubble(emoji: '💒', label: 'Wedding'),
                      _CategoryBubble(emoji: '👶', label: 'Baby Shower'),
                      _CategoryBubble(emoji: '💝', label: 'Valentine'),
                      _CategoryBubble(emoji: '💼', label: 'Corporate'),
                      _CategoryBubble(emoji: '👑', label: 'Luxury'),
                      _CategoryBubble(emoji: '🌸', label: 'Flowers'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Exclusive Combo Offers ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🔥 Exclusive Combo Offers', style: WrapItText.subheading()),
                const SizedBox(height: 4),
                Text('Limited time deals with premium packaging', style: WrapItText.bodySmall()),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _ComboCard(emoji: '🍫🧸', title: 'Chocolate + Teddy', price: '₹1,299', oldPrice: '₹1,899', discount: '32%', color: const Color(0xFFFCE4EC)),
                      _ComboCard(emoji: '🧖✨', title: 'Luxury Spa Box', price: '₹2,499', oldPrice: '₹3,299', discount: '24%', color: const Color(0xFFF3E5F5)),
                      _ComboCard(emoji: '🎂🎈', title: 'Birthday Combo', price: '₹1,799', oldPrice: '₹2,499', discount: '28%', color: const Color(0xFFE1F5FE)),
                      _ComboCard(emoji: '💒💐', title: 'Wedding Combo', price: '₹4,999', oldPrice: '₹6,999', discount: '29%', color: const Color(0xFFFFF3E0)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Trending Hampers ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trending Hampers 🔥', style: WrapItText.subheading()),
                Text('See All', style: WrapItText.label()),
              ],
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= state.allProducts.length) return null;
                final product = state.allProducts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ProductCard(product: product, appState: state),
                );
              },
              childCount: state.allProducts.length,
            ),
          ),
        ),

        // ── Flash Sale ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: WrapItGradients.roseToAccent,
                borderRadius: BorderRadius.circular(WrapItRadius.xl),
                boxShadow: WrapItShadows.glow,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('⚡ Flash Sale', style: WrapItText.heading().copyWith(color: Colors.white)),
                        const SizedBox(height: 6),
                        Text('Ends in 02:45:30', style: WrapItText.body().copyWith(color: Colors.white.withValues(alpha: 0.85))),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(WrapItRadius.pill),
                          ),
                          child: Text('Shop Now', style: WrapItText.label().copyWith(fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  const Text('🎁', style: TextStyle(fontSize: 56)),
                ],
              ),
            ),
          ),
        ),

        // Bottom spacing for nav bar
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(WrapItRadius.md),
          boxShadow: WrapItShadows.soft,
        ),
        child: Icon(icon, color: WrapItColors.textDark, size: 22),
      ),
    );
  }
}

class _CategoryBubble extends StatelessWidget {
  final String emoji;
  final String label;
  const _CategoryBubble({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: ScaleOnTap(
        onTap: () {},
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: WrapItShadows.soft,
                border: Border.all(color: WrapItColors.divider, width: 1.5),
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
            ),
            const SizedBox(height: 8),
            Text(label, style: WrapItText.caption().copyWith(color: WrapItColors.textMedium, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _ComboCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String price;
  final String oldPrice;
  final String discount;
  final Color color;

  const _ComboCard({
    required this.emoji,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(WrapItRadius.xl),
        boxShadow: WrapItShadows.soft,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: WrapItColors.accent,
                  borderRadius: BorderRadius.circular(WrapItRadius.pill),
                ),
                child: Text('-$discount', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const Spacer(),
          Text(title, style: WrapItText.body().copyWith(fontWeight: FontWeight.w700, color: WrapItColors.textDark, fontSize: 14)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(price, style: WrapItText.label().copyWith(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(width: 6),
              Text(oldPrice, style: WrapItText.priceOld().copyWith(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final HamperProduct product;
  final AppState appState;

  const _ProductCard({required this.product, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(WrapItRadius.xl),
        boxShadow: WrapItShadows.card,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Emoji product image
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: WrapItGradients.softGlow,
              borderRadius: BorderRadius.circular(WrapItRadius.lg),
            ),
            child: Center(child: Text(product.emoji, style: const TextStyle(fontSize: 44))),
          ),
          const SizedBox(width: 16),

          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(product.name,
                          style: WrapItText.body().copyWith(
                            fontWeight: FontWeight.w700,
                            color: WrapItColors.textDark,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    GestureDetector(
                      onTap: () => appState.toggleFavorite(product.id),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: Icon(
                          product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          key: ValueKey(product.isFavorite),
                          color: product.isFavorite ? WrapItColors.accent : WrapItColors.textLight,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: WrapItText.bodySmall()),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Rating
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: WrapItColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(WrapItRadius.pill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB300)),
                          const SizedBox(width: 3),
                          Text('${product.rating}', style: WrapItText.caption().copyWith(color: WrapItColors.textDark, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('(${product.reviews})', style: WrapItText.caption()),
                    const Spacer(),
                    // Price
                    if (product.oldPrice != null) ...[
                      Text('₹${product.oldPrice!.toInt()}', style: WrapItText.priceOld()),
                      const SizedBox(width: 6),
                    ],
                    Text('₹${product.price.toInt()}', style: WrapItText.price().copyWith(fontSize: 17)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Tags
                    if (product.tags.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: WrapItColors.accent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(WrapItRadius.pill),
                        ),
                        child: Text(product.tags.first, style: WrapItText.caption().copyWith(color: WrapItColors.accent, fontWeight: FontWeight.w700)),
                      ),
                    const Spacer(),
                    MiniActionButton(
                      label: 'Add to Cart',
                      icon: Icons.add_rounded,
                      onPressed: () => appState.addToCart(product),
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

class _BannerData {
  final String emoji;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  const _BannerData(this.emoji, this.title, this.subtitle, this.gradient);
}
