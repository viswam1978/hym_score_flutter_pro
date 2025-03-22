import 'package:flutter/material.dart';
import 'package:hym_score_flutter_pro/models/StrengthRecord.dart';
import 'package:hym_score_flutter_pro/models/subject_model.dart';

class SubjectTimelineScreen extends StatelessWidget {
  final Subject subject;

  const SubjectTimelineScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final records = StrengthRecord.loadStrengthRecords(subject.id);

    return Scaffold(
      appBar: AppBar(title: Text('${subject.name} – Score History')),
      body: Column(
        children: [
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
                    final file = await StrengthRecord.exportToPDF(records, subject.name);
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
                    final file = await StrengthRecord.exportToCSV(records, subject.name);
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