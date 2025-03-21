import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/joint_strength.dart';
import 'package:csv/csv.dart';

class ExportScreen extends StatelessWidget {
  final Map<String, JointStrength> jointStrengths;

  const ExportScreen({super.key, required this.jointStrengths});

  Future<void> _exportToCSV(BuildContext context) async {
    try {
      // ✅ Format Data for CSV
      List<List<String>> csvData = [
        ["Joint", "Flexion Strength", "Extension Strength"], // Header
      ];

      jointStrengths.forEach((joint, strength) {
        csvData.add([
          joint,
          strength.movement1.toString(),
          strength.movement2.toString(),
        ]);
      });

      // ✅ Convert Data to CSV String
      String csvString = const ListToCsvConverter().convert(csvData);

      // ✅ Get Directory to Save File
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/HYM_Score_Export.csv';

      // ✅ Save File
      final File file = File(filePath);
      await file.writeAsString(csvString);

      // ✅ Provide Share Option
      Share.shareXFiles([XFile(filePath)], text: "HYM Score Exported Data");

      // ✅ Notify User
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("CSV Exported to $filePath")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error exporting CSV: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Export Data")),
      body: Center(
        child: const Text(
          "No data to export.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}