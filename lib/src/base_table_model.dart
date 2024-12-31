/// An abstract base class for table models used in database operations.
///
/// This class defines the structure and behavior of database models
/// that can be dynamically converted to and from maps for database storage
/// and retrieval.
///
/// Example:
/// ```dart
/// class User extends BaseTableModel {
///   final int id;
///   final String name;
///   final DateTime createdAt;
///
///   User({required this.id, required this.name, required this.createdAt});
///
///   factory User.fromMap(Map<String, dynamic> map) {
///     return User(
///       id: map['id'] as int?,
///       name: map['name'] as String,
///       createdAt: DateTime.parse(map['created_at'] as String),
///     );
///   }
///   @override
///   Map<String, dynamic> toMap() {
///     return {'id': id, 'name': name, 'created_at': createdAt.toIso8601String(),};
///   }
///
///   static const String tableName = 'users';
///
///   static Map<String, String> get schema => {
///     'id': 'INTEGER PRIMARY KEY',
///     'name': 'TEXT',
///     'created_at': 'TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP',
///   };
/// }
/// ```

abstract class BaseTableModel {
  /// Converts the model to a map of key-value pairs.
  ///
  /// This method is used to serialize the model into a format compatible
  /// with database operations. Each concrete implementation must define
  /// how the model is converted into a map.
  ///
  /// Returns a [Map<String, dynamic>] representing the model.
  Map<String, dynamic> toMap();

  /// Retrieves a property value from the model by its name.
  ///
  /// This method allows dynamic access to the model's properties by name,
  /// leveraging the map generated by [toMap].
  ///
  /// - [propertyName]: The name of the property to retrieve.
  ///
  /// Throws an [ArgumentError] if the specified property is not found.
  ///
  /// Returns the value of the property if it exists.
  dynamic get(String propertyName) {
    var map = toMap();
    if (map.containsKey(propertyName)) {
      return map[propertyName];
    }
    throw ArgumentError('Property "$propertyName" not found');
  }
}
