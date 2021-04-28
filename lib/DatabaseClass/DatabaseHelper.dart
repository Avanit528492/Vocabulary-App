import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'Details.dart';


class DatabaseHelper{

  Database _database;
  static final String databasename = "Vocabulary.db";
  static final int databaseversion = 1;
  static final String table = "Vocabulary";
  static final String colid = 'id';
  static final String colspell = 'spell';
  static final String colmeaning = 'meaning';
  static final String colsynonyms = 'synonyms';

  DatabaseHelper();
  DatabaseHelper._instance();
  static DatabaseHelper instance = DatabaseHelper._instance();

  Future<Database> get database async
  {
    if(_database == null)
      {
        return initsetDatabase();
      }
    return _database;

  }

  static Future<Database> initsetDatabase() async{
    Directory _directory = await getApplicationDocumentsDirectory();
    String path = join(_directory.path , table);
    var createdatabase = await openDatabase(path,version: databaseversion , onCreate: _onCreate
    );
    return createdatabase;
  }

  static void _onCreate(Database db , int version) async
  {
    await db.execute('CREATE TABLE $table ($colid INTEGER PRIMARY KEY AUTOINCREMENT'
        ' , $colspell TEXT , $colmeaning TEXT , $colsynonyms TEXT)');
  }

  static Future<int> insert_Data(Details details) async
  {
    Database db = await instance.database;
    int result =  await db.rawInsert('INSERT INTO $table ($colspell , $colmeaning'
        ' , $colsynonyms) VALUES(?,?,?)',[details.spell,details.meaning,details.synonyms]);
    return result;
  }

 static Future<int> update_Data(Details details , int id) async
  {
    Database db = await instance.database;
    int result = await db.rawUpdate('UPDATE $table SET $colspell = ? , $colmeaning = ?,'
        '$colsynonyms = ? WHERE $colid = ?',[details.spell , details.meaning , details.synonyms,id]);
    return result;
  }

 static Future<int> delet_Data(int id) async
  {
    Database db = await instance.database;
    int result = await db.rawDelete('DELETE FROM $table WHERE $colid = $id');
    return result;
  }

 static Future<int> getCount() async{
    Database db = await instance.database;
    List<Map<String , dynamic>> result = await db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(result);
  }

  static Future<List<Map<String , dynamic>>> _getDataFromTable() async
  {
    Database db = await instance.database;
    List<Map<String , dynamic>> result = await db.rawQuery('SELECT * FROM $table');
    return result;
  }

  static Future<List<Details>> getValueToObject() async
  {
    List<Map<String , dynamic>> value = await _getDataFromTable();

    List<Details> listData = List();
    int length = value.length;

    for(int i=0; i<length; i++)
      {
        listData.add(Details.formMapToObject(value[i]));
      }
    return listData;
  }





}