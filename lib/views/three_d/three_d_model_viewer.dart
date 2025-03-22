import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ThreeDModelViewer extends StatelessWidget {
  const ThreeDModelViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("3D Body Viewer")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          // Marker positions as percentages of width and height
          final joints = {
            'rightShoulder': Offset(0.37, 0.29),
            'leftShoulder': Offset(0.60, 0.29),
            'rightElbow': Offset(0.30, 0.40),
            'leftElbow': Offset(0.68, 0.40),
            'rightWrist': Offset(0.25, 0.52),
            'leftWrist': Offset(0.74, 0.52),
            'rightHip': Offset(0.44, 0.58),
            'leftHip': Offset(0.54, 0.58),
            'rightKnee': Offset(0.44, 0.75),
            'leftKnee': Offset(0.54, 0.75),
            'rightAnkle': Offset(0.44, 0.90),
            'leftAnkle': Offset(0.54, 0.90),
          };

          return Stack(
            children: [
              const ModelViewer(
                src: 'assets/body.memoji.glb',
                alt: "3D Memoji Body",
                autoRotate: true,
                cameraControls: true,
                ar: false,
                backgroundColor: Colors.white,
              ),
              ...joints.entries.map((entry) {
                final dx = entry.value.dx * width;
                final dy = entry.value.dy * height;
                return Positioned(
                  left: dx - 6,
                  top: dy - 6,
                  child: Tooltip(
                    message: entry.key,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}