import 'package:sqflite/sqlite_api.dart';
import 'package:tarsier_local_storage/src/base_table.dart';

/// Handles database initialization for desktop platforms.
class DatabaseManager {
  /// Opens or creates the database for desktop platforms.
  Future<Database> initDatabase(
      String databaseFile, List<BaseTable> tables) async {
    throw UnimplementedError();
  }
}
