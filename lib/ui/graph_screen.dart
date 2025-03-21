import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/joint_strength.dart';

class GraphScreen extends StatelessWidget {
  final Map<String, JointStrength> jointStrengths;

  const GraphScreen({super.key, required this.jointStrengths});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("HYM Score - Strength Graph"),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Coming Soon"),
                    content: const Text("This feature will be available in the Pro version."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Muscle Strength Distribution",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 200)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return BarChart(
                    BarChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          axisNameWidget: const Text("Strength", style: TextStyle(fontSize: 12)),
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          axisNameWidget: const Text("Joints", style: TextStyle(fontSize: 12)),
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              List<String> joints = jointStrengths.keys.toList();
                              String label = joints[value.toInt()].substring(0, 3);
                              return Transform.rotate(
                                angle: -1.5708,
                                child: Text(
                                  label,
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      barGroups: _generateBarGroups(jointStrengths),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(Map<String, JointStrength> strengths) {
    List<BarChartGroupData> groups = [];
    int index = 0;
    strengths.forEach((joint, strength) {
      groups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: strength.movement1.toDouble(),
              width: 12,
              color: Colors.blue,
              borderRadius: BorderRadius.zero,
            ),
            BarChartRodData(
              toY: strength.movement2.toDouble(),
              width: 12,
              color: Colors.green,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      );
      index++;
    });
    return groups;
  }
}