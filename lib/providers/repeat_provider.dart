import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Repeat with ChangeNotifier {
  static int day = DateTime.now().day;
  Color _color;

  Map<String, int> selectedDays = {dateFormatLessChar(DateTime.now(), 0): day};

  static String dateFormat(DateTime datetime, int dayNum) {
    return DateFormat.EEEE()
        .format(
          datetime.add(
            Duration(days: dayNum),
          ),
        )
        .toString();
  }

  static String dateFormatLessChar(DateTime datetime, int dayNum) {
    return "${DateFormat.E().format(
      datetime.add(
        Duration(days: dayNum),
      ),
    )}  ";
  }

  Map _daysActivity = {
    day: true,
    day + 1: false,
    day + 2: false,
    day + 3: false,
    day + 4: false,
    day + 5: false,
    day + 6: false,
  };

  Map<int, bool> get daysActivity {
    return {..._daysActivity};
  }

  set daysActivity(Map value) {
    _daysActivity = value;
  }

  List<int> _activeDays = [];

  List<int> get activeDays {
    _daysActivity.forEach((k, v) {
      if (v == true) {
        if (!_activeDays.contains(k)) _activeDays.add(k);
      }
    });
    return [..._activeDays];
  }

  int numberOfActive() {
    int _activeNumber = 0;
    _daysActivity.forEach((k, v) {
      if (v == true) {
        _activeNumber++;
      }
    });
    return _activeNumber;
  }

  Color get color {
    int total = numberOfActive();
    if (total == 7) {
      _color = Colors.blue;
    } else {
      _color = Colors.white;
    }
    return _color;
  }

  void updateAll() {
    int sum = numberOfActive();
    if (sum == 7) {
      _daysActivity.updateAll((k, v) {
        selectedDays.clear();
        return v = false;
      });
    } else {
      selectedDays.clear();
      _daysActivity.updateAll((k, v) {
        selectedDays.putIfAbsent(dateFormatLessChar(DateTime.now(), k - day),
            () {
          return k;
        });
        return v = true;
      });
    }
    notifyListeners();
  }

  void changeActive(index) {
    _daysActivity[day + index] = !_daysActivity[day + index];
    if (_daysActivity[day + index]) {
      if (!selectedDays
          .containsKey(dateFormatLessChar(DateTime.now(), index))) {
        selectedDays.putIfAbsent(dateFormatLessChar(DateTime.now(), index), () {
          return day + index;
        });
      }
    } else {
      if (selectedDays.containsKey(dateFormatLessChar(DateTime.now(), index))) {
        selectedDays.remove(dateFormatLessChar(DateTime.now(), index));
      }
    }
    notifyListeners();
  }

  void defaultActive() {
    selectedDays.clear();
    _daysActivity.updateAll((k, v) {
      if (k != day) {
        return v = false;
      } else {
        return v = true;
      }
    });
    selectedDays.putIfAbsent(dateFormatLessChar(DateTime.now(), 0), () {
      return day;
    });
    notifyListeners();
  }

  List<int> setAlarmDays(alarmTime) {
    List<int> alarmTimes = [];
    if (alarmTime.isBefore(DateTime.now())) {
      if (activeDays.contains(day)) {
        alarmTimes.add(7);
        for (var day in activeDays) {
          if (day != Repeat.day) {
            alarmTimes.add(day - Repeat.day);
          }
        }
      }
    } else if (alarmTime.isAfter(DateTime.now())) {
      if (activeDays.length == 1) {
        if (activeDays.first == Repeat.day) {
          alarmTimes.add(0);
        } else {
          alarmTimes.add(activeDays.first - Repeat.day);
        }
      } else {
        for (var day in activeDays) {
          alarmTimes.add(day - Repeat.day);
        }
      }
    }
    return alarmTimes;
  }
}
