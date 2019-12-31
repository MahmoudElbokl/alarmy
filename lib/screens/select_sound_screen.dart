import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';

import 'package:alarmy/screens/add_alarm_screen.dart';
import 'package:alarmy/widgets/phone_sounds_screen.dart';
import 'package:alarmy/widgets/classic_ringtones.dart';
import 'package:alarmy/widgets/main_scaffold.dart';
import 'package:alarmy/background_service.dart';

class SelectSoundScreen extends StatefulWidget {
  static int radioValue = 2;
  static AudioPlayer audioPlayer = AudioPlayer();

  @override
  _SelectSoundScreenState createState() => _SelectSoundScreenState();
}

class _SelectSoundScreenState extends State<SelectSoundScreen>
    with SingleTickerProviderStateMixin {
  String audioPath;
  String audioName;
  TabController _tabController;

  List<String> songsName = [
    "None",
    "Rooster",
    "WakeUp",
    "Winter",
    "Beeps",
    "Tropical",
    "Windows",
    "BirdClock",
    "Fantasy",
    "Coolest",
    "Fanfare",
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        SelectSoundScreen.audioPlayer.stop();
      });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBarTitle: "Select sound",
      tabBar: TabBar(controller: _tabController, tabs: [
        Tab(
          child: Text("Classic Ringtone"),
        ),
        Tab(
          child: Text("Music on Device"),
        )
      ]),
      leading: IconButton(
        onPressed: () async {
          SelectSoundScreen.audioPlayer.stop();
          audioPath =
              await BackgroundService.getAssetsLocalPath("${songsName[1]}.mp3");
          AddAlarmScreen.selectedMusic = {songsName[1]: audioPath};
          Navigator.of(context).pop(AddAlarmScreen.selectedMusic);
        },
        icon: Icon(Icons.clear),
      ),
      appBarAction: [
        FlatButton(
          child: Icon(Icons.done),
          onPressed: () async {
            SelectSoundScreen.audioPlayer.stop();
            if (SelectSoundScreen.radioValue != 0) {
              if (SelectSoundScreen.radioValue > 11) {
                AddAlarmScreen.selectedMusic = {
                  PhoneSounds.songs[SelectSoundScreen.radioValue - 12].title:
                      PhoneSounds
                          .songs[SelectSoundScreen.radioValue - 12].filePath
                };
              } else {
                audioPath = await BackgroundService.getAssetsLocalPath(
                    "${songsName[SelectSoundScreen.radioValue - 1]}.mp3");
                AddAlarmScreen.selectedMusic = {
                  songsName[SelectSoundScreen.radioValue - 1]: audioPath
                };
              }
              Navigator.of(context).pop(AddAlarmScreen.selectedMusic);
            } else {
              AddAlarmScreen.selectedMusic = {"None": ""};
              Navigator.of(context).pop(AddAlarmScreen.selectedMusic);
            }
          },
        ),
      ],
      child: TabBarView(controller: _tabController, children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 5),
          child: ClassicRingTones(songsName),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 5),
          child: PhoneSounds(),
        ),
      ]),
    );
  }
}
