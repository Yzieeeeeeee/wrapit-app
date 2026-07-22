// Wrap It — Page Transitions
//
// Contains predefined premium page transitions to ensure consistency
// and add a touch of luxury to the user experience.
// Used by: splash_screen, onboarding_screen, auth_screen.

import 'package:flutter/material.dart';

class WrapItPageTransitions {
  WrapItPageTransitions._();

  // A soft cross-fade transition. Best for screen reveals like splash → onboarding.
  static PageRouteBuilder<T> fadeTransition<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  // A slide-in-from-right transition. Best for forward navigation.
  static PageRouteBuilder<T> slideTransition<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 600),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
          ),
          child: child,
        );
      },
    );
  }

  // A simultaneous fade + scale transition. Best for post-login entry into the app.
  static PageRouteBuilder<T> fadeScaleTransition<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 600),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
