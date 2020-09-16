import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import '../model/code.dart';

class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String codeTable = "code_table";
  int version = 1;
  String colId = "id";
  String colType = "type";
  String colTitle = "title";
  String colResult = "result";

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if(_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  // Create operation
  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "codes.db";
    
    var noteDatabase = await openDatabase(path, version: version, onCreate: _createDB);
    return noteDatabase;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $codeTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colType INTEGER, $colTitle TEXT, $colResult TEXT)");
  }

  // Read all operation
  Future<List<Code>> getCodeList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.query(codeTable, orderBy: "$colId DESC");

    List<Code> noteList = List<Code>();
    result.forEach((codeMap) => noteList.add(Code.fromMapObject(codeMap)));
    return noteList;
  }

  // Read one operation
  Future<Code> getCode(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.query(codeTable, where: "$colId = ?", whereArgs: [id]);
    return Code.fromMapObject(result[0]);
  }

  // Insert operation [return id]
  Future<int> insertCode(Code code) async {
    Database db = await this.database;
    return await db.insert(codeTable, code.toMap());
  }

  // Update operation [return number of changes]
  Future<int> updateCode(Code code) async {
    Database db = await this.database;
    return await db.update(codeTable, code.toMap(), where: "$colId = ?", whereArgs: [code.id]);
  }

  // Delete operation [return number of changes]
  Future<int> deleteCode(int id) async {
    Database db = await this.database;
    //var result = await db.delete(noteTable, where: "$colId = $id");
    return await db.rawDelete("DELETE FROM $codeTable WHERE $colId = $id");
  }

  // Number of note objects
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery("SELECT COUNT (*) from $codeTable");
    return Sqflite.firstIntValue(x);
  }
}