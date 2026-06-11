import 'package:flutter/material.dart';

/// Central design tokens for the Move With Us (MOVE.WITHUS) clone.
///
/// Palette pulled from the reference screenshots:
///  - sage/olive-green CTAs, black "selected" pills, cream pill input fields,
///    white/cream backgrounds, bold sans display headings, and the coloured
///    Tracking measurement labels.
class AppColors {
  AppColors._();

  // Brand / CTAs
  static const Color sage = Color(0xFFB4C29A); // primary CTA (CONTINUE, etc.)
  static const Color sageDeep = Color(0xFFA7B88C); // pressed / accent
  static const Color sageLight = Color(0xFFD7DDC7); // secondary CTA / disabled
  static const Color sagePill = Color(0xFFCAD4B2); // selected toggle / meal tag
  static const Color sageTrack = Color(0xFFB9C79E); // ring + slider fill

  // Neutrals
  static const Color black = Color(0xFF111111);
  static const Color ink = Color(0xFF1A1A1A);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF8A8A85);
  static const Color textMuted = Color(0xFFA9A9A3);

  // Surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color cream = Color(0xFFF4F2EA); // page tint on some screens
  static const Color field = Color(0xFFECEAE0); // pill input fields
  static const Color card = Color(0xFFF6F5EF);
  static const Color border = Color(0xFFE6E4DA);
  static const Color divider = Color(0xFFEDECE4);

  // iOS system
  static const Color iosBlue = Color(0xFF0A84FF);
  static const Color sheetGrey = Color(0xFFF2F2F2);

  // Tracking measurement labels
  static const Color chest = Color(0xFF2BA9A0);
  static const Color waist = Color(0xFF7B5EA7);
  static const Color hips = Color(0xFF3B7DD8);
  static const Color arm = Color(0xFFC2407E);
  static const Color thigh = Color(0xFFE08A3C);
  static const Color weight = Color(0xFF6B8E4E);

  // Macro ring (all share sage track in app)
  static const Color ringTrack = Color(0xFFEDEBE3);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.sage,
        secondary: AppColors.sageDeep,
        surface: AppColors.background,
      ),
      splashFactory: InkRipple.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
    );
  }
}

/// Shared text styles used across screens.
class AppText {
  AppText._();

  static const TextStyle display = TextStyle(
    fontSize: 34,
    height: 1.05,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontSize: 15,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: AppColors.textPrimary,
  );
}
