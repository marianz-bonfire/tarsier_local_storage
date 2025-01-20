import 'package:tarsier_local_storage/tarsier_local_storage.dart';

class Product extends BaseTableModel {
  int? id;
  String name;
  String description;
  double price;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map[ProductFields.id] as int?,
      name: map[ProductFields.name] as String,
      description: map[ProductFields.description] as String,
      price: map[ProductFields.price] as double,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ProductFields.id: id,
      ProductFields.name: name,
      ProductFields.description: description,
      ProductFields.price: price,
    };
  }

  static const String tableName = 'products';

  static Map<String, String> get schema => {
        ProductFields.id: 'INTEGER PRIMARY KEY',
        ProductFields.name: 'TEXT NOT NULL',
        ProductFields.description: 'TEXT',
        ProductFields.price: 'REAL NOT NULL',
      };
}

class ProductFields {
  static final List<String> values = [id, name, description, price];

  static const String id = 'id';
  static const String name = 'name';
  static const String description = 'description';
  static const String price = 'price';
}
