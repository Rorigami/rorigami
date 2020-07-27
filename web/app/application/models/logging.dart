import 'package:logging/logging.dart';

/// Simply initializes the logging. All logs are redirected to the development
/// console. Many of the log levels are not added since there is no real need
/// for them. The available options are "ALL", "INFO", "WARNING", "SEVERE" and
/// "OFF". Those are passed to the AppLog constructor from the yml configuration
/// file in [cnf].
class AppLog {
  AppLog(String cnf){
    switch(cnf) {
      case 'ALL':
        Logger.root.level = Level.ALL;
        break;
      case 'INFO':
        Logger.root.level = Level.INFO;
        break;
      case 'WARNING':
        Logger.root.level = Level.WARNING;
        break;
      case 'SEVERE':
        Logger.root.level = Level.SEVERE;
        break;
      default:
        Logger.root.level = Level.OFF;
        break;
    }
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }
}