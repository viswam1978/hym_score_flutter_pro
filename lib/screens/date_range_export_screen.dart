import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/assessment.dart';

void exportPdf() async {
  if (startDate == null || endDate == null) return;

  final assessmentsBox = Hive.box<Assessment>('assessments');
  final filtered = assessmentsBox.values.where((a) {
    return a.subjectId != null &&
        a.date.isAfter(startDate!.subtract(Duration(days: 1))) &&
        a.date.isBefore(endDate!.add(Duration(days: 1)));
  }).toList();

  final pdf = pw.Document();
  
  pdf.addPage(pw.MultiPage(
    header: (context) => pw.Text('HYM Assessment Report', style: pw.TextStyle(fontSize: 16)),
    footer: (context) => pw.Text('Generated on ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
    build: (context) => [
      pw.Text('HYM Score Timeline Export', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 10),
      pw.Text('Subject: ${widget.subjectName.isNotEmpty ? widget.subjectName : 'Unknown'}'),
      pw.Text('From: ${DateFormat('yyyy-MM-dd').format(startDate!)}'),
      pw.Text('To: ${DateFormat('yyyy-MM-dd').format(endDate!)}'),
      pw.SizedBox(height: 20),
      ...filtered.map((a) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Date: ${DateFormat('yyyy-MM-dd').format(a.date)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ...a.jointStrengths.entries.expand((entry) {
                final joint = entry.key;
                return entry.value.entries.map((movement) {
                  return pw.Text('$joint - ${movement.key}: ${movement.value}');
                });
              }),
              pw.SizedBox(height: 12),
            ],
          )),
    ],
  ));

  await Printing.layoutPdf(onLayout: (format) => pdf.save());
}