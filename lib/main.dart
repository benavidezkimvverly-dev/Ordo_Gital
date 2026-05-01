import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ordogital/core/database/database_helper.dart';
import 'package:ordogital/core/theme/app_theme.dart';
import 'package:ordogital/core/theme/liturgical_season.dart';
import 'package:ordogital/features/auth/auth_repository.dart';
import 'package:ordogital/features/auth/login_screen.dart';
import 'package:ordogital/features/auth/welcome_screen.dart';
import 'package:ordogital/features/dashboard/ministry/ministry_dashboard.dart';
import 'package:ordogital/features/dashboard/parishioner/parishioner_dashboard.dart';
import 'package:ordogital/shared/models/user_model.dart';
import 'package:ordogital/firebase_options.dart';
import 'package:ordogital/features/admin/admin_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // SQLite — mobile lang, hindi web
  if (!kIsWeb) {
    await DatabaseHelper.instance.database;
  }

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
      home: kIsWeb ? const AdminLoginScreen() : const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 2));

    final authRepo = AuthRepository();
    final UserModel? user = await authRepo.getSession();

    if (!mounted) return;

    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return;
    }

    if (user.role == 'parishioner') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ParishionerDashboard(user: user),
        ),
      );
    } else if (user.role == 'ministry') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MinistryDashboard(user: user)),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final season = LiturgicalCalendar.getCurrentSeason();
    final primary = LiturgicalTheme.getPrimaryColor(season);
    final background = LiturgicalTheme.getBackgroundColor(season);
    final seasonEmoji = LiturgicalTheme.getSeasonEmoji(season);
    final seasonName = LiturgicalCalendar.getSeasonName(season);

    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(Icons.church, color: Colors.white, size: 56),
            ),
            const SizedBox(height: 24),
            Text(
              'OrdoGital',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Parish Digital Companion',
              style: TextStyle(
                fontSize: 14,
                color: primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '$seasonEmoji $seasonName',
              style: TextStyle(
                fontSize: 16,
                color: primary.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(color: primary, strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}
