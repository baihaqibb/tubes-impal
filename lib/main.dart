import 'package:flutter/material.dart';
import 'package:simple_cal/pages/home_page.dart';
import 'package:simple_cal/pages/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: Themes.dark,
      debugShowCheckedModeBanner: false,
      title: 'SimpleCalendar :)',
      home: const HomePage(),
    );
  }
}
