import 'package:skype_clone/models/log.dart';

abstract class LogInterface {
  openDb(dbName);
  init();
  addLogs(Log log);
  ///RETURNS A LIST OF LOGS
  Future<List<Log>> getLogs();
  deleteLogs(int logId);
  close();
}
