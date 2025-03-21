import 'package:hive/hive.dart';

part 'subject.g.dart';

@HiveType(typeId: 0)
class Subject extends HiveObject {
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