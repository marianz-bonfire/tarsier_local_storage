import 'package:sqflite/sqlite_api.dart';
import 'package:tarsier_local_storage/src/base_table.dart';

abstract class DatabaseManager {
  Future<Database> initDatabase(String databaseFile, List<BaseTable> tables);
}
