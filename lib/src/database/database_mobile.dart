import 'package:sqflite/sqflite.dart';
import 'package:tarsier_local_storage/src/base_table.dart';

class DatabaseMobile {
  static Future<Database> initDatabase(
      String databaseFile, List<BaseTable> tables) async {
    return DatabaseManager().initDatabase(databaseFile, tables);
  }
}

/// Handles database initialization for mobile platforms.
class DatabaseManager {
  /// Opens or creates the database for mobile platforms.
  Future<Database> initDatabase(
      String databaseFile, List<BaseTable> tables) async {
    return await openDatabase(
      databaseFile,
      version: 1,
      onCreate: (db, version) => _onCreate(db, version, tables),
    );
  }

  /// Handles table creation during database initialization.
  Future<void> _onCreate(
      Database db, int version, List<BaseTable> tables) async {
    for (var table in tables) {
      await table.createTable(db);
    }
  }
}
