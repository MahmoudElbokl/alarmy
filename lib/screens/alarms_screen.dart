import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:alarmy/providers/alarm_provider.dart';
import 'package:alarmy/providers/repeat_provider.dart';
import 'package:alarmy/screens/add_alarm_screen.dart';
import 'package:alarmy/widgets/main_scaffold.dart';

class AlarmsScreen extends StatefulWidget {
  static BuildContext alarmsScreenContext;

  @override
  _AlarmsScreenState createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  bool first = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (first) {
      await Provider.of<AlarmProvider>(context, listen: true).fetchAlarms();
      first = false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AlarmsScreen.alarmsScreenContext = context;
    final provider = Provider.of<AlarmProvider>(context);
    double height = MediaQuery.of(context).size.height;
    return MainScaffold(
        appBarTitle: "Alarms",
        appBarAction: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                  color: Colors.blue,
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return AddAlarmScreen();
                      }),
                    );
                  }),
            ),
          ),
        ],
        floatingButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return AddAlarmScreen();
                }),
              );
            }),
        child: (provider.alarms == null || provider.alarms.length == 0)
            ? Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return AddAlarmScreen();
                      }),
                    );
                  },
                  child: Icon(
                    Icons.add_alarm,
                    size: 200,
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.only(bottom: height * 0.03),
                itemCount: provider.alarms.length,
                itemBuilder: (context, index) {
                  List<bool> _activity = [false, true];
                  return Dismissible(
                    key: Key(provider.alarms[index].id.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      provider.deleteAlarms(provider.alarms[index].id, index);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("The Alarm Succesfully deleted"),
                        duration: Duration(seconds: 1),
                      ));
                    },
                    confirmDismiss: (direction) {
                      return showDialog(
                          context: (context),
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Delete Alarm",
                                textAlign: TextAlign.center,
                              ),
                              content:
                                  Text("Do you want to remove this alarm ?"),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text("Cancel")),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text("Delete")),
                              ],
                            );
                          });
                    },
                    background: Card(
                      margin: EdgeInsets.only(
                          left: height * 0.03,
                          right: height * 0.03,
                          top: height * 0.03),
                      elevation: 0,
                      child: Container(
                        padding: const EdgeInsets.only(right: 10),
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.delete),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.redAccent,
                                  Colors.deepOrangeAccent,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                      ),
                      color: Colors.white,
                    ),
                    child: Card(
                      margin: EdgeInsets.only(
                        left: height * 0.03,
                        right: height * 0.03,
                        top: height * 0.03,
                      ),
                      elevation: 0,
                      child: Container(
                        height: height * 0.2,
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.025,
                          horizontal: height * 0.03,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xff29a19c),
                                  Color(0xffB1D4E0),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              provider.alarms[index].label,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Center(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "${DateFormat.jm().format(DateTime.parse(provider.alarms[index].alarm))}",
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 3,
                                        wordSpacing: 2),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    height: height * 0.035,
                                    width: 60,
                                    child: Switch(
                                        value: _activity[
                                            provider.alarms[index].active],
                                        onChanged: (v) {
                                          provider.updateAlarmsActivity(
                                              provider.alarms[index].id, index);
                                        }),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            SizedBox(
                              height: height * 0.030,
                              child:
                                  (provider.alarms[index].alarmTimes.length ==
                                          7)
                                      ? Text("All week Days")
                                      : ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: provider
                                              .alarms[index].alarmTimes.length,
                                          itemBuilder: (context, i) {
                                            return Text(
                                                "${Repeat.dateFormatLessChar(DateTime.parse(provider.alarms[index].alarm), provider.alarms[index].alarmTimes[i])}");
                                          }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}
