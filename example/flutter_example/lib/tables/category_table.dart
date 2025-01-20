import 'package:tarsier_local_storage/tarsier_local_storage.dart';
import 'package:flutter_example/models/category_model.dart';

class CategoryTable extends BaseTable<Category> {
  CategoryTable()
      : super(
          tableName: Category.tableName,
          schema: Category.schema,
          fromMap: (map) => Category.fromMap(map),
          toMap: (user) => user.toMap(),
        );
}
