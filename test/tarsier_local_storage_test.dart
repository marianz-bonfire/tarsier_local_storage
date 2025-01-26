import 'package:flutter_test/flutter_test.dart';

import 'package:tarsier_local_storage/tarsier_local_storage.dart';

void main() {
  test('Checking storage connection', () async {
    final storage = TarsierLocalStorage();
    expect((await storage.database).isOpen, true);
  });
}
