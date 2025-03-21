import 'package:hive/hive.dart';

part 'assessment.g.dart';

@HiveType(typeId: 1)
class Assessment extends HiveObject {
  @HiveField(0)
  String subjectId;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  Map<String, int> jointStrengths; // e.g., {"Left Knee Flexion": 4, "Right Elbow Extension": 5}

  @HiveField(3)
  int? gripStrength;

  Assessment({
    required this.subjectId,
    required this.date,
    required this.jointStrengths,
    this.gripStrength,
  });
}