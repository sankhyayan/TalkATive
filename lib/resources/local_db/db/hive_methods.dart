import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skype_clone/models/log.dart';
import 'package:skype_clone/resources/local_db/interface/log_interface.dart';

class HiveMethods implements LogInterface {
  String hive_box = "";
  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  @override
  addLogs(Log log) async {
    var box = await Hive.openBox(hive_box);
    var logMap=log.toMap(log);
    await box.add(logMap);
    await close();
    print("log was added to hive db");
  }

  updateLog(int i,Log newLog)async{
    var box=await Hive.openBox(hive_box);
    var newLogMap=newLog.toMap(newLog);
    await box.put(i, newLogMap);
    await close();
  }

  @override
  close()async=>await Hive.close();

  @override
  deleteLogs(int logId) async{
    var box=await Hive.openBox(hive_box);
    await box.deleteAt(logId);
    close();
  }

  @override
  Future<List<Log>> getLogs() async{
    var box=await Hive.openBox(hive_box);
    List<Log> logList=[];
    if (box.isNotEmpty) {
      for(int i=0;i<box.length;i++){
        var logMap=await box.getAt(i);
        logList.add(Log.fromMap(logMap));
      }
    }
    await close();
    return logList;
  }

  @override
  openDb(dbName) =>(hive_box=dbName);
}
