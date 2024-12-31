import 'package:tarsier_local_storage/src/base_table.dart';

import '../models/user.dart';

class UserTable extends BaseTable<User> {
  UserTable()
      : super(
          tableName: User.tableName,
          schema: User.schema,
          fromMap: (map) => User.fromMap(map),
          toMap: (endpoint) => endpoint.toMap(),
        );
}
