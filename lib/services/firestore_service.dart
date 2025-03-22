import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subject_model.dart';
import 'package:hive/hive.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadSubject(String userId, Subject subject) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('subjects')
        .doc(subject.id);

    await docRef.set({
      'id': subject.id,
      'name': subject.name,
      'createdAt': subject.createdAt.toIso8601String(),
    });
  }

  Future<List<Subject>> fetchSubjects(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('subjects')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Subject(
        id: data['id'],
        name: data['name'],
        createdAt: DateTime.parse(data['createdAt']),
      );
    }).toList();
  }

  Future<void> syncSubjectsWithHive(String userId) async {
    final hiveBox = Hive.box('subjects');
    final remoteSubjects = await fetchSubjects(userId);

    // Clear and replace local Hive data with remote data
    await hiveBox.clear();
    for (var subject in remoteSubjects) {
      hiveBox.put(subject.id, subject);
    }

    // Optionally upload any local-only subjects
    for (var subject in hiveBox.values.cast<Subject>()) {
      await uploadSubject(userId, subject);
    }
  }
}
