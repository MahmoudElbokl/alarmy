import 'package:flutter/material.dart';

import 'package:audioplayers/audio_cache.dart';

import 'package:alarmy/screens/select_sound_screen.dart';
import 'package:alarmy/background_service.dart';

class ClassicRingTones extends StatefulWidget {
  final List<String> songsName;

  ClassicRingTones(this.songsName);

  @override
  _ClassicRingTonesState createState() => _ClassicRingTonesState();
}

class _ClassicRingTonesState extends State<ClassicRingTones> {
  List<IconData> playPauseIcons;
  AudioCache audioCache = AudioCache();

  @override
  void initState() {
    playPauseIcons = List(widget.songsName.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.songsName.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(widget.songsName[index]),
              onTap: () {
                setState(() {
                  SelectSoundScreen.radioValue = index + 1;
                });
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Radio(
                      value: index + 1,
                      groupValue: SelectSoundScreen.radioValue,
                      onChanged: (value) {
                        setState(() {
                          SelectSoundScreen.radioValue = value;
                        });
                      }),
                  if (index != 0)
                    IconButton(
                        icon: Icon(playPauseIcons[index] == null
                            ? Icons.play_arrow
                            : playPauseIcons[index]),
                        onPressed: () async {
                          String audioAssets =
                              await BackgroundService.getAssetsLocalPath(
                                  "${widget.songsName[index]}.mp3");
                          if (playPauseIcons[index] == Icons.play_arrow ||
                              playPauseIcons[index] == null) {
                            if (playPauseIcons.contains(Icons.pause)) {
                              playPauseIcons = List(widget.songsName.length);
                              SelectSoundScreen.audioPlayer.stop();
                            }
                            playPauseIcons[index] = Icons.pause;
                            SelectSoundScreen.audioPlayer
                                .play(audioAssets, isLocal: true);
                          } else {
                            playPauseIcons = List(widget.songsName.length);
                            SelectSoundScreen.audioPlayer.stop();
                          }
                          setState(() {});
                        }),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        );
      },
    );
  }
}
