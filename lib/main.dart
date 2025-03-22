import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/hym_score_home.dart'; // ✅ Correct (relative path)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HYM Score Pro',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Colors.white,
        ),
      home: const HYMScoreHome(name: "Test Subject"), // ✅ Default name provided
    );
  }
}