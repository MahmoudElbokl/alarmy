import 'dart:async';

import 'package:alarmy/alarms_database.dart';
import 'package:alarmy/background_service.dart';
import 'package:flutter/material.dart';
import 'package:alarmy/alarm_model.dart';

class AlarmProvider with ChangeNotifier {
  AlarmsDataBase _dataBase = AlarmsDataBase();
  List<AlarmModel> alarms = [];

  Future<int> getNewAlarmId() async {
    //use the existing alarms to find the lowest empty id
    List<AlarmModel> _alarms = await BackgroundService.fetchDateBaseAlarms();
    final List<int> alarmIds =
        _alarms.map((AlarmModel alarm) => alarm.id).toList(growable: false);
    int id = 0;
    while (alarmIds.contains(id)) {
      id++;
    }
    return id;
  }

  fetchAlarms() async {
    alarms = await BackgroundService.fetchDateBaseAlarms();
    notifyListeners();
  }

  void addAlarm(AlarmModel alarmModel) async {
    alarms.add(alarmModel);
    await _dataBase.saveAlarm(alarmModel);
    BackgroundService.scheduleAlarm();
    notifyListeners();
  }

  void deleteAlarms(id, index) async {
    alarms.removeAt(index);
    notifyListeners();
    await _dataBase.deleteItem(id);
  }

  void updateAlarmsActivity(id, index) async {
    if (alarms[index].active == 0) {
      alarms[index].active = 1;
    } else {
      alarms[index].active = 0;
    }
    await _dataBase.updateItem(id, alarms[index]);
    notifyListeners();
  }
}
