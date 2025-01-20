import 'package:tarsier_local_storage/tarsier_local_storage.dart';

class Note extends BaseTableModel {
  final int? id;
  final String title;
  final String description;
  final int number;
  final int isImportant;
  final DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.number,
    required this.isImportant,
    required this.createdAt,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map[NoteFields.id] as int?,
      title: map[NoteFields.title] as String,
      description: map[NoteFields.description] as String,
      number: map[NoteFields.number] as int,
      isImportant: map[NoteFields.isImportant] as int,
      createdAt: DateTime.parse(map[NoteFields.createdAt] as String),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      NoteFields.id: id,
      NoteFields.title: title,
      NoteFields.description: description,
      NoteFields.number: number,
      NoteFields.isImportant: isImportant,
      NoteFields.createdAt: createdAt.toIso8601String(),
    };
  }

  Note copy({
    int? id,
    int? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdAt,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
      );

  static const String tableName = 'notes';

  static Map<String, String> get schema => {
        NoteFields.id: 'INTEGER PRIMARY KEY',
        NoteFields.title: 'TEXT',
        NoteFields.description: 'TEXT',
        NoteFields.number: 'INTEGER NOT NULL',
        NoteFields.isImportant: 'BOOLEAN NOT NULL',
        NoteFields.createdAt: 'TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP',
      };
}

class NoteFields {
  static final List<String> values = [
    id,
    isImportant,
    number,
    title,
    description,
    createdAt
  ];

  static const String id = 'id';
  static const String isImportant = 'is_important';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String createdAt = 'created_at';
}
