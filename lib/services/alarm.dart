/*
import 'package:alarm/alarm.dart';

class AlarmService {
  static Future<void> init() async {
    Alarm.init();
  }

  static void setAlarm(
      {required int id,
      required String title,
      required String body,
      required DateTime dateTime}) {
    Alarm.set(
        alarmSettings: AlarmSettings(
            id: id,
            dateTime: dateTime,
            assetAudioPath: 'assets/alarm.mp3',
            notificationSettings: NotificationSettings(
                title: title, body: body, stopButton: "Stop Alarm")));
  }

  static Future<void> stopAlarm(int id) async {
    await Alarm.stop(id);
  }
}
*/