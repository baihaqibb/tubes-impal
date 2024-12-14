//import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:simple_cal/firebase_options.dart';
import 'package:simple_cal/services/notification.dart';
import 'package:simple_cal/pages/auth_page.dart';
//import 'package:simple_cal/pages/login_page.dart';
//import 'package:simple_cal/pages/register_page.dart';
//import 'package:simple_cal/pages/edit_page.dart';
//import 'package:simple_cal/pages/input_page.dart';
//import 'package:simple_cal/pages/home_page.dart';
import 'package:simple_cal/themes.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
//  await AlarmService.init();
  tz.initializeTimeZones();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: const AuthPage(),
    );
  }
}
