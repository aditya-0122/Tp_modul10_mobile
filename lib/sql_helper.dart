import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class SQLHelper {
  
  // Sesuai permintaan tugas: createTable()
  // Fungsi ini membuat tabel. Saya akan beri nama tabel 'items'
  // dengan kolom 'title' dan 'description' sesuai contoh UI.
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE items (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  // Sesuai permintaan tugas: db()
  // Fungsi ini akan membuka (atau membuat) database.
  static Future<sql.Database> db() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'module10.db'), // Nama database
      version: 1,
      onCreate: (sql.Database database, int version) async {
        // Panggil createTable saat database pertama kali dibuat
        await createTable(database);
      },
    );
  }

  // Sesuai permintaan tugas: addItem() (Fitur CREATE)
  // Menambahkan data baru ke tabel 'items'.
  static Future<int> addItem(String title, String? description) async {
    final db = await SQLHelper.db(); // Buka database

    final data = {'title': title, 'description': description};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Sesuai permintaan tugas: readItem() (Fitur READ)
  // Mengambil seluruh data dari tabel 'items'.
  static Future<List<Map<String, dynamic>>> readItems() async {
    final db = await SQLHelper.db(); // Buka database
    return db.query('items', orderBy: "id DESC"); // Urutkan dari yg terbaru
  }
}