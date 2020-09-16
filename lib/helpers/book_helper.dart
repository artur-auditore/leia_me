import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/book.dart';

class BookHelper{
  static final BookHelper _instance = BookHelper.internal();

  factory BookHelper() => _instance;

  BookHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "book_list.db");

    return openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE Book("
          "id INTEGER PRIMARY KEY, "
          "title TEXT, "
          "author TEXT, "
          "isRead INTEGER)");
    });
  }

  Future<Book> save(Book book) async {
    Database database = await db;
    book.id = await database.insert('book', book.toMap());
    return book;
  }

  Future<Book> getById(int id) async {
    Database database = await db;
    List<Map> maps = await database.query('book',
        columns: ['id', 'title', 'description', 'isDone'],
        where: 'id = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      return Book.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Book>> getAll() async {
    Database database = await db;
    List listMap = await database.rawQuery("SELECT * FROM book");
    List<Book> stuffList = listMap.map((x) => Book.fromMap(x)).toList();
    return stuffList;
  }

  Future<int> update(Book book) async {
    Database database = await db;
    return await database
        .update('Book', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  }

  Future<int> delete(int id) async {
    Database database = await db;
    return await database.delete('book', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database database = await db;
    return await database.rawDelete("DELETE * from book");
  }
}