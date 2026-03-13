import 'package:flutter/material.dart';

class PremiumPageRoute extends PageRouteBuilder {
  final Widget page;

  PremiumPageRoute({required this.page})
      : super(
    transitionDuration: const Duration(milliseconds: 600),
    reverseTransitionDuration:
    const Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) {
      // Main slide in
      final slideTransition = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut));

      // Slight scale up
      final scaleTransition = Tween<double>(
        begin: 0.92,
        end: 1.0,
      ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOut));

      // Fade in
      final fadeTransition = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeIn));

      return FadeTransition(
        opacity: fadeTransition,
        child: SlideTransition(
          position: slideTransition,
          child: ScaleTransition(
            scale: scaleTransition,
            child: child,
          ),
        ),
      );
    },
  );
}