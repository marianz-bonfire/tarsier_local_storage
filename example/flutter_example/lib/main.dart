import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  await TarsierLocalStorage().init(databaseFile, [
    UserTable(),
    NoteTable(),
    ProductTable(),
    CategoryTable(),
  ]);

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
