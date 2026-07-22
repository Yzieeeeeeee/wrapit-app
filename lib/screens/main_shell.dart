import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:wrapit/theme/theme.dart';
import 'package:wrapit/state/app_state.dart';
import 'package:wrapit/screens/auth_screen.dart';
import 'package:wrapit/screens/home_tab.dart';
import 'package:wrapit/screens/categories_tab.dart';
import 'package:wrapit/screens/customize_tab.dart';
import 'package:wrapit/screens/cart_tab.dart';
import 'package:wrapit/screens/profile_tab.dart';
import 'package:wrapit/widgets/offer_modal.dart';

class MainShell extends StatefulWidget {
  final AppState appState;
  const MainShell({super.key, required this.appState});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {

  @override
  void initState() {
    super.initState();
    widget.appState.addListener(_onStateChange);

    // Show the offer modal ~900ms after the home screen settles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 900), _showOffer);
    });
  }

  void _showOffer() {
    if (!mounted) return;
    OfferModal.show(
      context,
      offer: sampleOffers.first,
      onClaim: () => widget.appState.setTab(1),
    );
  }

  @override
  void dispose() {
    widget.appState.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  Widget _buildPage(int index) {
    return switch (index) {
      0 => HomeTab(appState: widget.appState),
      1 => CategoriesTab(appState: widget.appState),
      2 => CustomizeTab(appState: widget.appState),
      3 => CartTab(appState: widget.appState),
      4 => ProfileTab(appState: widget.appState),
      _ => HomeTab(appState: widget.appState),
    };
  }

  // No longer using _buildDestinations as we use liquid_glass_easy directly

  @override
  Widget build(BuildContext context) {
    final idx = widget.appState.currentTab;

    // Build the page body with cross-fade animation between tabs
    final pageBody = AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: KeyedSubtree(
        key: ValueKey(idx),
        child: _buildPage(idx),
      ),
    );

    final cart = widget.appState.cartItemCount;

    return AppStateProvider(
      state: widget.appState,
      child: LiquidGlassScaffold(
        body: pageBody,
        actionMargin: 0,
        bottomNavigationBar: LiquidGlassBottomNavBar(
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16.h),
          width: 320.w,
          height: 64.h,
          selectedIndex: idx,
          onChanged: widget.appState.setTab,
          pillStyle: LiquidGlassNavPillStyle(
            animated: true,
            mode: LiquidGlassPillMode.both,
            show: true,
            color: WrapItColors.accent.withValues(alpha: 0.15),
          ),
          itemStyle: LiquidGlassNavItemStyle(
            selectedColor: WrapItColors.accent,
            unselectedColor: WrapItColors.textMedium,
            iconSize: 22.sp,
            labelFontSize: 10.sp,
          ),
          items: const [
            LiquidGlassTabBarItem(icon: Icons.home_outlined, selectedIcon: Icons.home_rounded, label: 'Home'),
            LiquidGlassTabBarItem(icon: Icons.category_outlined, selectedIcon: Icons.category_rounded, label: 'Categories'),
            LiquidGlassTabBarItem(icon: Icons.auto_awesome_outlined, selectedIcon: Icons.auto_awesome_rounded, label: 'Customize'),
            LiquidGlassTabBarItem(icon: Icons.shopping_bag_outlined, selectedIcon: Icons.shopping_bag_rounded, label: 'Cart'),
            LiquidGlassTabBarItem(icon: Icons.person_outline_rounded, selectedIcon: Icons.person_rounded, label: 'Profile'),
          ],
        ),
        bottomNavigationBarAction: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16.h),
            child: SizedBox(
              height: 64.h,
              width: 320.w,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Vertical borders separating the tabs
                  IgnorePointer(
                    child: Row(
                      children: List.generate(5 * 2 - 1, (index) {
                        if (index.isEven) {
                          return const Expanded(child: SizedBox()); // Icon area
                        } else {
                          return Container(
                            width: 1,
                            height: 24.h,
                            color: WrapItColors.textMedium.withValues(alpha: 0.15),
                          );
                        }
                      }),
                    ),
                  ),
                  // Cart badge
                  if (cart > 0)
                    Positioned(
                      top: 4.h,
                      right: (320.w / 5) * 1 + (320.w / 10) - 10.w, // Position over the 4th tab (index 3, so right offset is 1 full tab + half tab)
                      child: IgnorePointer(
                        child: Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: const BoxDecoration(
                            color: WrapItColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
