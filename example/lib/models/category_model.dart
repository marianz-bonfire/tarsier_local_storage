import 'package:tarsier_local_storage/tarsier_local_storage.dart';

class Category extends BaseTableModel {
  int? id;
  String name;
  String description;
  int isActive;

  Category({
    this.id,
    required this.name,
    required this.description,
    required this.isActive,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map[CategoryFields.id] as int?,
      name: map[CategoryFields.name] as String,
      description: map[CategoryFields.description] as String,
      isActive: map[CategoryFields.isActive] as int,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      CategoryFields.id: id,
      CategoryFields.name: name,
      CategoryFields.description: description,
      CategoryFields.isActive: isActive,
    };
  }

  static const String tableName = 'categories';

  static Map<String, String> get schema => {
        CategoryFields.id: 'INTEGER PRIMARY KEY',
        CategoryFields.name: 'TEXT NOT NULL',
        CategoryFields.description: 'TEXT',
        CategoryFields.isActive: 'BOOLEAN NOT NULL',
      };
}

class CategoryFields {
  static final List<String> values = [id, name, description, isActive];

  static const String id = 'id';
  static const String name = 'name';
  static const String description = 'description';
  static const String isActive = 'is_active';
}
