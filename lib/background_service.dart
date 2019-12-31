import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import 'package:path_provider/path_provider.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:alarmy/alarm_model.dart';
import 'package:alarmy/alarms_database.dart';
import 'package:alarmy/screens/alarms_screen.dart';
import 'package:alarmy/screens/alarm_time_screen.dart';

class BackgroundService {
  static Duration firstRun = Duration(days: 8);
  static AlarmModel firstAlarm;
  static AudioPlayer audioPlayer = AudioPlayer();
  static DateTime nextAlarmDateTime;

  static Future<void> scheduleAlarm() async {
    firstAlarm = await checkNextAlarm();
    if (firstAlarm != null) {
      Future.delayed(firstRun).then((v) async {
        await audioPlayer.play(firstAlarm.audioPath, isLocal: true);
        AppAvailability.launchApp("com.mahmoud.alarmy").then((v) {
          print("AppAvailability");
          Navigator.pushReplacement(AlarmsScreen.alarmsScreenContext,
              MaterialPageRoute(builder: (c) => AlarmTimeScreen(firstAlarm)));
        });
      });
//      print("local Notification");
//      var scheduledNotificationDateTime = nextAlarmDateTime;
//      var vibrationPattern = Int64List(4);
//      vibrationPattern[0] = 0;
//      vibrationPattern[1] = 1000;
//      vibrationPattern[2] = 5000;
//      vibrationPattern[3] = 2000;
//      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//        'channel-id',
//        'channel-name',
//        'channel-description',
//        importance: Importance.Max,
//        priority: Priority.Max,
//        playSound: false,
//        enableVibration: true,
//        vibrationPattern: vibrationPattern,
//      );
//      var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//      NotificationDetails platformChannelSpecifics = NotificationDetails(
//          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//      await flutterLocalNotificationsPlugin.schedule(
//        firstAlarm.id,
//        firstAlarm.label,
//        "Alarm App",
//        scheduledNotificationDateTime,
//        platformChannelSpecifics,
//        androidAllowWhileIdle: true,
//      );
    }
  }

  static Future<AlarmModel> checkNextAlarm() async {
    AlarmModel nextAlarm;
    List<AlarmModel> _alarms = await fetchDateBaseAlarms();
    for (var alarm in _alarms) {
      DateTime alarmTime = DateTime.parse(alarm.alarm);
      for (int alarmDay in alarm.alarmTimes) {
        if (alarmTime.add(Duration(days: alarmDay)).isAfter(DateTime.now())) {
          if (firstRun >
              alarmTime
                  .add(Duration(days: alarmDay))
                  .difference(DateTime.now())) {
            if (alarm.active == 1) {
              firstRun = alarmTime
                  .add(Duration(days: alarmDay))
                  .difference(DateTime.now());
              nextAlarm = alarm;
              nextAlarmDateTime = alarmTime.add(Duration(days: alarmDay));
            }
          }
        } else {
          nextAlarm = null;
        }
      }
    }
    return nextAlarm;
  }

  static Future<List<AlarmModel>> fetchDateBaseAlarms() async {
//    AlarmModel deletedAlarm;
    List<AlarmModel> _alarms = [];
    AlarmsDataBase _alarmsDb = AlarmsDataBase();
    List<Map<String, dynamic>> _allAlarms = await _alarmsDb.getAllItem();
    _allAlarms.forEach((alarm) {
      return _alarms.add(AlarmModel.fromObj(alarm));
    });
//    _alarms.forEach((alarm) {
//      if ((alarm.alarmTimes.isEmpty ||
//              alarm.alarmTimes == null ||
//              alarm.alarmTimes.length == 1) &&
//          (DateTime.parse(alarm.alarm).isBefore(
//            DateTime.now(),
//          ))) {
//        deletedAlarm = alarm;
//        _alarmsDb.deleteItem(alarm.id);
//      }
//    });
//    if (_alarms.contains(deletedAlarm)) {
//      _alarms.remove(deletedAlarm);
//    }
    return _alarms;
  }

  static Future getAssetsLocalPath(localFileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$localFileName");
    if (!(await file.exists())) {
      final soundData = await rootBundle.load("assets/music/$localFileName");
      final bytes = soundData.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
    }
    return file.path;
  }
}
