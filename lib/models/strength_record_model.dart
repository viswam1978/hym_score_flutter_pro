import 'package:hive/hive.dart';
import 'joint_strength.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';

class StrengthRecord {
  final DateTime timestamp;
  final Map<String, JointStrength> jointScores;

  StrengthRecord({
    required this.timestamp,
    required this.jointScores,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'jointScores': jointScores.map((key, value) => MapEntry(key, value.toJson())),
      };

  factory StrengthRecord.fromJson(Map<String, dynamic> json) => StrengthRecord(
        timestamp: DateTime.parse(json['timestamp']),
        jointScores: (json['jointScores'] as Map<String, dynamic>).map(
          (key, value) =>
              MapEntry(key, JointStrength.fromJson(Map<String, dynamic>.from(value))),
        ),
      );

  static void saveStrengthRecord(String subjectId, Map<String, JointStrength> jointStrengths) {
    final record = StrengthRecord(
      timestamp: DateTime.now(),
      jointScores: Map<String, JointStrength>.from(jointStrengths),
    );

    final box = Hive.box('subject_scores');
    List existingRecords = box.get(subjectId, defaultValue: []);
    existingRecords.add(record.toJson());
    box.put(subjectId, existingRecords);
  }

  static List<StrengthRecord> loadStrengthRecords(String subjectId) {
    final box = Hive.box('subject_scores');
    final rawList = box.get(subjectId, defaultValue: []);
    return (rawList as List)
        .map((e) => StrengthRecord.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Widget buildTimeline(List<StrengthRecord> records) {
    records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              'Assessment on ${DateFormat.yMMMd().add_jm().format(record.timestamp)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Total Joints: ${record.jointScores.length}'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(
                    'Details for ${DateFormat.yMMMd().add_jm().format(record.timestamp)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: ListView(
                      shrinkWrap: true,
                      children: record.jointScores.entries.map((entry) {
                        return ListTile(
                          title: Text(entry.key),
                          subtitle: Text('Flexion: ${entry.value.movement1}, Extension: ${entry.value.movement2}'),
                        );
                      }).toList(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  static Future<File> exportToCSV(List<StrengthRecord> records, String subjectName) async {
    final List<List<String>> csvData = [
      ['Timestamp', 'Joint', 'Flexion', 'Extension']
    ];

    for (final record in records) {
      record.jointScores.forEach((joint, strength) {
        csvData.add([
          record.timestamp.toIso8601String(),
          joint,
          strength.movement1.toString(),
          strength.movement2.toString(),
        ]);
      });
    }

    final csv = const ListToCsvConverter().convert(csvData);
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${subjectName}_records.csv';
    final file = File(path);
    return file.writeAsString(csv);
  }

  static Future<File> exportToPDF(List<StrengthRecord> records, String subjectName) async {
    final pdf = pw.Document();

    for (final record in records) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Assessment on ${record.timestamp}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                ...record.jointScores.entries.map((entry) {
                  return pw.Text(
                    '${entry.key}: Flexion - ${entry.value.movement1}, Extension - ${entry.value.movement2}',
                  );
                }).toList(),
                pw.Divider(),
              ],
            );
          },
        ),
      );
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${subjectName}_records.pdf';
    final file = File(path);
    return file.writeAsBytes(await pdf.save());
  }
}
