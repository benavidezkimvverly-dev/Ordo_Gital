import 'package:flutter/material.dart';
import 'package:ordogital/core/database/database_helper.dart';
import 'package:ordogital/core/theme/app_theme.dart';
import 'package:ordogital/core/theme/liturgical_season.dart';
import 'package:ordogital/features/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const OrdoGitalApp());
}

class OrdoGitalApp extends StatelessWidget {
  const OrdoGitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    final season = LiturgicalCalendar.getCurrentSeason();
    final theme = LiturgicalTheme.getTheme(season);

    return MaterialApp(
      title: 'OrdoGital',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const LoginScreen(),
    );
  }
}
