import 'dart:io';
import 'dart:async';

import 'package:sqflite/sqlite_api.dart' as sql;
import 'package:tarsier_local_storage/src/base_table.dart';
import 'package:tarsier_local_storage/src/database/database_desktop.dart';
import 'package:tarsier_local_storage/src/database/database_mobile.dart';
import 'package:tarsier_local_storage/src/database/database_web.dart';
import 'package:tarsier_local_storage/src/platforms/platform_checker.dart';

//import 'database/database.dart';

/// A local storage manager class for handling database operations.
///
/// This class provides methods for initializing, opening, and managing
/// a local SQLite database. It supports creating tables dynamically
/// based on the provided list of [BaseTable] objects.
class TarsierLocalStorage {
  /// The singleton database instance.
  static sql.Database? _database;

  /// Returns the initialized database instance.
  ///
  /// If the database is not already initialized, it will be created
  /// using the default file name `'data.db'` and no predefined tables.
  Future<sql.Database> get database async {
    return await init('data.db');
  }

  /// Initializes the database.
  ///
  /// This method sets up the database connection and creates the specified
  /// tables if they do not already exist.
  ///
  /// - [databaseFile]: The path to the database file.
  /// - [tables]: A list of tables to initialize in the database.
  ///
  /// Returns the initialized [Database] instance.
  Future<sql.Database> init(String databaseFile,
      [List<BaseTable> tables = const []]) async {
    if (_database != null) {
      return _database!;
    }

    // If _database is null, initialize it
    _database = await open(databaseFile, tables);
    return _database!;
  }

  /// Opens the database file or creates it if it doesn't exist.
  ///
  /// Ensures that the database file is accessible and initializes
  /// the connection based on the platform.
  ///
  /// - [databaseFile]: The path to the database file.
  /// - [tables]: A list of tables to initialize in the database.
  ///
  /// Returns the [Database] instance.
  Future<sql.Database> open(String databaseFile, List<BaseTable> tables,
      {delete = false}) async {
    var storageFile = File(databaseFile);

    try {
      // Delete the existing database file if requested
      if (delete && await storageFile.exists()) {
        await storageFile.delete(recursive: true);
      }

      // Ensure the database file exists, create it if necessary
      if (!await storageFile.exists()) {
        await storageFile.create(recursive: true);
      }

      // Validate that the database file is accessible
      await storageFile.readAsBytes();
    } catch (e) {
      throw Exception('Error with the database file: $e');
    }

    if (isWeb) {
      return await DatabaseWeb.initDatabase(databaseFile, tables);
    } else if (isMobile) {
      return await DatabaseMobile.initDatabase(databaseFile, tables);
    } else if (isDesktop) {
      return await DatabaseDesktop.initDatabase(databaseFile, tables);
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    //return await DatabaseManager().initDatabase(databaseFile, tables);
  }
}
