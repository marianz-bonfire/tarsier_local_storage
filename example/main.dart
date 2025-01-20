import 'package:tarsier_local_storage/tarsier_local_storage.dart';

void main() async {
  await TarsierLocalStorage().init('app.db', [
    UserTable(), // Table class extended by BaseTable
  ]);

  final userTable = UserTable();

  // Add a new user
  await userTable.createObject(User(
      id: 1,
      name: 'John Doe',
      email: 'john@gmail.com',
      createdAt: DateTime.now()));
  // Or using Map on creating new user
  await userTable.create({
    'id': 1,
    'name': 'John Doe',
    'email': 'john@gmail.com',
  });

  // Retrieve all users
  final users = await userTable.all();
  for (var user in users) {
    print(user.name);
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
