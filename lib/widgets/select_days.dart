import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:alarmy/providers/repeat_provider.dart';

class SelectDaysDialog extends StatefulWidget {
  @override
  _SelectDaysDialogState createState() => _SelectDaysDialogState();
}

class _SelectDaysDialogState extends State<SelectDaysDialog> {
  bool _selected = true;

  @override
  Widget build(BuildContext context) {
    final listenProvider = Provider.of<Repeat>(context, listen: true);
    final provider = Provider.of<Repeat>(context, listen: false);
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          children: <Widget>[
            Container(alignment: Alignment.topLeft, child: Text("Repeat")),
            FlatButton(
              color: listenProvider.color,
              onPressed: () {
                listenProvider.updateAll();
              },
              child: Text("All WeekDays"),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.50,
              child: ListView.builder(
                itemCount: 7,
                itemBuilder: (context, index) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.070,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(Repeat.dateFormat(DateTime.now(), index)),
                        Checkbox(
                            value: provider.daysActivity[Repeat.day + index],
                            onChanged: (c) {
                              provider.changeActive(index);
                              if (provider.daysActivity.containsValue(true)) {
                                _selected = true;
                              }
                            }),
                      ],
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  color: Colors.blue,
                  onPressed: () {
                    provider.defaultActive();
                    Navigator.of(context).pop();
                  },
                  child: Text("Default"),
                ),
                FlatButton(
                  color: Colors.blue,
                  onPressed: () {
                    if (provider.selectedDays.isEmpty ||
                        provider.selectedDays == null) {
                      setState(() {
                        _selected = false;
                      });
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("Save"),
                ),
              ],
            ),
            _selected
                ? SizedBox.shrink()
                : Text(
                    "*You must choose one day",
                    style: TextStyle(color: Colors.red),
                  ),
          ],
        ),
      ),
    );
  }
}
