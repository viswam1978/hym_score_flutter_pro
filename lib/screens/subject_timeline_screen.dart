import 'package:flutter/material.dart';
import 'package:hym_score_flutter_pro/models/subject_model.dart';
import 'subject_timeline_screen.dart';
import '../widgets/score_chart.dart';
import '../models/StrengthRecord.dart';

class SubjectListScreen extends StatelessWidget {
  final List<Subject> subjects;

  const SubjectListScreen({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subjects')),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return ListTile(
            title: Text(subject.name),
            subtitle: Text(subject.createdAt.toIso8601String()),
            trailing: IconButton(
              icon: Icon(Icons.history),
              tooltip: 'View Score History',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubjectTimelineScreen(subject: subject),
                  ),
                );
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HYMScoreHome(subject: subject),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SubjectTimelineScreen extends StatefulWidget {
  final Subject subject;

  const SubjectTimelineScreen({super.key, required this.subject});

  @override
  State<SubjectTimelineScreen> createState() => _SubjectTimelineScreenState();
}

class _SubjectTimelineScreenState extends State<SubjectTimelineScreen> {
  String selectedFilter = 'Total Score';

  @override
  Widget build(BuildContext context) {
    final records = StrengthRecord.loadStrengthRecords(widget.subject.id);
    final joints = {
      for (var r in records)
        ...r.jointScores.keys.map((k) => k)
    }.toSet().toList();

    final filterOptions = ['Total Score', ...joints];

    return Scaffold(
      appBar: AppBar(title: Text('${widget.subject.name} – Score History')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedFilter = value;
                  });
                }
              },
              items: filterOptions.map((label) => DropdownMenuItem(
                value: label,
                child: Text(label),
              )).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ScoreChart(records: records, filter: selectedFilter),
          ),
          Expanded(child: StrengthRecord.buildTimeline(records)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Export PDF"),
                  onPressed: () async {
                    final file = await StrengthRecord.exportToPDF(records, widget.subject.name);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("PDF saved to ${file.path}")),
                    );
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.table_chart),
                  label: const Text("Export CSV"),
                  onPressed: () async {
                    final file = await StrengthRecord.exportToCSV(records, widget.subject.name);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("CSV saved to ${file.path}")),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}