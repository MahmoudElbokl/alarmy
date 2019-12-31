import 'package:alarmy/providers/alarm_provider.dart';
import 'package:flutter/material.dart';
import 'screens/alarms_screen.dart';
import 'package:provider/provider.dart';
import 'package:alarmy/providers/repeat_provider.dart';

void main() async {
//  WidgetsFlutterBinding.ensureInitialized();
  print("Main run");
  runApp(MyApp());
//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//  FlutterLocalNotificationsPlugin();
//  var initializationSettingsAndroid =
//  AndroidInitializationSettings('ic_launcher');
//  var initializationSettingsIOS = IOSInitializationSettings();
//  var initializationSettings = InitializationSettings(
//      initializationSettingsAndroid, initializationSettingsIOS);
//  flutterLocalNotificationsPlugin.initialize(initializationSettings,
//      onSelectNotification: (payload) {
//        return onSelectCallBack(payload);
//      });
}

//onSelectCallBack(String payload) {
//  Navigator.pushReplacement(
//    AlarmsScreen.alarmsScreenContext,
//    MaterialPageRoute(builder: (context) => AlarmTimeScreen(BackgroundService.firstAlarm)),
//  );
//}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Repeat()),
        ChangeNotifierProvider.value(value: AlarmProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Alarm App",
        home: AlarmsScreen(),
        theme: Theme.of(context).copyWith(
          primaryIconTheme: IconThemeData(color: Colors.black54),
          scaffoldBackgroundColor: Colors.white,
        ),
      ),
    );
  }
}
