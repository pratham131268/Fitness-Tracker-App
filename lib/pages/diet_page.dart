import 'package:flutter/material.dart';
import 'package:fitness_tracker/providers/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  final dietController = TextEditingController();
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

  void addDiet() async {
    if (dietController.text.isNotEmpty && selectedTime != null) {
      final formattedTime = selectedTime!.format(context);
      await firestoreService.addDietItem(
        dietController.text.trim(),
        formattedTime,
      );

      dietController.clear();
      selectedTime = null;
    }
  }

  Widget buildDietCard(Map<String, dynamic> item, String docId) {
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
          const Icon(Icons.restaurant_menu, color: Colors.orangeAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              item['item'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(
            item['time'] ?? '',
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => firestoreService.deleteDietItem(docId),
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
                    controller: dietController,
                    decoration: const InputDecoration(
                      labelText: 'Diet Item',
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
                        onPressed: addDiet,
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Diet Plan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getDietItemsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Text('No diet items added.');
                }

                return Column(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return buildDietCard(data, doc.id);
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
