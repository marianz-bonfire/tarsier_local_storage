import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:path_provider/path_provider.dart';

class DirectoryHelper {
  static Future<String> getApplicationPath() async {
    String path = '';
    if (Platform.isAndroid) {
      var directory =
          await getDownloadsDirectory() ?? await getExternalStorageDirectory();
      path = directory!.path;
    } else {
      var directory = await getApplicationDocumentsDirectory();
      path = directory.path;
    }
    String applicationPath = p.join(path, 'Tarsier-Test');
    createDirectory(applicationPath);

    return applicationPath;
  }

  static createDirectory(path) async {
    if (!await Directory(path).exists()) {
      await Directory(path).create(recursive: true);
    }
  }
}
