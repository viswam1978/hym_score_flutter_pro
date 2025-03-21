import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphView extends StatelessWidget {
  final Map<String, List<(int, int)>> strengthHistory;

  const GraphView({super.key, required this.strengthHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Strength Progress")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SfCartesianChart(
          title: ChartTitle(text: "Muscle Strength Over Time"),
          legend: Legend(isVisible: true),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(minimum: 0, maximum: 5, interval: 1),
          series: strengthHistory.entries.map((entry) {
            return LineSeries<_GraphData, String>(
              name: entry.key,
              dataSource: entry.value
                  .asMap()
                  .entries
                  .map((e) => _GraphData("Day ${e.key + 1}", (e.value.$1 + e.value.$2) / 2))
                  .toList(),
              xValueMapper: (data, _) => data.day,
              yValueMapper: (data, _) => data.strength,
              markerSettings: const MarkerSettings(isVisible: true),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _GraphData {
  final String day;
  final double strength;
  _GraphData(this.day, this.strength);
}