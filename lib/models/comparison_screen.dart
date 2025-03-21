import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/assessment.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

class ComparisonScreen extends StatelessWidget {
  final Assessment current;
  final Assessment comparison;
  final GlobalKey chartKey = GlobalKey();

  const ComparisonScreen({
    super.key,
    required this.current,
    required this.comparison,
  });

  int calculateTotal(Map<String, Map<String, int>> scores) {
    return scores.values.fold(0, (total, joint) =>
        total + joint.values.fold(0, (sum, score) => sum + score));
  }

  void exportToPdf(BuildContext context) async {
    final pdf = pw.Document();

    final currentTotal = calculateTotal(current.jointStrengths);
    final previousTotal = calculateTotal(comparison.jointStrengths);
    final diff = currentTotal - previousTotal;

    RenderRepaintBoundary boundary = chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final imageBytes = byteData!.buffer.asUint8List();

    final chartImage = pw.MemoryImage(imageBytes);

    final now = DateTime.now();
    final pdfFileName = 'HYM_Comparison_${now.toIso8601String().split('T').first}.pdf';

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('HYM Score Comparison Report', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Assessment 1: ${comparison.date.toLocal().toIso8601String().split("T").first}'),
            pw.Text('Assessment 2: ${current.date.toLocal().toIso8601String().split("T").first}'),
            pw.SizedBox(height: 10),
            pw.Text('Total Score: $currentTotal vs $previousTotal (Difference: ${diff >= 0 ? '+' : ''}$diff)'),
            pw.SizedBox(height: 10),
            pw.Image(chartImage),
            pw.SizedBox(height: 10),
            ...current.jointStrengths.keys.map((joint) {
              final currScores = current.jointStrengths[joint] ?? {};
              final compScores = comparison.jointStrengths[joint] ?? {};
              final allMovements = {...currScores.keys, ...compScores.keys};
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(joint, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ...allMovements.map((movement) {
                    final c = currScores[movement] ?? 0;
                    final p = compScores[movement] ?? 0;
                    final d = c - p;
                    return pw.Text('$movement: $c vs $p (${d >= 0 ? '+' : ''}$d)');
                  }),
                  pw.SizedBox(height: 6),
                ],
              );
            }),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$pdfFileName');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)], text: 'Assessment Comparison PDF');
  }

  void exportToCsv(BuildContext context) async {
    final now = DateTime.now();
    final fileName = 'HYM_Comparison_${now.toIso8601String().split('T').first}.csv';

    List<List<dynamic>> rows = [
      ['HYM Score Comparison'],
      ['Assessment 1', comparison.date.toIso8601String().split("T").first],
      ['Assessment 2', current.date.toIso8601String().split("T").first],
      [],
      ['Joint', 'Movement', 'Current', 'Comparison', 'Difference'],
    ];

    current.jointStrengths.forEach((joint, currScores) {
      final compScores = comparison.jointStrengths[joint] ?? {};
      final allMovements = {...currScores.keys, ...compScores.keys};

      for (var movement in allMovements) {
        final c = currScores[movement] ?? 0;
        final p = compScores[movement] ?? 0;
        final d = c - p;
        rows.add([joint, movement, c, p, d]);
      }
    });

    String csvData = const ListToCsvConverter().convert(rows);
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/$fileName';
    final file = File(path);
    await file.writeAsString(csvData);

    await Share.shareXFiles([XFile(path)], text: 'Assessment Comparison CSV');
  }

  @override
  Widget build(BuildContext context) {
    final currentTotal = calculateTotal(current.jointStrengths);
    final previousTotal = calculateTotal(comparison.jointStrengths);
    final diff = currentTotal - previousTotal;

    final joints = current.jointStrengths.keys.toSet()
      ..addAll(comparison.jointStrengths.keys);

    final barData = joints.map((joint) {
      final currentJoint = current.jointStrengths[joint] ?? {};
      final compareJoint = comparison.jointStrengths[joint] ?? {};

      int currentSum = currentJoint.values.fold(0, (a, b) => a + b);
      int compareSum = compareJoint.values.fold(0, (a, b) => a + b);
      return MapEntry(joint, currentSum - compareSum);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Assessment Comparison')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Score: $currentTotal vs $previousTotal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: diff > 0 ? Colors.green : diff < 0 ? Colors.red : Colors.grey,
              )),
            const SizedBox(height: 20),
            Text('Joint Differences:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            RepaintBoundary(
              key: chartKey,
              child: SizedBox(height: 200, child: _BarChart(barData: barData)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: joints.map((joint) {
                  final currentScores = current.jointStrengths[joint] ?? {};
                  final compareScores = comparison.jointStrengths[joint] ?? {};
                  final movements = currentScores.keys.toSet()
                    ..addAll(compareScores.keys);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(joint, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ...movements.map((movement) {
                        final curr = currentScores[movement] ?? 0;
                        final prev = compareScores[movement] ?? 0;
                        final d = curr - prev;
                        Color color = d > 0
                            ? Colors.green
                            : d < 0
                                ? Colors.red
                                : Colors.grey;
                        final diffText = d == 0 ? '' : ' (${d > 0 ? '+' : ''}$d)';

                        return Text('$movement: $curr vs $prev$diffText', style: TextStyle(color: color));
                      }),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => exportToPdf(context),
                  icon: Icon(Icons.picture_as_pdf),
                  label: Text('Export PDF'),
                ),
                ElevatedButton.icon(
                  onPressed: () => exportToCsv(context),
                  icon: Icon(Icons.table_chart),
                  label: Text('Export CSV'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<MapEntry<String, int>> barData;

  const _BarChart({super.key, required this.barData});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: barData.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value.toDouble(),
                color: value >= 0 ? Colors.green : Colors.red,
                width: 16,
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < barData.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      barData[index].key.split(' ').first,
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}