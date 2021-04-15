import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:voucomprei/models/item_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String itemTable = 'tb_item';
  String colId = 'id';
  String colDescription = 'description';
  String colAmount = 'amount';
  String colUnity = 'unity';
  String colStatus = 'status';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'vou_comprei.db';
    final vouCompreiDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return vouCompreiDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $itemTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDescription TEXT, $colAmount TEXT, $colUnity TEXT, $colStatus INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getItemMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(itemTable);
    return result;
  }

  Future<List<Item>> getItemList() async {
    final List<Map<String, dynamic>> itemMapList = await getItemMapList();
    final List<Item> itemList = [];
    itemMapList.forEach((itemMap) {
      itemList.add(Item.fromMap(itemMap));
    });
    return itemList;
  }

  Future<int> insertItem(Item item) async {
    Database db = await this.db;
    final int result = await db.insert(itemTable, item.toMap());
    return result;
  }

  Future<int> updateItem(Item item) async {
    Database db = await this.db;
    final int result = await db.update(
      itemTable, 
      item.toMap(),
      where: '$colId = ?',
      whereArgs: [item.id]
    );
    return result;
  }

  Future<int> deleteItem(int id) async{
    Database db = await this.db;
    final int result = await db.delete(
      itemTable,
      where: '$colId = ?',
      whereArgs: [id]
    );
    return result;
  }
}
