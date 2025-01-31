
<p align="center">
  <a href="https://pub.dev/packages/tarsier_local_storage">
    <img height="260" src="https://raw.githubusercontent.com/marianz-bonfire/tarsier_local_storage/master/assets/logo.png">
  </a>
  <h1 align="center">Tarsier Local Storage</h1>
</p>

<p align="center">
  <a href="https://pub.dev/packages/tarsier_local_storage">
    <img src="https://img.shields.io/pub/v/tarsier_local_storage?label=pub.dev&labelColor=333940&logo=dart">
  </a>
  <a href="https://pub.dev/packages/tarsier_local_storage/score">
    <img src="https://img.shields.io/pub/points/tarsier_local_storage?color=2E8B57&label=pub%20points">
  </a>
  <a href="https://github.com/marianz-bonfire/tarsier_local_storage/actions/workflows/dart.yml">
    <img src="https://github.com/marianz-bonfire/tarsier_local_storage/actions/workflows/dart.yml/badge.svg">
  </a>
  <a href="https://tarsier-marianz.blogspot.com">
    <img src="https://img.shields.io/static/v1?label=website&message=tarsier-marianz&labelColor=135d34&logo=blogger&logoColor=white&color=fd3a13">
  </a>
</p>

<p align="center">
  <a href="https://pub.dev/documentation/tarsier_local_storage/latest/">Documentation</a> •
  <a href="https://github.com/marianz-bonfire/tarsier_local_storage/issues">Issues</a> •
  <a href="https://github.com/marianz-bonfire/tarsier_local_storage/tree/master/example">Example</a> •
  <a href="https://github.com/marianz-bonfire/tarsier_local_storage/blob/master/LICENSE">License</a> •
  <a href="https://pub.dev/packages/tarsier_local_storage">Pub.dev</a>
</p>


A simple and flexible library for managing SQLite databases in Dart and Flutter applications. It simplifies database operations with reusable abstractions for tables and models, making it easy to build scalable and maintainable applications.

## ✨ Features

- **Easy Database Management**: Initialize and manage SQLite databases effortlessly.
- **Dynamic Tables**: Define table schemas dynamically with support for CRUD operations.
- **Model Mapping**: Seamlessly map database rows to model objects.
- **Cross-Platform**: Supports Android, iOS, Windows, Linux, and more.

## 🚀 Getting Started

Add the package to your `pubspec.yaml`:
```yaml
dependencies:
  tarsier_local_storage: ^1.0.4
```
Run the following command:
```bash
flutter pub get
```


## 📒 Usage
- ### Define a Model
Create a class that extends `BaseTableModel` to represent a database entity:
```dart
import 'package:tarsier_local_storage/tarsier_local_storage.dart';

class User extends BaseTableModel {
  final int? id;
  final String name;
  final DateTime createdAt;

  User({
    this.id,
    required this.name,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static const String tableName = 'users';

  static Map<String, String> get schema => {
        'id': 'INTEGER PRIMARY KEY',
        'name': 'TEXT',
        'created_at': 'TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP',
      };
}
```
- ### Define a Table
Create a table class by extending BaseTable:
```dart
import 'package:tarsier_local_storage/tarsier_local_storage.dart';

import 'user_model.dart';

class UserTable extends BaseTable<User> {
  UserTable()
      : super(
          tableName: User.tableName,
          schema: User.schema,
          fromMap: (map) => User.fromMap(map),
          toMap: (user) => user.toMap(),
        );
}
```
- ### Initialize the Database
Initialize the database and pass the table definitions:
```dart
void main() async {
  await TarsierLocalStorage().init('app.db', [
    UserTable(), // Table class extended by BaseTable
    ...          // Add more table class here
  ]);

  final userTable = UserTable();

  // Add a new user
  await userTable.createObject(User(id: 1, name: 'John Doe'));
  // Or using Map on creating new user
  await userTable.create({
    'id' : 1,
    'name' : 'John Doe',
  });

  // Retrieve all users
  final users = await userTable.all();
  for (var user in users) { 
    print(user.name);
  }
}
```

- ### Backup and Restore Functionality

This package provides a simple and efficient way to backup and restore an SQLite database in a Flutter application. It supports saving backups in a custom file format and optionally compressing them into .zip archives for storage efficiency.

  - ✅ Backup SQLite database to a specified directory
  - ✅ Restore database from a backup file (supports .zip and uncompressed files)
  - ✅ Supports progress tracking with callback functions
  - ✅ Efficient file handling with proper error management
  - ✅ Uses archive package for ZIP compression

1️⃣ Backup the Database
```dart
await storage.backup(
  backupDirectory: '/storage/emulated/0/backup',
  archive: true, // Set to false if you don't want ZIP compression
  extension: '.bk', // Custom file extension
  onStatusChanged: (status) => print('Backup Status: $status'),
);
```

2️⃣ Restore the Database

```dart
await storage.restore(
  backupPath: '/storage/emulated/0/backup/data.dbbk.zip',
  onStatusChanged: (status) => print('Restore Status: $status'),
);
```

3️⃣ Enum Status Callbacks

The backup and restore methods provide status updates via callbacks:

🔹 BackupStatus Enum

  - `creatingBackupDirectory` → Creating backup directory
  - `writingBackupFile` → Copying database file
  - `creatingArchive` → Compressing to ZIP (if enabled)
  - `completed` → Backup completed successfully
  - `failed` → Backup failed

🔹 RestoreStatus Enum

  - `readingBackupFile` → Reading backup file
  - `decodingArchive` → Extracting ZIP contents (if applicable)
  - `restoringDatabase` → Copying file to database location
  - `completed` → Restore completed successfully
  - `failed` → Restore failed

4️⃣ Error Handling

If the database file is missing or a backup file is corrupted, an exception will be thrown:
```dart
try {
  await storage.backup(backupDirectory: '/backup');
} catch (e) {
  print('Backup failed: $e');
}
```

📝 Notes

  - Ensure your app has **read/write** storage permissions if saving to external directories.
  - If using **ZIP** compression, the `.zip` file will replace the uncompressed backup.

## 📸 Example Screenshots

|       Home Screen         |          Notes Screen           |   Users Screen         |   Products  Screen         |   Categories Screen         |
| :------------------------: | :--------------------------------: | :--------------------------: | :--------------------------: | :--------------------------: |
| ![Home Screen][home-image] | ![Notes Screen][notes-image] | ![Users Screen][users-image] | ![Products Screen][products-image] | ![Categories Screen][categories-image] |

[home-image]: https://raw.githubusercontent.com/marianz-bonfire/tarsier_local_storage/master/assets/home.png
[notes-image]: https://raw.githubusercontent.com/marianz-bonfire/tarsier_local_storage/master/assets/notes.png
[users-image]: https://raw.githubusercontent.com/marianz-bonfire/tarsier_local_storage/master/assets/users.png
[products-image]: https://raw.githubusercontent.com/marianz-bonfire/tarsier_local_storage/master/assets/products.png
[categories-image]: https://raw.githubusercontent.com/marianz-bonfire/tarsier_local_storage/master/assets/categories.png



## 🎖️ License
This project is licensed under the [MIT License](https://mit-license.org/). See the LICENSE file for details.
## 🐞 Contributing
Contributions are welcome! Please submit a pull request or file an issue for any bugs or feature requests
on [GitHub](https://github.com/marianz-bonfire/tarsier_local_storage).