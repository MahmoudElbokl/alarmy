import 'dart:core';
import 'package:flutter/material.dart';

import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';

import 'package:alarmy/providers/alarm_provider.dart';
import 'package:alarmy/screens/select_sound_screen.dart';
import 'package:alarmy/widgets/main_scaffold.dart';
import 'package:alarmy/widgets/select_days.dart';
import 'package:alarmy/providers/repeat_provider.dart';
import 'package:alarmy/alarm_model.dart';

class AddAlarmScreen extends StatefulWidget {
  static Map<String, String> selectedMusic = {"Rooster": "music/Rooster.mp3"};

  @override
  _AddAlarmScreenState createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  TextEditingController _textEditingController =
      TextEditingController(text: "Wake Up");
  DateTime alarmTime;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context);
    final repeatProvider = Provider.of<Repeat>(context);
    return MainScaffold(
      appBarTitle: "Add Alarm",
      appBarAction: [
        FlatButton(
          child: Icon(Icons.done),
          onPressed: () async {
            Navigator.of(context).pop();
            alarmProvider.addAlarm(
              AlarmModel(
                id: await alarmProvider.getNewAlarmId(),
                label: _textEditingController.text,
                alarm: alarmTime.toIso8601String(),
                alarmTimes: repeatProvider.setAlarmDays(alarmTime),
                audioPath: AddAlarmScreen.selectedMusic.values.first,
              ),
            );
            repeatProvider.returnToDefault();
          },
        ),
      ],
      leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          }),
      child: Padding(
        padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
        child: Column(
          children: <Widget>[
            Center(
              child: Stack(
                children: <Widget>[
                  TimePickerSpinner(
                    onTimeChange: (time) {
                      alarmTime = DateTime(time.year, time.month, time.day,
                          time.hour, time.minute);
                    },
                    alignment: Alignment.center,
                    is24HourMode: false,
                    isShowSeconds: false,
                    itemWidth: 50,
                    itemHeight: 50,
                    normalTextStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    spacing: 35,
                    highlightedTextStyle: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                    ),
                    isForce2Digits: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 95),
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 9),
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  prefixText: "Label :  ",
                  prefixStyle: TextStyle(fontSize: 17),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: (context),
                    builder: (context) {
                      return SelectDaysDialog();
                    });
              },
              child: Container(
                padding: const EdgeInsets.only(top: 9, bottom: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Repeat",
                      style: TextStyle(fontSize: 17),
                    ),
                    Spacer(),
                    repeatProvider.selectedDays.length == 7
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Text("All WeekDays"),
                          )
                        : Container(
                            height: 30,
                            width: 180,
                            alignment: Alignment.centerRight,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: repeatProvider.selectedDays.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      repeatProvider.selectedDays.keys
                                          .toList()[index],
                                      textAlign: TextAlign.right,
                                    ),
                                  );
                                }),
                          ),
                    Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.black38,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return SelectSoundScreen();
                }));
              },
              child: Container(
                margin: const EdgeInsets.only(top: 9, bottom: 9),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Ringtone",
                      style: TextStyle(fontSize: 17),
                    ),
                    Spacer(),
                    Text(AddAlarmScreen.selectedMusic.keys.first),
                    Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
