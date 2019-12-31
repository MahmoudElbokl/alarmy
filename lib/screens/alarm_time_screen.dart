import 'package:alarmy/alarm_model.dart';
import 'package:alarmy/screens/alarms_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:alarmy/background_service.dart';

class AlarmTimeScreen extends StatefulWidget {
  final AlarmModel alarmModel;

  AlarmTimeScreen(this.alarmModel);

  @override
  _AlarmTimeScreenState createState() => _AlarmTimeScreenState();
}

class _AlarmTimeScreenState extends State<AlarmTimeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              DateFormat.jm().format(
                DateTime.now(),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                wordSpacing: 1.5,
              ),
            ),
            Text(
              BackgroundService.firstAlarm.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                wordSpacing: 1.5,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
            ),
            RaisedButton(
              color: Colors.white,
              onPressed: () {
                BackgroundService.audioPlayer.stop();
                BackgroundService.scheduleAlarm();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (c) => AlarmsScreen(),
                  ),
                );
              },
              child: Text(
                "Dismiss",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  wordSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
