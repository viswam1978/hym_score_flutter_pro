import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/subject_model.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  void _loadSubjects() {
    final box = Hive.box('subjects');
    setState(() {
      _subjects = box.values
          .map((e) => Subject.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    });
  }

  void _addSubject(String name) {
    final id = const Uuid().v4();
    final subject = Subject(id: id, name: name, createdAt: DateTime.now());
    final box = Hive.box('subjects');
    box.put(id, subject.toJson());
    _loadSubjects();
  }

  void _showAddDialog() {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Subject"),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: "Enter subject name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                _addSubject(_controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subjects")),
      body: ListView.builder(
        itemCount: _subjects.length,
        itemBuilder: (context, index) {
          final subject = _subjects[index];
          return ListTile(
            title: Text(subject.name),
            subtitle: Text(subject.createdAt.toIso8601String()),
            onTap: () {
              // TODO: Navigate to subject-specific HYM scoring screen
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}