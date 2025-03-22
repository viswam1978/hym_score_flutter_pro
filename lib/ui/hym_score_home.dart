import 'package:flutter/material.dart';
import '../models/subject_model.dart';

class HYMScoreHome extends StatelessWidget {
  final Subject subject;

  const HYMScoreHome({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
      ),
      body: Center(
        child: Text('Welcome to ${subject.name}'),
      ),
    );
  }
}