import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

String table = 'person';

class DataConnection {
  Future<Database> initializeData() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
// Get a location using getDatabasesPath
    String path = await getDatabasesPath();

    return openDatabase(join(path, 'data.db'));
  }
}
