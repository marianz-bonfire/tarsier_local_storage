import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tarsier_local_storage/tarsier_local_storage.dart';
import 'package:tarsier_local_storage_example/tables/category_table.dart';
import 'package:tarsier_local_storage_example/tables/note_table.dart';
import 'package:tarsier_local_storage_example/tables/product_table.dart';
import 'package:tarsier_local_storage_example/tables/user_table.dart';
import 'package:tarsier_local_storage_example/ui/screens/home_screen.dart';

import 'models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var directory = await getApplicationDocumentsDirectory();
  await TarsierLocalStorage()
      .init(join(directory!.path, 'Tarsier', 'sample.db'), [
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
