import 'package:flutter/material.dart';

class DatabaseScreen extends StatelessWidget {
  final String name;

  const DatabaseScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database Screen'),
      ),
      body: Center(
        child: Text('Name: $name'),
      ),
    );
  }
}