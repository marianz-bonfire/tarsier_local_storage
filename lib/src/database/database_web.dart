import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'
    show SqfliteFfiWebOptions, createDatabaseFactoryFfiWeb;

import 'package:tarsier_local_storage/src/base_table.dart';

class DatabaseWeb {
  static Future<Database> initDatabase(
      String databaseFile, List<BaseTable> tables) async {
    return DatabaseManager().initDatabase(databaseFile, tables);
  }
}

const indexedDbName = 'tarsier_local_storage';

/// Handles database initialization for desktop platforms.
class DatabaseManager {
  /// Opens or creates the database for desktop platforms.
  Future<Database> initDatabase(
      String databaseFile, List<BaseTable> tables) async {
    // Initialize FFI (required for web platforms).
    //databaseFactory = databaseFactoryFfiWeb;

    var factory = createDatabaseFactoryFfiWeb(
        options: SqfliteFfiWebOptions(
      indexedDbName: indexedDbName,
    ));

    return await factory.openDatabase(
      databaseFile,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) => _onCreate(db, version, tables),
      ),
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
