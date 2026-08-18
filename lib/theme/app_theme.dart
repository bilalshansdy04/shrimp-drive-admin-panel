import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFFB4A3);
  static const Color primaryContainer = Color(0xFFFF6B4A);
  static const Color onPrimaryContainer = Color(0xFF661000);
  
  static const Color secondary = Color(0xFF4FDF94);
  static const Color secondaryContainer = Color(0xFF00B26C);
  
  static const Color tertiary = Color(0xFF56D9D8);
  static const Color tertiaryContainer = Color(0xFF03ACAB);
  
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  
  static const Color surface = Color(0xFF10131A);
  static const Color surfaceContainer = Color(0xFF1D2026);
  static const Color surfaceContainerHigh = Color(0xFF272A31);
  static const Color surfaceContainerHighest = Color(0xFF32353C);
  
  static const Color onSurface = Color(0xFFE1E2EB);
  static const Color onSurfaceVariant = Color(0xFFE1BFB8);
  
  static const Color outline = Color(0xFF59413C);
  static const Color outlineVariant = Color(0xFF59413C);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.surface,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryContainer,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryContainer,
        tertiary: AppColors.tertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        surface: AppColors.surface,
        error: AppColors.error,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
      ),
      dividerColor: AppColors.outline,
    );
  }
}
