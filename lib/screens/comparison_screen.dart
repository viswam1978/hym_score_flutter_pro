import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/subject.dart';
import 'subject_timeline_screen.dart';
import 'new_assessment_screen.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  late Box<Subject> subjectBox;

  @override
  void initState() {
    super.initState();
    subjectBox = Hive.box<Subject>('subjects');
  }

  void _addSubject() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add New Subject'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter subject name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Add')),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      final newSubject = Subject(name: result.trim(), createdAt: DateTime.now());
      await subjectBox.add(newSubject);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjects = subjectBox.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Subjects')),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return ListTile(
            title: Text(subject.name),
            subtitle: Text('Created: ${subject.createdAt.toLocal().toIso8601String().split('T').first}'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SubjectTimelineScreen(subject: subject),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewAssessmentScreen(subject: subject),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}