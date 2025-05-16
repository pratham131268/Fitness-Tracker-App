import 'package:flutter/material.dart';
import 'package:fitness_tracker/pages/login_page.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/get_started.png', height: 250),
            const SizedBox(height: 20),
            const Text(
              'Track Your Fitness\nAchieve Your Goals',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ));
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
