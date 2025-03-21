import 'package:hive/hive.dart';

part 'patient.g.dart';

@HiveType(typeId: 0)
class Patient extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime dateOfBirth;

  Patient({
    required this.id,
    required this.name,
    required this.dateOfBirth,
  });
}