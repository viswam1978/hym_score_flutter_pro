import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;

class ExportUtils {
  // ✅ Export CSV
  static Future<void> exportCSV(Map<String, (int, int)> jointStrengths) async {
    List<List<dynamic>> csvData = [
      ["Joint", "Movement 1", "Movement 2"], // ✅ Header row
    ];

    jointStrengths.forEach((joint, strengths) {
      csvData.add([joint, strengths.$1, strengths.$2]);
    });

    String csv = const ListToCsvConverter().convert(csvData);
    Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/muscle_strength.csv');
    await file.writeAsString(csv);

    debugPrint("✅ CSV exported: ${file.path}");
  }

  // ✅ Export PDF
  static Future<void> exportPDF(Map<String, (int, int)> jointStrengths) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Muscle Strength Report", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ["Joint", "Movement 1", "Movement 2"],
              data: jointStrengths.entries.map((e) => [e.key, e.value.$1, e.value.$2]).toList(),
            ),
          ],
        ),
      ),
    );

    Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/muscle_strength.pdf');
    await file.writeAsBytes(await pdf.save());

    debugPrint("✅ PDF exported: ${file.path}");
  }
}