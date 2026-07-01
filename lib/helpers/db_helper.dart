import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/service.dart';

class DBHelper {
  // Membuka (atau membuat) database lokal SQLite
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath(); // Mendapatkan path direktori database
    return openDatabase(
      join(dbPath, 'service.db'), // Lokasi database
      version: 2,
      onCreate: (db, version) {
        // Membuat tabel services saat database pertama kali dibuat
        return db.execute(
          'CREATE TABLE services('
          'id INTEGER PRIMARY KEY, '
          'nama_barang TEXT, '
          'kerusakan TEXT, '
          'spesifikasi TEXT, '
          'pemilik TEXT, '
          'status TEXT, '
          'tanggal_masuk TEXT, '
          'tanggal_selesai TEXT, '
          'image_path TEXT'
          ')',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Menghapus tabel lama dan membuat ulang saat versi database berubah
        await db.execute('DROP TABLE IF EXISTS services');
        await db.execute(
          'CREATE TABLE services('
          'id INTEGER PRIMARY KEY, '
          'nama_barang TEXT, '
          'kerusakan TEXT, '
          'spesifikasi TEXT, '
          'pemilik TEXT, '
          'status TEXT, '
          'tanggal_masuk TEXT, '
          'tanggal_selesai TEXT, '
          'image_path TEXT'
          ')',
        );
      },
    );
  }

  // Menambahkan data servis baru ke dalam database
  static Future<void> insertService(Service service) async {
    final db = await DBHelper.database();
    await db.insert(
      'services',
      service.toJson(), // Konversi objek Service ke Map
      conflictAlgorithm: ConflictAlgorithm.replace, // Ganti jika id sudah ada
    );
  }

  // Mengambil semua data servis dari database
  static Future<List<Service>> getServices() async {
    final db = await DBHelper.database();
    final data = await db.query('services');
    return data.map((e) => Service.fromJson(e)).toList(); // Konversi dari Map ke objek Service
  }

  // Memperbarui data servis berdasarkan ID
  static Future<void> updateService(Service service) async {
    final db = await DBHelper.database();
    await db.update(
      'services',
      service.toJson(),
      where: 'id = ?',
      whereArgs: [service.id], // Berdasarkan ID
    );
  }

  // Menghapus data servis berdasarkan ID
  static Future<void> deleteService(int id) async {
    final db = await DBHelper.database();
    await db.delete(
      'services',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Menampilkan seluruh isi tabel services di console (untuk debugging)
  static Future<void> printAllServices() async {
    final db = await DBHelper.database();
    final data = await db.query('services');
    for (var row in data) {
      print(row);
    }
  }
}
