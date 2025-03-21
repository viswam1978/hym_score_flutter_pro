import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/assessment.dart';
import 'comparison_screen.dart';

class AssessmentDetailScreen extends StatelessWidget {
  final Assessment assessment;

  const AssessmentDetailScreen({Key? key, required this.assessment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final jointData = assessment.jointStrengths;

    return Scaffold(
      appBar: AppBar(title: Text('Assessment Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Date: ${assessment.date.day}/${assessment.date.month}/${assessment.date.year}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...jointData.entries.map((entry) {
              final movementScores = entry.value;
              final movements = movementScores.entries.map((e) => '${e.key}: ${e.value}').join(', ');
              return ListTile(
                title: Text(entry.key),
                subtitle: Text(movements),
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final allAssessments = Hive.box<Assessment>('assessments')
                    .values
                    .where((a) => a.subjectId == assessment.subjectId && a != assessment)
                    .toList();

                if (allAssessments.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No other assessments available for comparison.')),
                  );
                  return;
                }

                final selected = await showDialog<Assessment>(
                  context: context,
                  builder: (_) => SimpleDialog(
                    title: Text('Select Assessment to Compare'),
                    children: allAssessments.map((a) {
                      final dateLabel = '${a.date.day}/${a.date.month}/${a.date.year}';
                      return SimpleDialogOption(
                        child: Text(dateLabel),
                        onPressed: () => Navigator.pop(context, a),
                      );
                    }).toList(),
                  ),
                );

                if (selected != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ComparisonScreen(
                        current: assessment,
                        comparison: selected,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Compare to Another'),
            ),
          ],
        ),
      ),
    );
  }
}