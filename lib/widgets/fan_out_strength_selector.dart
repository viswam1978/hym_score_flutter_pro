import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FanOutStrengthSelector extends StatelessWidget {
  final String jointName;
  final (int, int) initialStrength;
  final Function(int, int) onStrengthSelected;

  const FanOutStrengthSelector({
    super.key,
    required this.jointName,
    required this.initialStrength,
    required this.onStrengthSelected,
  });

  @override
  Widget build(BuildContext context) {
    String movement1 = jointName.contains("Shoulder") ? "Abduction" : "Flexion";
    String movement2 = jointName.contains("Shoulder") ? "Adduction" : "Extension";

    return AlertDialog(
      title: Text("$jointName - Select Strength"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          strengthSelectionRow(movement1, initialStrength.$1, (value) {
            onStrengthSelected(value, initialStrength.$2);
            Navigator.pop(context);
          }),
          const SizedBox(height: 10),
          strengthSelectionRow(movement2, initialStrength.$2, (value) {
            onStrengthSelected(initialStrength.$1, value);
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  Widget strengthSelectionRow(String movementLabel, int selectedValue, Function(int) onSelected) {
    return Column(
      children: [
        Text(
          movementLabel,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                onSelected(index);
              },
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedValue == index ? Colors.blue : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "$index",
                  style: TextStyle(
                    color: selectedValue == index ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}