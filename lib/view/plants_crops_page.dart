import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snap/model/database_helper.dart';

class PlantsCropsPage extends StatefulWidget {
  const PlantsCropsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PlantsCropsPageState createState() => _PlantsCropsPageState();
}

class _PlantsCropsPageState extends State<PlantsCropsPage> {
  final StreamController<List<Map<String, dynamic>>>
      _recordingsStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  List<Map<String, dynamic>> plantsCrops = [];

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
      SELECT * FROM plant_Values
    ''');
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
                plantsCrops = snapshot.data!;
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
                              padding: const EdgeInsets.only(
                                left: 25,
                                right: 25,
                                bottom: 25,
                              ),
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
                                      "Plants and Crops",
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
                                      "List of plants and crops you can grow in your land",
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
                                      "All Plants and Crops",
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
                                          179, // Set the width of the divider here
                                      child: Divider(
                                        color: Colors.white,
                                        thickness: 1,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    height: 500,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: plantsCrops.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    dialogBackgroundColor:
                                                        index % 2 == 0
                                                            ? const Color(
                                                                0xFFa5885e)
                                                            : const Color(
                                                                0xFFfed269),
                                                  ),
                                                  child: AlertDialog(
                                                    content: SizedBox(
                                                      height: 320,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  Alignment
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
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'pH Value:',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: index %
                                                                            2 ==
                                                                        0
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              "${plantsCrops[index]['pHValueMin'].toString()} to ${plantsCrops[index]['pHValueMax'].toString()}",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: index %
                                                                            2 ==
                                                                        0
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'NPK:',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: index %
                                                                            2 ==
                                                                        0
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              "${plantsCrops[index]['nitro'].toString()}, ${plantsCrops[index]['phospo'].toString()}, ${plantsCrops[index]['potass'].toString()}",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: index %
                                                                            2 ==
                                                                        0
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Humidity:',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: index %
                                                                            2 ==
                                                                        0
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              plantsCrops[index]
                                                                      [
                                                                      'humidity']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: index %
                                                                            2 ==
                                                                        0
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Temperature:',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: index %
                                                                            2 ==
                                                                        0
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              "${plantsCrops[index]['tempMin'].toString()}°C to ${plantsCrops[index]['tempMax'].toString()}°C",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: index %
                                                                            2 ==
                                                                        0
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                                Center(
                                                              child: ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text('Start Adjusting'),
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
                                              width: 450,
                                              padding: const EdgeInsets.all(16),
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
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Icon(
                                                      Icons.more_horiz_rounded,
                                                      color: index % 2 == 0
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Text(
                                                      plantsCrops[index]
                                                          ['plantCrop'],
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                          )),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
