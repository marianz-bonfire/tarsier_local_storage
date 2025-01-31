import 'package:path/path.dart';
import 'package:tarsier_local_storage/tarsier_local_storage.dart';

void main() async {
  // Initialize local storage
  var storage = TarsierLocalStorage();
  await storage.init('sample.db', [
    UserTable(), // Table class extended by BaseTable
  ]);

  final userTable = UserTable();

  // Fetching table before backup
  var users = await userTable.all();
  for (var user in users) {
    print('${user.toMap()}');
  }

  // Backup database
  var backupDirectory = 'backup';
  await storage.backup(
    backupDirectory: backupDirectory,
    archive: true,
    onStatusChanged: (status) {
      print(status.name);
    },
  );

  // Adding (5) users
  for (int i = users.length + 1; i < 5; i++) {
    await userTable.createObject(
      User(
        id: i,
        name: 'Name $i',
        email: 'name$i@gmail.com',
        createdAt: DateTime.now(),
      ),
    );
  }

  // Fetching table after adding
  users = await userTable.all();
  for (var user in users) {
    print('${user.toMap()}');
  }

  // Restoring backup
  var backupFile = join(backupDirectory, 'sample.bk.zip');
  await storage.restore(
    backupPath: backupFile,
    onStatusChanged: (status) {
      print(status.name);
    },
  );

  // Fetching table users after restoring
  users = await userTable.all();
  for (var user in users) {
    print('${user.toMap()}');
  }
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
