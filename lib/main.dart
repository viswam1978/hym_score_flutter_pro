import 'package:flutter/material.dart';
import 'package:hym_score_flutter/ui/hym_score_home.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HYM Score',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HYMScoreHome(name: "Test Subject"), // ✅ Default name provided
    );
  }
}