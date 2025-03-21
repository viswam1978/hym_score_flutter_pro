// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssessmentAdapter extends TypeAdapter<Assessment> {
  @override
  final int typeId = 1;

  @override
  Assessment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Assessment(
      subjectId: fields[0] as String,
      date: fields[1] as DateTime,
      jointStrengths: (fields[2] as Map).cast<String, int>(),
      gripStrength: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Assessment obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.subjectId)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.jointStrengths)
      ..writeByte(3)
      ..write(obj.gripStrength);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
