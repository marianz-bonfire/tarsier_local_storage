import 'package:sqflite/sqflite.dart' as sql;
import 'package:tarsier_local_storage/tarsier_local_storage.dart';

/// Abstract class for defining a base table for database operations.
///
/// This class provides common CRUD (Create, Read, Update, Delete)
/// operations and a framework for creating dynamic tables in the database.
///
/// To use this class:
/// - Extend it and define a concrete implementation for your table.
/// - Implement the `fromMap` and `toMap` functions for converting objects to/from the database format.
///
/// Example:
/// ```dart
/// class UserTable extends BaseTable<User> {
///   UserTable()
///       : super(
///           tableName: User.tableName,
///           schema: User.schema,
///           fromMap: (map) => User.fromMap(map),
///           toMap: (user) => user.toMap(),
///         );
/// }
/// ```

abstract class BaseTable<T extends BaseTableModel> {
  /// The name of the table in the database.
  final String tableName;

  /// The schema of the table, where the key is the column name, and the value is its SQL type definition.
  final Map<String, String> schema;

  /// Function to convert a map from the database into a model object.
  final T Function(Map<String, dynamic>) fromMap;

  /// Function to convert a model object into a map for the database.
  final Map<String, dynamic> Function(T) toMap;

  /// Constructor for the `BaseTable`.
  ///
  /// - [tableName]: The name of the table in the database.
  /// - [schema]: A map defining the schema of the table.
  /// - [fromMap]: A function to map database rows to model objects.
  /// - [toMap]: A function to map model objects to database rows.
  BaseTable({
    required this.tableName,
    required this.schema,
    required this.fromMap,
    required this.toMap,
  });

  /// Creates the table in the database if it does not exist.
  ///
  /// This method dynamically generates the `CREATE TABLE` SQL
  /// based on the table schema and executes it.
  ///
  /// - [db]: The database instance.
  Future<void> createTable(sql.Database db) async {
    final columns = schema.entries.map((e) => '${e.key} ${e.value}').join(', ');
    final createTableSQL = 'CREATE TABLE $tableName ($columns)';
    await db.execute(createTableSQL);
  }

  /// Inserts a model object into the database.
  ///
  /// - [data]: The model object to be inserted.
  ///
  /// Returns the ID of the inserted row.
  Future<int> createObject(T data) async {
    return await create(toMap(data));
  }

  /// Inserts a map of data into the database.
  ///
  /// - [data]: A map representing the row to be inserted.
  ///
  /// Returns the ID of the inserted row.
  Future<int> create(Map<String, dynamic> data) async {
    final db = await getDatabase();
    return db.insert(
      tableName,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  /// Retrieves all rows from the table.
  ///
  /// Returns a list of model objects.
  Future<List<T>> all() async {
    final db = await getDatabase();
    final data = await db.query(tableName, orderBy: "id");
    return data.map((e) => fromMap(e)).toList();
  }

  /// Retrieves a single row by a specific column value.
  ///
  /// - [value]: The value to match.
  /// - [columnName]: The column to filter by. Defaults to `'id'`.
  ///
  /// Returns the matching model object or `null` if no match is found.
  Future<T?> get(value, {String columnName = 'id'}) async {
    final db = await getDatabase();
    final data = await db.query(
      tableName,
      where: "$columnName = ?",
      whereArgs: [value],
      limit: 1,
    );
    if (data.isNotEmpty) {
      return fromMap(data.first);
    }
    return null;
  }

  /// Updates a row with a new model object.
  ///
  /// - [id]: The ID of the row to update.
  /// - [item]: The new data as a model object.
  ///
  /// Returns the number of rows affected.
  Future<int> updateObject(int id, T item) async {
    return update(id, toMap(item));
  }

  /// Updates a row with new data.
  ///
  /// - [id]: The ID of the row to update.
  /// - [data]: A map of the new data.
  ///
  /// Returns the number of rows affected.
  Future<int> update(int id, Map<String, dynamic> data) async {
    final db = await getDatabase();
    return db.update(
      tableName,
      data,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  /// Deletes a row by its ID.
  ///
  /// - [id]: The ID of the row to delete.
  Future<void> delete(int id) async {
    final db = await getDatabase();
    await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  /// Checks if a row exists in the table.
  ///
  /// - [conditions]: A map where the key is the column name, and the value is the value to match.
  /// - [forceString]: Whether to force all conditions to be treated as strings.
  ///
  /// Returns `true` if a matching row exists, otherwise `false`.
  Future<bool> exists(Map<String, dynamic> conditions,
      {bool forceString = false}) async {
    final db = await getDatabase();

    String whereClause = conditions.keys.map((key) => "$key = ?").join(' AND ');
    List<Object?> whereArgs = forceString
        ? conditions.values.map((value) => '"$value"').toList()
        : conditions.values.toList();

    final result = await db.query(
      tableName,
      where: whereClause,
      whereArgs: whereArgs,
      limit: 1,
    );

    return result.isNotEmpty;
  }

  /// Retrieves the database instance from `TarsierLocalStorage`.
  ///
  /// Returns the initialized [sql.Database] instance.
  Future<sql.Database> getDatabase() async {
    return await TarsierLocalStorage().database;
  }
}
