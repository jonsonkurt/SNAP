import 'dart:ffi';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;
  static int? loggedInUserId;
  static String? loggedInUserName;
  static String? loggedInUserEmail;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('snap.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        password TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE recordings(
        id INTEGER PRIMARY KEY,
        user_id TEXT,
        date TEXT,
        time TEXT,
        ph TEXT,
        n TEXT,
        p TEXT,
        k TEXT,
        humidity TEXT,
        temperature TEXT,
        plant TEXT,
        crop TEXT,
        image TEXT
      )
    ''');
  }

  Future<int> insertUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final db = await database;

    return await db.insert(
      'users',
      {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;

    return await db.query('users');
  }

  Future<bool> isUserExist(String email, String password) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    return result.isNotEmpty;
  }

  Future<bool> updatePassword(
      String email, String newPassword, String confirmNewPassword) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isEmpty) {
      return false;
    }

    final user = result.first;

    if (newPassword != confirmNewPassword) {
      return false;
    }

    final rowsAffected = await db.update(
      'users',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [user['id']],
    );

    return rowsAffected > 0;
  }

  Future<int> insertRecording({
    required String userId,
    required String date,
    required String time,
    required String ph,
    required String n,
    required String p,
    required String k,
    required String humidity,
    required String temperature,
    required String plant,
    required String crop,
    String? image,
  }) async {
    final db = await database;

    return await db.insert(
      'recordings',
      {
        'user_id': userId,
        'date': date,
        'time': time,
        'ph': ph,
        'n': n,
        'p': p,
        'k': k,
        'humidity': humidity,
        'temperature': temperature,
        'plant': plant,
        'crop': crop,
        'image': 'assets/images/${plant.toLowerCase()}.png',
      },
    );
  }

  Future<int> plantValues({
    required String plantCrop,
    required double pHValueMin,
    required double pHValueMax,
    required int nitro,
    required int phospo,
    required int potass,
    required double tempMin,
    required double tempMax,
    required int humidity,
  }) async {
    final db = await database;

    return await db.insert(
      'plant_Values',
      {
        'id INTEGER PRIMARY KEY,'
        'plantCrop': plantCrop,
        'pHValueMin': pHValueMin,
        'pHValueMax': pHValueMax,
        'nitro': nitro,
        'phospo': phospo,
        'potass': potass,
        'tempMin': tempMin,
        'tempMax': tempMax,
        'humidity': humidity,
      },
    );
  }

  queryAllRows() {}
}
