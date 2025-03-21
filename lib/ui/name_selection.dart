import 'package:flutter/material.dart';
import 'package:hym_score_flutter/ui/hym_score_home.dart';

class NameSelectionScreen extends StatefulWidget {
  const NameSelectionScreen({super.key});

  @override
  _NameSelectionScreenState createState() => _NameSelectionScreenState();
}

class _NameSelectionScreenState extends State<NameSelectionScreen> {
  final TextEditingController _nameController = TextEditingController();
  List<String> savedNames = ["John Doe", "Jane Smith"];  // ✅ Sample Data

  void addNewName() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        savedNames.add(_nameController.text);
        _nameController.clear();
      });
    }
  }

  void openNameProfile(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HYMScoreHome(name: name)), // ✅ Updated
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Name")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: savedNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(savedNames[index]),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => openNameProfile(savedNames[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Enter Name",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addNewName,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}