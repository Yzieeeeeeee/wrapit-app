import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wrapit/theme/theme.dart';
import 'package:wrapit/state/app_state.dart';
import 'package:wrapit/animations/scale_on_tap.dart';
import 'package:wrapit/animations/page_transitions.dart';
import 'package:wrapit/screens/auth_screen.dart';

class ProfileTab extends StatelessWidget {
  final AppState appState;
  const ProfileTab({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WrapItColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                _buildStatsRow(),
                SizedBox(height: 24.h),
                _buildSectionTitle('My Orders'),
                _buildOrdersRow(),
                SizedBox(height: 24.h),
                _buildSectionTitle('Account'),
                _buildMenuSection(context, _accountItems(context)),
                SizedBox(height: 20.h),
                _buildSectionTitle('Preferences'),
                _buildMenuSection(context, _prefItems(context)),
                SizedBox(height: 20.h),
                _buildSignOutButton(context),
                SizedBox(height: 120.h), // nav bar clearance
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header (gradient + avatar) ──────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final name = appState.userName.isEmpty ? 'Friend' : appState.userName;

    return SliverAppBar(
      expandedHeight: 240.h,
      pinned: true,
      backgroundColor: WrapItColors.primary,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: WrapItGradients.luxuryPink,
              ),
            ),
            // Decorative circles
            Positioned(
              right: -40.w,
              top: -40.h,
              child: Container(
                width: 200.r,
                height: 200.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.10),
                ),
              ),
            ),
            Positioned(
              left: -30.w,
              bottom: -30.h,
              child: Container(
                width: 140.r,
                height: 140.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: WrapItColors.accent.withValues(alpha: 0.15),
                ),
              ),
            ),
            // Avatar + name
            Positioned(
              bottom: 24.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Avatar with gradient border ring
                  Container(
                    width: 84.r,
                    height: 84.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF48FB1), Color(0xFFEC407A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: WrapItColors.accent.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(3.r),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: WrapItText.displayMedium().copyWith(
                            color: WrapItColors.accent,
                            fontSize: 32.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    name,
                    style: WrapItText.heading().copyWith(
                      color: Colors.white,
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '✨ Premium Member',
                    style: WrapItText.bodySmall().copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.edit_outlined, color: Colors.white, size: 20.r),
          onPressed: () {},
        ),
        SizedBox(width: 4.w),
      ],
    );
  }

  // ── Stats row ───────────────────────────────────────────────────

  Widget _buildStatsRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(WrapItRadius.lg.r),
          boxShadow: WrapItShadows.soft,
        ),
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Row(
          children: [
            _StatItem(value: '${appState.orders.length}', label: 'Orders'),
            _VerticalDivider(),
            const _StatItem(value: '12', label: 'Wishlist'),
            _VerticalDivider(),
            const _StatItem(value: '840', label: 'Points'),
          ],
        ),
      ),
    );
  }

  // ── Orders quick-access row ─────────────────────────────────────

  Widget _buildOrdersRow() {
    final orderStatuses = [
      _OrderStatus(icon: Icons.inventory_2_outlined,  label: 'Pending',   color: const Color(0xFFFFA726)),
      _OrderStatus(icon: Icons.local_shipping_outlined, label: 'Shipped', color: const Color(0xFF42A5F5)),
      _OrderStatus(icon: Icons.check_circle_outline,  label: 'Delivered', color: const Color(0xFF66BB6A)),
      _OrderStatus(icon: Icons.star_outline_rounded,  label: 'Reviews',   color: WrapItColors.accent),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: orderStatuses.map((s) {
          return Expanded(
            child: ScaleOnTap(
              onTap: () {},
              child: Column(
                children: [
                  Container(
                    width: 52.r,
                    height: 52.r,
                    decoration: BoxDecoration(
                      color: s.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(s.icon, color: s.color, size: 24.r),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    s.label,
                    style: WrapItText.caption().copyWith(
                      color: WrapItColors.textMedium,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Section title ───────────────────────────────────────────────

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
      child: Text(
        title,
        style: WrapItText.label().copyWith(
          color: WrapItColors.textMedium,
          fontSize: 12.sp,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  // ── Menu section (card with stacked rows) ──────────────────────

  Widget _buildMenuSection(BuildContext context, List<_MenuItem> items) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(WrapItRadius.lg.r),
          boxShadow: WrapItShadows.soft,
        ),
        child: Column(
          children: List.generate(items.length, (i) {
            final item = items[i];
            final isLast = i == items.length - 1;
            return _MenuRow(item: item, isLast: isLast);
          }),
        ),
      ),
    );
  }

  // ── Sign out button ─────────────────────────────────────────────

  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ScaleOnTap(
        onTap: () {
          appState.logout();
          Navigator.of(context).pushReplacement(
            WrapItPageTransitions.fadeScaleTransition(page: const AuthScreen()),
          );
        },
        child: Container(
          width: double.infinity,
          height: 52.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(WrapItRadius.pill.r),
            border: Border.all(color: WrapItColors.divider, width: 1.5),
            boxShadow: WrapItShadows.soft,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 20.r),
              SizedBox(width: 10.w),
              Text(
                'Sign Out',
                style: WrapItText.button().copyWith(
                  color: Colors.red.shade400,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Menu item definitions ───────────────────────────────────────

  List<_MenuItem> _accountItems(BuildContext context) => [
    _MenuItem(icon: Icons.shopping_bag_outlined,   label: 'My Orders',         subtitle: 'Track & manage orders',  color: const Color(0xFF7B1FA2), onTap: () {}),
    _MenuItem(icon: Icons.location_on_outlined,    label: 'Saved Addresses',   subtitle: '2 saved addresses',      color: const Color(0xFF1976D2), onTap: () {}),
    _MenuItem(icon: Icons.credit_card_outlined,    label: 'Payment Methods',   subtitle: 'UPI, Cards & Wallets',   color: const Color(0xFF388E3C), onTap: () {}),
    _MenuItem(icon: Icons.card_giftcard_outlined,  label: 'Gift Cards',        subtitle: 'Redeem & purchase',      color: WrapItColors.accent,     onTap: () {}),
  ];

  List<_MenuItem> _prefItems(BuildContext context) => [
    _MenuItem(icon: Icons.notifications_outlined,  label: 'Notifications',     subtitle: 'Offers, updates & more', color: const Color(0xFFF57C00), onTap: () {}),
    _MenuItem(icon: Icons.language_outlined,       label: 'Language',          subtitle: 'English',                color: const Color(0xFF0288D1), onTap: () {}),
    _MenuItem(icon: Icons.help_outline_rounded,    label: 'Help & Support',    subtitle: 'FAQs and contact us',    color: const Color(0xFF00897B), onTap: () {}),
    _MenuItem(icon: Icons.info_outline_rounded,    label: 'About Wrap It',     subtitle: 'Version 1.0.0',          color: WrapItColors.textLight,  onTap: () {}),
  ];
}

// ─── Sub-widgets ─────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: WrapItText.heading().copyWith(
              color: WrapItColors.textDark,
              fontSize: 22.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: WrapItText.caption().copyWith(
              color: WrapItColors.textMedium,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36.h,
      color: WrapItColors.divider,
    );
  }
}

class _OrderStatus {
  final IconData icon;
  final String label;
  final Color color;
  const _OrderStatus({required this.icon, required this.label, required this.color});
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}

class _MenuRow extends StatelessWidget {
  final _MenuItem item;
  final bool isLast;
  const _MenuRow({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: item.onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(item.icon, color: item.color, size: 20.r),
                ),
                SizedBox(width: 14.w),
                // Label + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: WrapItText.body().copyWith(
                          color: WrapItColors.textDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        item.subtitle,
                        style: WrapItText.caption().copyWith(
                          color: WrapItColors.textLight,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: WrapItColors.textLight,
                  size: 20.r,
                ),
              ],
            ),
          ),
          if (!isLast)
            Divider(
              height: 1,
              indent: 70.w,
              endIndent: 16.w,
              color: WrapItColors.divider,
            ),
        ],
      ),
    );
  }
}
