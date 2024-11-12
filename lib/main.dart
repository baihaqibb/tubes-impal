import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Tema terang//
      darkTheme: ThemeData.dark(), // Tema gelap
      themeMode: ThemeMode.system, // Mengatur tema sesuai dengan pengaturan sistem
      home: const LoginPage(),
    );
  }
}