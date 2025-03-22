import 'package:flutter/material.dart';
import 'subject_list_screen.dart';

class MemojiHomeScreen extends StatelessWidget {
  const MemojiHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memoji Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SubjectListScreen(),
              ),
            );
          },
          child: const Text('Database'),
        ),
      ),
    );
  }
}