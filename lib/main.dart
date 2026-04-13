import 'package:flutter/material.dart';
import 'core/database/database_helper.dart';

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
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'OrdoGital',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Database loaded!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
