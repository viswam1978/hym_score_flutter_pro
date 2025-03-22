import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JointMarker extends StatelessWidget {
  final Offset absolutePosition;
  final VoidCallback onTap;
  final double size;
  final bool isSelected;

  const JointMarker({
    required this.absolutePosition,
    required this.onTap,
    this.size = 20,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        width: size + 12,
        height: size + 12,
        decoration: BoxDecoration(
          color: isSelected ? Colors.orangeAccent : Colors.red,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.deepOrange, blurRadius: 12, spreadRadius: 2)]
              : [],
        ),
      ),
    );
  }
}