import 'package:alarmy/screens/select_sound_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class PhoneSounds extends StatefulWidget {
  static List<SongInfo> songs = [];

  @override
  _PhoneSoundsState createState() => _PhoneSoundsState();
}

class _PhoneSoundsState extends State<PhoneSounds> {
  List<IconData> playPauseIcons;
  bool _isLoading = true;
  FlutterAudioQuery audioQuery = FlutterAudioQuery();

  loadSongs() async {
    setState(() {
      _isLoading = true;
    });
    try {
      PhoneSounds.songs = await audioQuery.getSongs();
    } catch (e) {
      print("Failed to get songs: '${e.message}'.");
    }
    setState(() {
      _isLoading = false;
    });
    playPauseIcons = List(PhoneSounds.songs.length);
  }

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: PhoneSounds.songs.length,
            itemBuilder: (c, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                      title: Text(PhoneSounds.songs[index].title),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Radio(
                              value: index + 12,
                              groupValue: SelectSoundScreen.radioValue,
                              onChanged: (newV) {
                                setState(() {
                                  SelectSoundScreen.radioValue = newV;
                                });
                              }),
                          IconButton(
                              icon: Icon(playPauseIcons[index] == null
                                  ? Icons.play_arrow
                                  : playPauseIcons[index]),
                              onPressed: () async {
                                if (playPauseIcons[index] == Icons.play_arrow ||
                                    playPauseIcons[index] == null) {
                                  if (playPauseIcons.contains(Icons.pause)) {
                                    playPauseIcons =
                                        List(PhoneSounds.songs.length);
                                    SelectSoundScreen.audioPlayer.stop();
                                  }
                                  SelectSoundScreen.audioPlayer.play(
                                      PhoneSounds.songs[index].filePath,
                                      isLocal: true);
                                  playPauseIcons[index] = Icons.pause;
                                } else {
                                  SelectSoundScreen.audioPlayer.stop();
                                  playPauseIcons[index] = Icons.play_arrow;
                                }
                                setState(() {});
                              }),
                        ],
                      )),
                  Divider(
                    color: Colors.black,
                  )
                ],
              );
            });
  }
}
