import 'dart:io';
import 'dart:async';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tarsier_local_storage/src/base_table.dart';

/// A local storage manager class for handling database operations.
///
/// This class provides methods for initializing, opening, and managing
/// a local SQLite database. It supports creating tables dynamically
/// based on the provided list of [BaseTable] objects.
class TarsierLocalStorage {
  /// The singleton database instance.
  static Database? _database;

  /// Returns the initialized database instance.
  ///
  /// If the database is not already initialized, it will be created
  /// using the default file name `'data.db'` and no predefined tables.
  Future<Database> get database async {
    return await init('data.db', []);
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
  Future<Database> init(String databaseFile, List<BaseTable>? tables) async {
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
  Future<Database> open(String databaseFile, List<BaseTable>? tables) async {
    var storageFile = File(databaseFile);

    // Create the database file if it doesn't exist
    if (!await storageFile.exists()) {
      try {
        await storageFile.create(recursive: true);
      } catch (e) {
        throw Exception('Error creating database file: $e');
      }
    }

    // Verify that the database file exists and is accessible
    if (!await storageFile.exists()) {
      throw Exception('Database file not found');
    }

    try {
      await storageFile.readAsBytes();
    } catch (e) {
      throw Exception('Database file is not readable: $e');
    }

    // Platform-specific database initialization
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      final desktopDatabase = await databaseFactory.openDatabase(
        databaseFile,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) => _onCreate(db, version, tables),
        ),
      );
      return desktopDatabase;
    } else if (Platform.isAndroid || Platform.isIOS) {
      final mobileDatabase = await openDatabase(
        databaseFile,
        version: 1,
        onCreate: (db, version) => _onCreate(db, version, tables),
      );
      return mobileDatabase;
    }

    throw Exception("Unsupported platform");
  }

  /// Handles the creation of database tables.
  ///
  /// This method is invoked during database initialization. It iterates
  /// over the provided list of tables and invokes their `createTable` method.
  ///
  /// - [db]: The [Database] instance.
  /// - [version]: The version number of the database.
  /// - [tables]: A list of tables to initialize in the database.
  Future<void> _onCreate(
      Database db, int version, List<BaseTable>? tables) async {
    if (tables != null && tables.isNotEmpty) {
      for (var table in tables) {
        await table.createTable(db);
      }
    }
  }
}
