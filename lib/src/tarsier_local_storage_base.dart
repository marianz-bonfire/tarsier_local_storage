import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:archive/archive_io.dart';
import 'package:sqflite/sqlite_api.dart' as sql;
import 'package:tarsier_local_storage/src/base_table.dart';
import 'package:tarsier_local_storage/src/database/database_desktop.dart';
import 'package:tarsier_local_storage/src/database/database_mobile.dart';
import 'package:tarsier_local_storage/src/database/database_web.dart';
import 'package:tarsier_local_storage/src/enums/backup_restore_status.dart';
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

  static File? _databaseFile;

  File? get databaseFile {
    return _databaseFile;
  }

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
    if (!isWeb) {
      var storageFile = File(databaseFile);
      _databaseFile = storageFile;
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

  /// Backs up the SQLite database to a specified directory.
  ///
  /// - [backupDirectory]: Target directory for the backup file.
  /// - [archive]: Whether to compress the backup into a `.zip` archive.
  /// - [extension]: Custom file extension for the backup (default: `.bk`).
  /// - [onStatusChanged]: Callback to track the backup progress.
  Future<void> backup({
    required String backupDirectory,
    bool archive = false,
    String extension = '.bk',
    void Function(BackupStatus status)? onStatusChanged,
  }) async {
    try {
      if (_databaseFile == null || !await _databaseFile!.exists()) {
        throw Exception('Database file not found.');
      }

      // Notify status
      onStatusChanged?.call(BackupStatus.creatingBackupDirectory);

      // Ensure backup directory exists
      final directory = Directory(backupDirectory);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final backupFilePath = p.join(directory.path,
          '${p.basenameWithoutExtension(_databaseFile!.path)}$extension');
      final backupFile = File(backupFilePath);

      // Notify status
      onStatusChanged?.call(BackupStatus.writingBackupFile);

      // Copy the database file to the backup location
      await _databaseFile!.copy(backupFile.path);

      // If archive option is enabled, create a ZIP archive
      if (archive) {
        onStatusChanged?.call(BackupStatus.creatingArchive);
        final zipFile = File('$backupFilePath.zip');

        final archive = Archive();
        final backupBytes = await backupFile.readAsBytes();
        archive.addFile(ArchiveFile(
            p.basename(backupFile.path), backupBytes.length, backupBytes));

        final zipData = ZipEncoder().encode(archive);
        if (zipData != null) {
          await zipFile.writeAsBytes(zipData);
          await backupFile.delete(); // Remove the uncompressed backup
        }
      }

      // Notify completion
      onStatusChanged?.call(BackupStatus.completed);
    } catch (e) {
      onStatusChanged?.call(BackupStatus.failed);
      throw Exception('Backup failed: $e');
    }
  }

  /// Restores the SQLite database from a backup file.
  ///
  /// - [backupPath]: Path to the backup file (.bk or .zip).
  /// - [onStatusChanged]: Callback to track the restore progress.
  Future<void> restore({
    required String backupPath,
    void Function(RestoreStatus status)? onStatusChanged,
  }) async {
    try {
      final backupFile = File(backupPath);
      onStatusChanged?.call(RestoreStatus.readingBackupFile);

      if (!await backupFile.exists()) {
        throw Exception('Backup file not found.');
      }

      // If it's a ZIP archive, extract and restore
      if (backupPath.endsWith('.zip')) {
        onStatusChanged?.call(RestoreStatus.decodingArchive);

        final archive =
            ZipDecoder().decodeBytes(await backupFile.readAsBytes());
        for (final file in archive) {
          if (file.isFile) {
            final extractedBytes = file.content;
            final restoredFile = File(_databaseFile!.path);

            onStatusChanged?.call(RestoreStatus.restoringDatabase);
            await restoredFile.writeAsBytes(extractedBytes);
            break; // Restore only the first file in the archive
          }
        }
      } else {
        // If it's a direct backup file, copy it over
        onStatusChanged?.call(RestoreStatus.restoringDatabase);
        await backupFile.copy(_databaseFile!.path);
      }

      onStatusChanged?.call(RestoreStatus.completed);
    } catch (e) {
      onStatusChanged?.call(RestoreStatus.failed);
      throw Exception('Restore failed: $e');
    }
  }
}
