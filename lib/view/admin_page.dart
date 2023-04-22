import 'package:flutter/material.dart';
import 'package:snap/model/database_helper.dart';

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
  }

  Future<void> _getAllRecordings() async {
    final db = await DatabaseHelper.instance.database;
    final allRows = await db.rawQuery('''
      SELECT r.*, u.name 
      FROM recordings r 
      INNER JOIN users u ON r.user_id = u.id
      ORDER BY u.name ASC, r.date DESC, r.time DESC
    ''');
    setState(() {
      recordings = allRows;
    });
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
