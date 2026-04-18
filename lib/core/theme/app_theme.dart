import 'package:flutter/material.dart';
import 'liturgical_season.dart';

class LiturgicalTheme {
  static Color getPrimaryColor(LiturgicalSeason season) {
    switch (season) {
      case LiturgicalSeason.advent:
      case LiturgicalSeason.lent:
        return const Color(0xFF6B21A8); // Purple
      case LiturgicalSeason.christmas:
      case LiturgicalSeason.easter:
        return const Color(0xFFD4AF37); // Gold/White
      case LiturgicalSeason.pentecost:
        return const Color(0xFFDC2626); // Red
      case LiturgicalSeason.ordinaryTime:
        return const Color(0xFF15803D); // Green
    }
  }

  static Color getBackgroundColor(LiturgicalSeason season) {
    switch (season) {
      case LiturgicalSeason.advent:
      case LiturgicalSeason.lent:
        return const Color(0xFFF5F0FF); // Light purple
      case LiturgicalSeason.christmas:
      case LiturgicalSeason.easter:
        return const Color(0xFFFFFBEB); // Light gold
      case LiturgicalSeason.pentecost:
        return const Color(0xFFFFF1F1); // Light red
      case LiturgicalSeason.ordinaryTime:
        return const Color(0xFFF0FFF4); // Light green
    }
  }

  static Color getAccentColor(LiturgicalSeason season) {
    switch (season) {
      case LiturgicalSeason.advent:
      case LiturgicalSeason.lent:
        return const Color(0xFF9333EA);
      case LiturgicalSeason.christmas:
      case LiturgicalSeason.easter:
        return const Color(0xFFB8860B);
      case LiturgicalSeason.pentecost:
        return const Color(0xFFEF4444);
      case LiturgicalSeason.ordinaryTime:
        return const Color(0xFF16A34A);
    }
  }

  static String getSeasonEmoji(LiturgicalSeason season) {
    switch (season) {
      case LiturgicalSeason.advent:
        return '🕯️';
      case LiturgicalSeason.christmas:
        return '⭐';
      case LiturgicalSeason.lent:
        return '✝️';
      case LiturgicalSeason.easter:
        return '🌅';
      case LiturgicalSeason.pentecost:
        return '🔥';
      case LiturgicalSeason.ordinaryTime:
        return '🌿';
    }
  }

  static ThemeData getTheme(LiturgicalSeason season) {
    final primary = getPrimaryColor(season);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primary, primary: primary),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
