import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HYM Score Help")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "MRC Muscle Strength Grading Scale",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildMrcTable(),
            const SizedBox(height: 20),
            const Text(
              "How to Use the HYM Score App:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "1️⃣ Tap on a joint marker to select muscle strength.\n"
              "2️⃣ Choose strength values from 0-5 for each movement.\n"
              "3️⃣ The HYM Score updates automatically based on your inputs.\n"
              "4️⃣ You can view graphs, export data, and save evaluations.\n",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ MRC Score Table
  Widget _buildMrcTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text("MRC Grade", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Description", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Muscle Strength", style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: const [
          DataRow(cells: [
            DataCell(Text("0")),
            DataCell(Text("No contraction")),
            DataCell(Text("Zero")),
          ]),
          DataRow(cells: [
            DataCell(Text("1")),
            DataCell(Text("Trace of contraction")),
            DataCell(Text("Trace")),
          ]),
          DataRow(cells: [
            DataCell(Text("2")),
            DataCell(Text("Active movement, gravity eliminated")),
            DataCell(Text("Poor")),
          ]),
          DataRow(cells: [
            DataCell(Text("3")),
            DataCell(Text("Active movement, against gravity")),
            DataCell(Text("Fair")),
          ]),
          DataRow(cells: [
            DataCell(Text("4")),
            DataCell(Text("Active movement, against gravity and some resistance")),
            DataCell(Text("Good")),
          ]),
          DataRow(cells: [
            DataCell(Text("5")),
            DataCell(Text("Active movement, against gravity and full resistance")),
            DataCell(Text("Normal")),
          ]),
        ],
      ),
    );
  }
}