import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get userId => FirebaseAuth.instance.currentUser?.uid ?? 'unknown';

  // Add a daily routine task
  Future<void> addRoutine(String task, String time) async {
    await _db.collection('users').doc(userId).collection('routines').add({
      'task': task,
      'time': time,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get today's routines stream
  Stream<QuerySnapshot> getTodayRoutinesStream() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return _db
        .collection('users')
        .doc(userId)
        .collection('routines')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .orderBy('timestamp')
        .snapshots();
  }

  // Alias for convenience
  Stream<QuerySnapshot> getRoutinesStream() => getTodayRoutinesStream();

  // Delete a routine
  Future<void> deleteRoutine(String docId) async {
    await deleteDocument('routines', docId);
  }

  // Add a diet item
  Future<void> addDietItem(String item, String time) async {
    await _db.collection('users').doc(userId).collection('diet').add({
      'item': item,
      'time': time,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get today's diet items
  Stream<QuerySnapshot> getTodayDietStream() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return _db
        .collection('users')
        .doc(userId)
        .collection('diet')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .orderBy('timestamp')
        .snapshots();
  }

  // Alias for convenience
  Stream<QuerySnapshot> getDietItemsStream() => getTodayDietStream();

  // Delete a diet item
  Future<void> deleteDietItem(String docId) async {
    await deleteDocument('diet', docId);
  }

  // Add an exercise entry
  Future<void> addExercise(String name, String sets) async {
    await _db.collection('users').doc(userId).collection('exercises').add({
      'exercise': name,
      'sets': sets,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get today's exercises
  Stream<QuerySnapshot> getTodayExercisesStream() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return _db
        .collection('users')
        .doc(userId)
        .collection('exercises')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .orderBy('timestamp')
        .snapshots();
  }

  // Get weekly exercise report
  Stream<QuerySnapshot> getWeeklyExercisesStream() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    return _db
        .collection('users')
        .doc(userId)
        .collection('exercises')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .orderBy('timestamp')
        .snapshots();
  }

  // Delete an exercise
  Future<void> deleteExercise(String docId) async {
    await deleteDocument('exercises', docId);
  }

  // Generic document delete method
  Future<void> deleteDocument(String collection, String docId) async {
    await _db.collection('users').doc(userId).collection(collection).doc(docId).delete();
  }
}
