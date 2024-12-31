import 'package:sqflite/sqflite.dart';
import 'package:tarsier_local_storage/tarsier_local_storage.dart';
import 'package:test/test.dart';

import 'tables/user_table.dart';

void main() {
  group('A group of tests', () {
    Database? database;
    setUp(() async {
      final storage = TarsierLocalStorage();
      database = await storage.init('storage_test.db', [
        UserTable(),
      ]);
    });

    test('First Test', () {
      expect(database!.isOpen, isTrue);
    });
  });
}
