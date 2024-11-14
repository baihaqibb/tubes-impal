import 'package:flutter/material.dart';
import 'package:simple_cal/notifications/notification.dart';
import 'package:simple_cal/pages/edit_page.dart';
import 'package:simple_cal/pages/input_page.dart';
import 'package:simple_cal/pages/home_page.dart';
import 'package:simple_cal/themes.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: GlobalThemeData.lightThemeData,
      darkTheme: GlobalThemeData.darkThemeData,
      debugShowCheckedModeBanner: false,
      title: 'SimpleCalendar :)',
      home: const HomePage(),
    );
  }
}
