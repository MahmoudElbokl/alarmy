import 'package:flutter/material.dart';

class AlarmModel {
  int id;
  String label;
  String audioPath;
  List<int> alarmTimes;
  int active;
  String alarm;

  AlarmModel({
    @required this.id,
    @required this.label,
    @required this.alarm,
    @required this.audioPath,
    @required this.alarmTimes,
    this.active = 1,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = this.id;
    map["label"] = this.label;
    map["alarm"] = this.alarm;
    map["active"] = this.active;
    map["audiopath"] = this.audioPath;
    map["alarmtimes"] = this.alarmTimes;
    return map;
  }

  AlarmModel.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.label = map["label"];
    this.alarmTimes = map["alarmtimes"];
    this.alarm = map["alarm"];
    this.active = map["active"];
    this.audioPath = map["audiopath"];
  }

  AlarmModel.fromObj(dynamic obj) {
    this.id = obj["id"];
    this.label = obj["label"];
    this.alarmTimes = obj["alarmtimes"];
    this.alarm = obj["alarm"];
    this.active = obj["active"];
    this.audioPath = obj["audiopath"];
  }
}
