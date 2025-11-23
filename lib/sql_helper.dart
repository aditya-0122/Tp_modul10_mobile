import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class SQLHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE item (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> db() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'module10.db'),
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTable(database);
      },
    );
  }

  static Future<int> addItem(String title, String? description) async {
    final db = await SQLHelper.db();
    final data = {'title': title, 'description': description};

    final id = await db.insert(
      'item',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> readItem() async {
    final db = await SQLHelper.db();
    return db.query('item', orderBy: "id DESC");
  }


  static Future<int> updateItem(
    int id,
    String title,
    String? description,
  ) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString(), // optional, update waktu
    };

    final result = await db.update(
      'item',
      data,
      where: "id = ?",
      whereArgs: [id],
    );
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    await db.delete('item', where: "id = ?", whereArgs: [id]);
  }
}
