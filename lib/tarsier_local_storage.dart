/// A library for managing local SQLite storage in Dart and Flutter applications.
///
/// The `tarsier_local_storage` package provides a framework for working with
/// SQLite databases, offering abstractions for tables, models, and dynamic CRUD
/// operations. It simplifies the creation and maintenance of database tables
/// and operations, making it easier to build scalable and maintainable apps.
///
/// ## Features
/// - Manage database initialization and connections.
/// - Define dynamic database tables with schemas.
/// - Perform CRUD operations seamlessly with models and tables.
///
/// ## Getting Started
/// To use this library, import it in your Dart or Flutter project:
/// ```dart
/// import 'package:tarsier_local_storage/tarsier_local_storage.dart';
/// ```
///
/// ## Example Usage
/// Here's a quick example of defining and using a table:
///
/// ```dart
/// import 'package:tarsier_local_storage/tarsier_local_storage.dart';
///
/// // Define a model class
/// class User extends BaseTableModel {
///   final int id;
///   final String name;
///
///   User({required this.id, required this.name});
///
///   @override
///   Map<String, dynamic> toMap() {
///     return {'id': id, 'name': name};
///   }
/// }
///
/// // Define a table class
/// class UserTable extends BaseTable<User> {
///   UserTable()
///       : super(
///           tableName: 'users',
///           schema: {'id': 'INTEGER PRIMARY KEY', 'name': 'TEXT NOT NULL'},
///           fromMap: (map) => User(id: map['id'], name: map['name']),
///           toMap: (user) => user.toMap(),
///         );
/// }
///
/// // Use the table in the database
/// void main() async {
///   final storage = TarsierLocalStorage();
///   final db = await storage.init('app.db', [UserTable()]);
///
///   // Add a user
///   final userTable = UserTable();
///   await userTable.createObject(User(id: 1, name: 'John Doe'));
///
///   // Retrieve all users
///   final users = await userTable.all();
///   print(users);
/// }
/// ```

library tarsier_local_storage;

export 'src/tarsier_local_storage_base.dart';
export 'src/base_table.dart';
export 'src/base_table_model.dart';
