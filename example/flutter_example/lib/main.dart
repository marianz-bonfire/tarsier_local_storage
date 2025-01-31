import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_example/models/user_model.dart';
import 'package:flutter_example/utils/directory_helper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tarsier_local_storage/tarsier_local_storage.dart';

import 'package:flutter_example/tables/tables.dart';
import 'package:flutter_example/ui/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String databaseFile = 'sample.db';
  if (!kIsWeb) {
    var directory = await getApplicationDocumentsDirectory();
    databaseFile = join(directory.path, 'Tarsier', 'sample.db');
  }

  Logger.log('TarsierLocalStorage', 'init function called');
  var storage = TarsierLocalStorage();
  await storage.init(databaseFile, [
    UserTable(),
    NoteTable(),
    ProductTable(),
    CategoryTable(),
  ]);

  final userTable = UserTable();
  Logger.log('TarsierLocalStorage', 'Fetching table ${userTable.tableName}');
  var users = await userTable.all();
  for (var user in users) {
    Logger.info('         ${user.toMap()}');
  }
  Logger.log('TarsierLocalStorage', 'Fetched (${users.length}) users');

  var backupDirectory = await DirectoryHelper.getApplicationPath();
  Logger.log(
      'TarsierLocalStorage', 'Started backup "$backupDirectory" before backup');
  await storage.backup(
    backupDirectory: backupDirectory,
    archive: true,
    onStatusChanged: (status) {
      if (status == BackupStatus.completed) {
        Logger.success('Backup status --> ${status.name}');
      } else if (status == BackupStatus.failed) {
        Logger.error('Backup status --> ${status.name}');
      } else {
        Logger.info('Backup status --> ${status.name}');
      }
    },
  );

  Logger.log('TarsierLocalStorage', 'Adding (5) users');
  for (int i = users.length + 1; i < 5; i++) {
    await userTable.createObject(
      User(
        id: i,
        name: 'Name $i',
        email: 'name$i@gmail.com',
        createdAt: DateTime.now(),
      ),
    );
  }

  Logger.log('TarsierLocalStorage',
      'Fetching table ${userTable.tableName} after adding');
  users = await userTable.all();
  for (var user in users) {
    Logger.info('         ${user.toMap()}');
  }
  Logger.log('TarsierLocalStorage', 'Fetched (${users.length}) users');

  var backupFile = join(backupDirectory, 'sample.bk.zip');
  Logger.log('TarsierLocalStorage', 'Restoring backup $backupFile');
  await storage.restore(
    backupPath: backupFile,
    onStatusChanged: (status) {
      if (status == RestoreStatus.completed) {
        Logger.success('Restore status --> ${status.name}');
      } else if (status == RestoreStatus.failed) {
        Logger.error('Restore status --> ${status.name}');
      } else {
        Logger.info('Restore status --> ${status.name}');
      }
    },
  );

  Logger.log('TarsierLocalStorage',
      'Fetching table ${userTable.tableName} after restoring');
  users = await userTable.all();
  for (var user in users) {
    Logger.info('         ${user.toMap()}');
  }
  Logger.log('TarsierLocalStorage', 'Fetched (${users.length}) users');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
