import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snap/model/database_helper.dart';

//${DatabaseHelper.loggedInUserId}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StreamController<List<Map<String, dynamic>>>
      _recordingsStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  List<Map<String, dynamic>> recordings = [];

  @override
  void initState() {
    super.initState();
    Stream<List<Map<String, dynamic>>> recordingsStream =
        _getLatestRecording('${DatabaseHelper.loggedInUserId}');
    recordingsStream.listen((List<Map<String, dynamic>> data) {
      _recordingsStreamController.add(data);
    });
  }

  Stream<List<Map<String, dynamic>>> _getLatestRecording(String userID) async* {
    final db = await DatabaseHelper.instance.database;
    while (true) {
      final allRows = await db.rawQuery('''
      SELECT r.*, u.name 
      FROM recordings r 
      INNER JOIN users u ON r.user_id = u.id
      WHERE r.user_id = ?
      ORDER BY r.id DESC
    ''', [userID]);
      yield allRows;
      await Future.delayed(const Duration(
          seconds: 1)); // wait for 1 second before querying again
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF518554),
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _recordingsStreamController.stream,
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              recordings = snapshot.data!;
              return SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SingleChildScrollView(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          padding: const EdgeInsets.only(left: 25, bottom: 25),
                          // decoration: BoxDecoration(
                          //   color: Colors.brown.withOpacity(0.6),
                          //   borderRadius: BorderRadius.circular(20),
                          // ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 5),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Your Data',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Manage every data you gathered",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "All Recommendations",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width:
                                      196, // Set the width of the divider here
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1,
                                    height: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 400,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(right: 5),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: recordings.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => Theme(
                                              data: Theme.of(context).copyWith(
                                                dialogBackgroundColor: index %
                                                            2 ==
                                                        0
                                                    ? const Color(0xFFa5885e)
                                                    : const Color(0xFFfed269),
                                              ),
                                              child: AlertDialog(
                                                content: SizedBox(
                                                  height: 380,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                            child: Icon(
                                                              Icons.close,
                                                              color: index %
                                                                          2 ==
                                                                      0
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          'Date of Recording:',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          recordings[index]
                                                              ['date'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          'Time of Recording:',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          recordings[index]
                                                              ['time'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          'pH Value:',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          recordings[index]
                                                              ['ph'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          'NPK:',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${recordings[index]['n']}, ${recordings[index]['p']}, ${recordings[index]['k']} (%)",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          'Humidity:',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          recordings[index]
                                                              ['humidity'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          'Temperature:',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          recordings[index]
                                                              ['temperature'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          'Recommended Plant and Crop:',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${recordings[index]['plant']} and ${recordings[index]['crop']}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 250,
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: index % 2 == 0
                                                ? const Color(0xFFa5885e)
                                                : const Color(0xFFfed269),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Icon(
                                                  Icons.more_horiz_rounded,
                                                  color: index % 2 == 0
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              Center(
                                                child: Image.asset(
                                                  recordings[index]['image'],
                                                  height: 170,
                                                  width: 170,
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Text(
                                                  //recommendations[index]['title'],
                                                  '${recordings[index]['plant']}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: index % 2 == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
