import 'package:flutter/material.dart';
import 'package:habit_tracking/helpers.dart';
import 'screens/auth/login.dart';

void main() async {
  await Helpers.initApp();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(32, 63, 129, 1.0),
        ),
      ),
      home: const Login(),
    );
  }
}
