import 'dart:ui';
import 'package:flutter/material.dart';

/// Soft misty / smoky ambient color aura ("Smog Glow")
class SmogGlowBackground extends StatelessWidget {
  final Widget child;
  final Color primarySmog;
  final Color secondarySmog;

  const SmogGlowBackground({
    super.key,
    required this.child,
    this.primarySmog = const Color(0x1F2A084E),
    this.secondarySmog = const Color(0x15FFB800),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base ambient smoky diffusion
        Positioned(
          top: -60,
          right: -40,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primarySmog,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: -60,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  secondarySmog,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Frosted blur layer to smooth out the smoke
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: const SizedBox.shrink(),
        ),
        child,
      ],
    );
  }
}

/// Smoky ambient glow container for cards & buttons
class GlowingContainer extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double spreadRadius;
  final double blurRadius;
  final BorderRadiusGeometry? borderRadius;

  const GlowingContainer({
    super.key,
    required this.child,
    this.glowColor = const Color(0x221D0047),
    this.spreadRadius = 1,
    this.blurRadius = 16,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.14),
            spreadRadius: spreadRadius,
            blurRadius: blurRadius,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: glowColor.withValues(alpha: 0.06),
            spreadRadius: spreadRadius * 2,
            blurRadius: blurRadius * 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
