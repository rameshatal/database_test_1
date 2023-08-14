import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDataBase {
  //singleton database class
  AppDataBase._();
  static final AppDataBase db = AppDataBase._();

  //database variable
  Database? _database;
  //note(
  static final   NOTE_TEBLE = "note";
  static final   NOTE_COLUMN_ID = "note_id";
  static final   NOTE_COLUMN_TITLE = "title";
  static final   NOTE_COLUMN_DESC = "desc";



  Future<Database> getDB() async {
    if (_database != null) {
      return _database!;
    } else {
      return await initDB();
    }
  }

  Future<Database> initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    var dbPath = join(documentDirectory.path, "NoteDB.db");
    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      //create tables here
      db.execute(
          "Create table $NOTE_TEBLE ( $NOTE_COLUMN_ID integer primary key autoincrement, $NOTE_COLUMN_TITLE, $NOTE_COLUMN_DESC )");
    });
  }

  Future<bool> addNote(String title, String desc) async {
    var db = await getDB();

    int rowsEffect = await db.insert(NOTE_TEBLE, {NOTE_COLUMN_TITLE: title, NOTE_COLUMN_DESC: desc});
    if (rowsEffect>0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllNotes() async {
    var db = await getDB();

    List<Map<String, dynamic>> notes = await db.query(NOTE_TEBLE);
    return notes;
  }
}
