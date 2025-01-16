import 'package:tarsier_local_storage/tarsier_local_storage.dart';
import 'package:tarsier_local_storage_example/models/user_model.dart';

class UserTable extends BaseTable<User> {
  UserTable()
      : super(
          tableName: User.tableName,
          schema: User.schema,
          fromMap: (map) => User.fromMap(map),
          toMap: (user) => user.toMap(),
        );
}
