import 'dart:ui';

/// Original image dimensions: 660 x 1434
/// Now stored as **proportions**, so they adapt to any screen size!
final Map<String, Offset> jointPositionsMap = {
  "Right Shoulder": Offset(0.41, 0.43),
  "Left Shoulder": Offset(0.55, 0.43),
  "Right Elbow": Offset(0.31, 0.47),
  "Left Elbow": Offset(0.66, 0.47),
  "Right Wrist": Offset(0.24, 0.50),
  "Left Wrist": Offset(0.73, 0.50),
  "Right Hip": Offset(0.43, 0.54),
  "Left Hip": Offset(0.54, 0.54),
  "Right Knee": Offset(0.43, 0.62),
  "Left Knee": Offset(0.54, 0.62),
  "Right Ankle": Offset(0.43, 0.70),
  "Left Ankle": Offset(0.54, 0.70),
};