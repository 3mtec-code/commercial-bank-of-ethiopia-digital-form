import 'package:flutter/material.dart';

class AppColors {
  // Theme Primary & Accents
  static const Color deepRoyalPurple = Color(0xFF1D0047);
  static const Color royalPurpleMedium = Color(0xFF2E0854);
  static const Color royalPurpleLight = Color(0xFF4A0E78);
  static const Color goldAccent = Color(0xFFFFB800);
  static const Color goldAccentLight = Color(0xFFFFD166);
  static const Color crispWhite = Color(0xFFFFFFFF);

  // Aliases for compatibility
  static const Color primary = deepRoyalPurple;
  static const Color primaryDark = Color(0xFF12002E);
  static const Color primaryLight = royalPurpleMedium;
  static const Color accent = goldAccent;
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentGreenLight = Color(0xFFD1FAE5);
  static const Color accentPurple = Color(0xFF6D28D9);
  static const Color accentPurpleLight = Color(0xFFEDE9FE);

  // Backgrounds
  static const Color background = deepRoyalPurple;
  static const Color backgroundGray = Color(0xFF0F0024);
  static const Color surfaceGray = Color(0xFF2A084E);

  // Glassmorphic Surface Colors
  static Color glassSurface = Colors.white.withValues(alpha: 0.08);
  static Color glassSurfaceHighlight = Colors.white.withValues(alpha: 0.15);
  static Color glassBorder = Colors.white.withValues(alpha: 0.18);
  static Color glassBorderHighlight = goldAccent.withValues(alpha: 0.4);

  // Text
  static const Color textPrimary = crispWhite;
  static const Color textSecondary = Color(0xFFD4C8E8);
  static const Color textMuted = Color(0xFF9E8DB8);
  static const Color textLight = Color(0xFFB8A9D4);
  static const Color textWhite = crispWhite;
  static const Color textDark = Color(0xFF111827);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF064E3B);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFF7F1D1D);
  static const Color warning = goldAccent;
  static const Color warningLight = Color(0xFF78350F);

  // Divider / Border
  static const Color border = Color(0x33FFFFFF);
  static const Color divider = Color(0x22FFFFFF);

  // Gradients
  static const LinearGradient purpleBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFF1D0047),
      Color(0xFF280259),
      Color(0xFF12002E),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGlassGradient = LinearGradient(
    colors: [
      Color(0x26FFFFFF), // 15% white
      Color(0x0DFFFFFF), // 5% white
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [
      Color(0xFFFFB800),
      Color(0xFFFFA000),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1D0047), Color(0xFF3B0764)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient depositGradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient withdrawGradient = LinearGradient(
    colors: [Color(0xFF9333EA), Color(0xFF7E22CE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
