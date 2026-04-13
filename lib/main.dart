import 'package:flutter/material.dart';

void main() {
  runApp(const OrdoGitalApp());
}

class OrdoGitalApp extends StatelessWidget {
  const OrdoGitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrdoGital',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text('OrdoGital is running!'))),
    );
  }
}
