import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

List<List<dynamic>> plantDatabase = [
  ["Ampalaya", 6.0, 6.7, 14, 14, 14, 23.9, 26.7, 10],
  ["Atis", 7.0, 8.5, 6, 8, 9, 22.0, 28.0, 70],
  ["Avocado", 5.0, 7.0, 2, 1, 1, 25.0, 33.0, 65],
  ["Bayabas", 4.5, 7.0, 6, 6, 6, 22.7, 27.8, 85],
  ["Bukchoy", 6.5, 7.0, 14, 14, 14, 18.0, 35.0, 95],
  ["Cabbage", 5.6, 7.3, 12, 12, 12, 13.0, 24.0, 92],
  ["Cacao", 5.0, 7.5, 13, 10, 15, 18.0, 32.0, 70],
  ["Caimito", 4.5, 7.5, 8, 3, 9, 22.0, 38.0, 90],
  ["Calamansi", 5.5, 6.5, 8, 2, 10, 20.0, 30.0, 50],
  ["Cassava", 5.5, 6.5, 15, 15, 15, 25.0, 29.0, 60],
  ["Cauliflower", 6.0, 7.0, 5, 10, 10, 15.0, 22.0, 88],
  ["Chico", 6.0, 8.0, 8, 4, 8, 10.0, 38.0, 70],
  ["Corn", 5.8, 6.2, 1, 3, 3, 10.0, 40.0, 90],
  ["Dalandan", 5.5, 7.5, 12, 6, 5, 13.0, 37.0, 90],
  ["Duhat", 5.5, 7.0, 10, 10, 10, 20.0, 32.0, 95],
  ["Durian", 5.0, 6.5, 14, 14, 14, 24.0, 30.0, 80],
  ["Eggplant", 5.5, 7.5, 14, 14, 14, 20.0, 30.0, 90],
  ["Gabi", 5.6, 6.5, 30, 30, 30, 27.0, 29.0, 60],
  ["Garlic", 6.0, 7.0, 12, 2, 44, 13.0, 24.0, 50],
  ["Ginger", 5.5, 6.5, 10, 20, 20, 22.0, 25.0, 90],
  ["Grapes", 5.5, 6.5, 14, 14, 14, 25.0, 34.0, 95],
  ["Guyabano", 4.3, 8.0, 14, 14, 14, 27.0, 32.0, 80],
  ["Jackfruit", 5.0, 6.5, 8, 4, 2, 24.0, 27.0, 95],
  ["Lanzones", 5.5, 6.5, 14, 5, 20, 20.0, 35.0, 83],
  ["Lemon", 5.5, 7.5, 8, 8, 8, 10.0, 28.0, 50],
  ["Mango", 6.0, 7.0, 14, 14, 14, 21.0, 27.0, 50],
  ["Mangosteen", 5.5, 6.8, 16, 16, 16, 20.0, 30.0, 80],
  ["Sampaloc", 4.5, 8.7, 6, 6, 3, 17.0, 36.0, 90],
  ["Santol", 6.0, 7.5, 10, 10, 14, 22.0, 40.0, 80],
  ["Sayote", 5.5, 6.5, 12, 12, 12, 10.0, 25.0, 90],
];

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
    await db.execute('''
    CREATE TABLE plant_Values(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      plantCrop TEXT,
      pHValueMin REAL,
      pHValueMax REAL,
      nitro INTEGER,
      phospo INTEGER,
      potass INTEGER,
      tempMin REAL,
      tempMax REAL,
      humidity INTEGER
      )
    ''');
    insertPlantValues();
  }

  Future<void> insertPlantValues() async {
    final db = await instance.database;

    for (List<dynamic> innerList in plantDatabase) {
      String plantCrop = innerList[0];
      double pHValueMin = innerList[1];
      double pHValueMax = innerList[2];
      int nitro = innerList[3];
      int phospo = innerList[4];
      int potass = innerList[5];
      double tempMin = innerList[6];
      double tempMax = innerList[7];
      int humidity = innerList[8];

      await db.insert(
        'plant_Values',
        {
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
  }

  Future<bool> doesUserExist(String email) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<int> insertUser({
    required String name,
    required String email,
    required String password,
  }) async {
    if (await doesUserExist(email)) {
      // User already exists, handle accordingly (e.g., show error message)
      return -1;
    } else {
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
