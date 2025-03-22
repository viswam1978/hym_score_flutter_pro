class Subject {
  final String id;
  final String name;
  final DateTime createdAt;

  Subject({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json['id'],
        name: json['name'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}
