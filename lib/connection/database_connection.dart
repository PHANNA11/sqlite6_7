import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:sqlite6_7/models/person_model.dart';

String table = 'person';

class DataConnection {
  Future<Database> initializeData() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'data.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE $table(id INTEGER PRIMARY KEY, name TEXT,sex TEXT, age  INTEGER,image TEXT)');
      },
    );
  }

  Future<void> insertData(Person person) async {
    final db = await initializeData();
    await db.insert(table, person.toMap());
    print('object was insert to database');
  }

  Future<List<Person>> getPersonData() async {
    final db = await initializeData();
    List<Map<String, dynamic>> result = await db.query(table);
    return result.map((e) => Person.fromMap(e)).toList();
  }
  // Future<Person> getPerObjectList()

  Future<void> deletePersonData(int id) async {
    final db = await initializeData();
    await db.delete(table, where: 'id=?', whereArgs: [id]);
  }

  Future<void> updatePersonData(Person person) async {
    final db = await initializeData();
    await db
        .update(table, person.toMap(), where: 'id=?', whereArgs: [person.id]);
  }
}
