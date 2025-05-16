import 'package:flutter/material.dart';
import 'package:fitness_tracker/providers/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyRoutinePage extends StatefulWidget {
  const DailyRoutinePage({super.key});

  @override
  State<DailyRoutinePage> createState() => _DailyRoutinePageState();
}

class _DailyRoutinePageState extends State<DailyRoutinePage> {
  final routineController = TextEditingController();
  TimeOfDay? selectedTime;

  final firestoreService = FirestoreService();

  void pickTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  void addRoutine() async {
    if (routineController.text.isNotEmpty && selectedTime != null) {
      final formattedTime = selectedTime!.format(context);
      await firestoreService.addRoutine(
        routineController.text.trim(),
        formattedTime,
      );

      routineController.clear();
      selectedTime = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
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
                    controller: routineController,
                    decoration: const InputDecoration(
                      labelText: 'Add Daily Task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.access_time),
                          label: Text(selectedTime == null
                              ? 'Pick Time'
                              : selectedTime!.format(context)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                          ),
                          onPressed: pickTime,
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: addRoutine,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getRoutinesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No tasks added yet.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  final routines = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: routines.length,
                    itemBuilder: (context, index) {
                      final doc = routines[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
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
                        child: ListTile(
                          leading: const Icon(Icons.check_circle_outline,
                              color: Colors.orangeAccent),
                          title: Text(
                            data['task'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Time: ${data['time'] ?? ''}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => firestoreService.deleteRoutine(doc.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
