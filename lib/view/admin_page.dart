import 'package:flutter/material.dart';
import 'package:snap/model/database_helper.dart';

List<List<dynamic>> plantDatabase = [
  ["Ampalaya", 6.0,6.7,14,14,14,23.9,26.7,10],
  ["Atis", 7.0,8.5, 6, 8, 9,22.0,28.0, 70],
  ["Avocado", 5.0,7.0, 2, 1, 1, 25.0,33.0, 65],
  ["Bayabas", 4.5,7.0, 6, 6, 6, 22.7,27.8, 85],
  ["Bukchoy", 6.5,7.0, 14, 14, 14, 18.0,35.0, 95],
  ["Cabbage", 5.6,7.3, 12, 12, 12, 13.0,24.0, 92],
  ["Cacao", 5.0,7.5, 13, 10, 15, 18.0,32.0, 70],
  ["Caimito", 4.5,7.5, 8, 3, 9, 22.0,38.0, 90],
  ["Calamansi", 5.5,6.5, 8, 2, 10, 20.0,30.0, 50],
  ["Cassava", 5.5,6.5, 15, 15, 15, 25.0,29.0, 60],
  ["Cauliflower", 6.0,7.0, 5, 10, 10, 15.0,22.0, 88],
  ["Chico", 6.0,8.0, 8, 4, 8, 10.0,38.0, 70],
  ["Corn", 5.8,6.2, 1, 3, 3, 10.0,40.0, 90],
  ["Dalandan", 5.5,7.5, 12, 6, 5, 13.0,37.0, 90],
  ["Duhat", 5.5,7.0, 10, 10, 10, 20.0,32.0, 95],
  ["Durian", 5.0,6.5, 14, 14, 14, 24.0,30.0, 80],
  ["Eggplant", 5.5,7.5, 14, 14, 14, 20.0,30.0, 90],
  ["Gabi", 5.6,6.5, 30, 30, 30, 27.0,29.0, 60],
  ["Garlic", 6.0,7.0, 12, 2, 44, 13.0,24.0, 50],
  ["Ginger", 5.5,6.5, 10, 20, 20, 22.0,25.0, 90],
  ["Grapes", 5.5,6.5, 14, 14, 14, 25.0,34.0, 95],
  ["Guyabano", 4.3,8.0, 14, 14, 14, 27.0,32.0, 80],
  ["Jackfruit", 5.0,6.5, 8, 4, 2, 24.0,27.0, 95],
  ["Lanzones", 5.5,6.5, 14, 5, 20, 20.0,35.0, 83],
  ["Lemon", 5.5,7.5, 8, 8, 8, 10.0,28.0, 50],
  ["Mango", 6.0,7.0, 14, 14, 14, 21.0,27.0, 50],
  ["Mangosteen", 5.5,6.8, 16, 16, 16, 20.0,30.0, 80],
  ["Sampaloc", 4.5,8.7, 6, 6, 3, 17.0,36.0, 90],
  ["Santol", 6.0,7.5, 10, 10, 14, 22.0,40.0, 80],
  ["Sayote", 5.5,6.5, 12, 12, 12, 10.0,25.0, 90],
  ];

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Map<String, dynamic>> recordings = [];

  @override
  void initState() {
    super.initState();
    _getAllRecordings();
    insertPlantValues();
  }

  Future<void> _getAllRecordings() async {
    final db = await DatabaseHelper.instance.database;
    final allRows = await db.rawQuery('''
      SELECT r.*, u.name 
      FROM recordings r 
      INNER JOIN users u ON r.user_id = u.id
      ORDER BY r.date DESC, r.time DESC
    ''');
    setState(() {
      recordings = allRows;
    });
  }

Future<void> insertPlantValues() async {
  final db = await DatabaseHelper.instance.database;

  // Create the table if it doesn't exist
  await db.execute('''
    CREATE TABLE IF NOT EXISTS Plant_Values (
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        backgroundColor: const Color(0xFFa5885e),
      ),
      backgroundColor: const Color(0xFF518554),
      body: ListView.builder(
        itemCount: recordings.length,
        itemBuilder: (BuildContext context, int index) {
          final recording = recordings[index];
          return Card(
            color: const Color(0xFFfed269),
            elevation: 2.0,
            margin: const EdgeInsets.only(left: 25, right: 25, top: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFfed269),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        '${recording['plant']} - ${recording['crop']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Text(
                        'Recorded on ${recording['date']} at ${recording['time']} by ${recording['name']}',
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'pH: ${recording['ph']}',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'NPK: ${recording['n']}, ${recording['p']}, ${recording['k']} (%)',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'Hmd: ${recording['humidity']}',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'Temp: ${recording['temperature']}',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
