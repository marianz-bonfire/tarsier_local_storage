import 'package:tarsier_local_storage/tarsier_local_storage.dart';
import 'package:flutter_example/models/note_model.dart';

class NoteTable extends BaseTable<Note> {
  NoteTable()
      : super(
          tableName: Note.tableName,
          schema: Note.schema,
          fromMap: (map) => Note.fromMap(map),
          toMap: (user) => user.toMap(),
        );
}
