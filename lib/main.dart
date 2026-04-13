import 'package:flutter/material.dart';
import 'core/database/database_helper.dart';
import 'features/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const OrdoGitalApp());
}

class OrdoGitalApp extends StatelessWidget {
  const OrdoGitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrdoGital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
