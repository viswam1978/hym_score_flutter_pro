import 'package:flutter/material.dart';

class JointMarker extends StatelessWidget {
  final Offset absolutePosition;
  final VoidCallback onTap;

  const JointMarker({
    required this.absolutePosition,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}