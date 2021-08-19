import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:skype_clone/models/log.dart';
import 'package:skype_clone/resources/local_db/interface/log_interface.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteMethods implements LogInterface {
  late Database _db;
  String databaseName = "";
  String tableName = "Call_Logs";

  ///COLUMNS
  String id = "log_id";
  String callerName = "caller_name";
  String callerPic = "caller_pic";
  String receiverName = "receiver_name";
  String receiverPic = "receiver_pic";
  String callStatus = "call_status";
  String timestamp = "timestamp";

  ///db getter
  Future<Database> get db async {
    _db = await init();
    return _db;
  }

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, databaseName);
    print("awaiting db creation");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    print(" db created");
    return db;
  }

  _onCreate(Database db, int version) async {
    String createTableQuery =
        "CREATE TABLE $tableName($id INTEGER PRIMARY KEY, $callerName TEXT, $callerPic TEXT, $receiverName TEXT, $receiverPic TEXT, $callStatus TEXT, $timestamp TEXT)";
    await db.execute(createTableQuery);
    print("table created");
  }

  @override
  addLogs(Log log) async {
    ///db getter
    var dbClient = await db;
    await dbClient.insert(tableName, log.toMap(log));
    print("log was added to sqlite db");
  }

  ///don't need update in app just for learning
  updateLogs(Log log) async {
    var dbClient = await db;
    await dbClient.update(tableName, log.toMap(log),
        where: '$id = ? ', whereArgs: [log.logId]);
  }

  ///manual closing of sqlite db
  @override
  close() async {
    var dbClient = await db;
    await dbClient.close();
  }

  @override
  deleteLogs(int logId) async {
    var dbClient = await db;
    return await dbClient.delete(tableName, where: '$id = ? ', whereArgs: [logId+1]);
  }

  @override
  Future<List<Log>> getLogs() async {
    var dbClient = await db;
    // List<Map> maps = await dbClient.rawQuery("SELECT * FROM $tableName");
    List<Map<String, dynamic>> maps = await dbClient.query(
      tableName,
      columns: [
        //todo understand necessity of this
        id,
        callerName,
        callerPic,
        receiverName,
        receiverPic,
        callStatus,
        timestamp
      ],
    );
    List<Log> logList = [];
    if (maps.isNotEmpty) {
      for (Map<String, dynamic> map in maps) {
        logList.add(Log.fromMap(map));
      }
    }
    return logList;
  }

  @override
  openDb(dbName)=>(databaseName=dbName);
}
