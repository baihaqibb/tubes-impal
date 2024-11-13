import 'package:flutter/material.dart';
import 'package:simple_cal/notifications/notification.dart';
import 'package:simple_cal/home.dart';
import 'package:simple_cal/themes.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: Themes.dark,
      debugShowCheckedModeBanner: false,
      title: 'SimpleCalendar :)',
      home: const HomePage(), //Change home to the desired page
    );
  }
}
