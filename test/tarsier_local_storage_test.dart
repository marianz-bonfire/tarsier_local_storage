import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';

import 'package:tarsier_local_storage/tarsier_local_storage.dart';

Future<void> main() async {
  final storage = TarsierLocalStorage();

  const databaseFile = 'data.db';
  const databaseBackup = 'data.bk';
  const backupFolder = 'backup';
  final databaseBackupFile = join(backupFolder, databaseBackup);
  await storage.init(databaseFile, [UserTable()]);

  test('Initializing database', () async {
    expect(storage.databaseFile, isNull);

    expect(await storage.databaseFile!.exists(), isTrue);
  });

  test('Checking storage connection', () async {
    expect((await storage.database).isOpen, isTrue);
  });

  test('Checking backup file before backup', () async {
    expect(await File(databaseBackupFile).exists(), isFalse);
  });

  test('Storage backup', () async {
    storage.backup(backupDirectory: backupFolder);
    expect(await File(databaseBackupFile).exists(), isFalse);
  });
  var userTable = UserTable();
  test('Initializing User table', () async {
    expect(userTable.tableName, 'users');
  });

  test('Initializing User table', () async {
    var users = await userTable.all();
    expect(users.length, 0);
  });
}

class UserTable extends BaseTable<User> {
  UserTable()
      : super(
          tableName: User.tableName,
          schema: User.schema,
          fromMap: (map) => User.fromMap(map),
          toMap: (user) => user.toMap(),
        );
}

class User extends BaseTableModel {
  final int? id;
  final String name;
  final String email;
  final DateTime createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static const String tableName = 'users';

  static Map<String, String> get schema => {
        'id': 'INTEGER PRIMARY KEY',
        'name': 'TEXT',
        'email': 'TEXT',
        'created_at': 'TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP',
      };
}
