import 'dart:io';
import 'package:alarmy/alarm_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AlarmsDataBase {
  Database _db;
  final String _alarmsTable = "alarmstable";
  final String _id = "id";
  final String _label = "label";
  final String _alarm = "alarm";
  final String _audioPath = "audiopath";
  final String _alarmTimes = "alarmtimes";
  final String _active = "active";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "alarmsList.db");
    var db = openDatabase(path, onCreate: _onCreate, version: 1);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_alarmsTable ($_id INTEGER PRIMARY KEY, $_label TEXT, $_alarm TEXT ,  $_audioPath TEXT , $_alarmTimes INTEGER ,$_active INTEGER)");
  }

  Future<int> saveAlarm(AlarmModel alarmModel) async {
    Database dbClient = await db;
    int res = await dbClient.insert(_alarmsTable, alarmModel.toMap());
    return res;
  }

  Future<List> getAllItem() async {
    var dbClient = await db;
    List allItems = await dbClient.query("$_alarmsTable");
    return allItems;
  }

  Future<AlarmModel> getItem(int id) async {
    var dbClient = await db;
    var res =
        await dbClient.rawQuery("SELECT * FROM $_alarmsTable WHERE id = $id");
    if (res.length > 0) {
      return AlarmModel.fromMap(res.first);
    }
    return null;
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    int res = await dbClient
        .delete("$_alarmsTable", where: "id = ?", whereArgs: [id]);
    if (res == 0) {
      await dbClient.delete("$_alarmsTable");
    }
    return res;
  }

  Future<int> updateItem(int id, AlarmModel alarm) async {
    var dbClient = await db;
    int res = await dbClient.update("$_alarmsTable", alarm.toMap(),
        where: "id = ?", whereArgs: [id]);
    return res;
  }
}
