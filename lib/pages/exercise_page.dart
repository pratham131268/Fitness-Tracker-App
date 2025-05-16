import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/providers/firestore_service.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final exerciseController = TextEditingController();
  final setsController = TextEditingController();
  final firestoreService = FirestoreService();

  void addExercise() async {
    if (exerciseController.text.isNotEmpty && setsController.text.isNotEmpty) {
      await firestoreService.addExercise(
        exerciseController.text.trim(),
        setsController.text.trim(),
      );

      exerciseController.clear();
      setsController.clear();
    }
  }

  Widget buildExerciseCard(Map<String, dynamic> data, String docId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orangeAccent.withAlpha((0.2 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.fitness_center, color: Colors.orangeAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              data['exercise'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(
            '${data['sets'] ?? ''} sets',
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => firestoreService.deleteExercise(docId),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orangeAccent.withAlpha((0.2 * 255).toInt()),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: exerciseController,
                    decoration: const InputDecoration(
                      labelText: 'Exercise Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: setsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'No. of Sets',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: addExercise,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Exercise'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            /// Today's Exercises
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Exercises",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getTodayExercisesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Text('No exercises added yet.');
                }

                return Column(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return buildExerciseCard(data, doc.id);
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 30),

            /// Weekly Report (optional future enhancement)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Weekly Report",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getWeeklyExercisesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Text('No report data.');
                }

                return Column(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return buildExerciseCard(data, doc.id);
                  }).toList(),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
