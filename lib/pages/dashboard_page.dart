import 'package:flutter/material.dart';
import 'package:fitness_tracker/pages/daily_routine_page.dart';
import 'package:fitness_tracker/pages/exercise_page.dart';
import 'package:fitness_tracker/pages/diet_page.dart';
import 'package:fitness_tracker/pages/bmi_calculator_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  final tabs = [
    const DailyRoutinePage(),
    const ExercisePage(),
    const DietPage(),
    const BMICalculatorPage(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Animated Header
          SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const Center(
                child: Text(
                  'Fitness Tracker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: tabs[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.orangeAccent.withAlpha((0.2 * 255).toInt()),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.orangeAccent,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: 'Routine'),
            BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center), label: 'Exercise'),
            BottomNavigationBarItem(
                icon: Icon(Icons.fastfood), label: 'Diet'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calculate), label: 'BMI'),
          ],
        ),
      ),
    );
  }
}
