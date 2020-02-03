
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practice/data/book.dart';
import 'package:sqflite/sqflite.dart';

class BookDatabase{
  static final BookDatabase _instance = BookDatabase._();
  static Database _database;
  BookDatabase._();

  factory BookDatabase(){
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null){
      return _database;
    }
    _database = await init();

    return _database;
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, "bookDatabase.db");
    var database = openDatabase(dbPath, version: 2, onCreate: _onCreate);
    return database;

  }

  void _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE IF NOT EXISTS books(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        date TEXT)      
      ''');
    print("Database created!");
  }


  Future<List<Book>> books() async {
    print("Get books from db");
    final Database database = await db;
    final List<Map<String, dynamic>> maps = await database.query('books');
    return List.generate(maps.length,(i){
      return Book.withDetails(
          id: maps[i]['id'],
          title: maps[i]["title"],
          creationDate: DateTime.parse(maps[i]["creationDate"])
      );
    });
  }


  Future<int> insertBook(Book book) async {
    // Get a reference to the database.
    final Database database = await db;
    final id = await database.insert(
      'books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Database insert id =  "+ id.toString());
    return id;
  }

  void deleteBooksTable() async{
    var client = await db;
    await client.delete(
      'books',
    );
  }

  Future closeDb() async {
    var database = await db;
    database.close();
  }

}