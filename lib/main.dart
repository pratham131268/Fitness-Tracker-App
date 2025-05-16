import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:fitness_tracker/pages/get_started_page.dart';
import 'package:fitness_tracker/firebase_options.dart';
import 'package:fitness_tracker/providers/auth_service.dart';
import 'package:fitness_tracker/providers/user_data_provider.dart'; // <-- import this

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<UserDataProvider>(create: (_) => UserDataProvider()), // <-- add this
      ],
      child: MaterialApp(
        title: 'Fitness Tracker',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        debugShowCheckedModeBanner: false,
        home: const GetStartedPage(),
      ),
    );
  }
}
