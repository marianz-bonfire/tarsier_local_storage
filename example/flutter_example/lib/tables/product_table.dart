import 'package:tarsier_local_storage/tarsier_local_storage.dart';
import 'package:flutter_example/models/product_model.dart';

class ProductTable extends BaseTable<Product> {
  ProductTable()
      : super(
          tableName: Product.tableName,
          schema: Product.schema,
          fromMap: (map) => Product.fromMap(map),
          toMap: (user) => user.toMap(),
        );
}
