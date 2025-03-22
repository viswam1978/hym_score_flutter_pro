class StrengthRecord {
  final DateTime timestamp;
  final Map<String, JointStrength> jointScores;

  StrengthRecord({
    required this.timestamp,
    required this.jointScores,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'jointScores': jointScores.map((key, value) => MapEntry(key, value.toJson())),
  };

  factory StrengthRecord.fromJson(Map<String, dynamic> json) => StrengthRecord(
    timestamp: DateTime.parse(json['timestamp']),
    jointScores: (json['jointScores'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, JointStrength.fromJson(Map<String, dynamic>.from(value))),
    ),
  );
}