import 'dart:ui';

/// Original image dimensions: 660 x 1434
/// Now stored as **proportions**, so they adapt to any screen size!
final Map<String, Offset> jointPositionsMap = {
  "Right Shoulder": Offset(0.40, 0.44),
  "Left Shoulder": Offset(0.59, 0.44),
  "Right Elbow": Offset(0.31, 0.48),
  "Left Elbow": Offset(0.67, 0.48),
  "Right Wrist": Offset(0.26, 0.52),
  "Left Wrist": Offset(0.75, 0.52),
  "Right Hip": Offset(0.43, 0.55),
  "Left Hip": Offset(0.56, 0.55),
  "Right Knee": Offset(0.44, 0.64),
  "Left Knee": Offset(0.56, 0.64),
  "Right Ankle": Offset(0.44, 0.73),
  "Left Ankle": Offset(0.56, 0.73),
};