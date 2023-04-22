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
  List<Map<String, dynamic>> recommendations = [
    {
      'image': 'assets/images/tomato.png',
      'title': 'Tomato',
      'date': '22-04-2023',
      'time': '13:15',
      'ph': '7',
      'npk': '14, 13, 10 (%)',
      'humidity': '60%',
      'temperature': '22°C',
      'plants': 'Tomato and Wheat',
    },
    {
      'image': 'assets/images/avocado.png',
      'title': 'Avocado',
      'date': '23-04-2023',
      'time': '14:30',
      'ph': '6.5',
      'npk': '10, 10, 10 (%)',
      'humidity': '70%',
      'temperature': '20°C',
      'plants': 'Avocado and Beetroot',
    },
    // add more items here...
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF518554),
      body: SafeArea(
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
                          width: 196, // Set the width of the divider here
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
                          itemCount: recommendations.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => Theme(
                                      data: Theme.of(context).copyWith(
                                        dialogBackgroundColor: index % 2 == 0
                                            ? const Color(0xFFa5885e)
                                            : const Color(0xFFfed269),
                                      ),
                                      child: AlertDialog(
                                        content: SizedBox(
                                          height: 380,
                                          child: Container(
                                            padding: const EdgeInsets.all(15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: GestureDetector(
                                                    onTap: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: index % 2 == 0
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Date of Recording:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: index % 2 == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  recommendations[index]
                                                      ['date'],
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: index % 2 == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Time of Recording:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: index % 2 == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  recommendations[index]
                                                      ['time'],
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: index % 2 == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'pH Value:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: index % 2 == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  recommendations[index]['ph'],
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: index % 2 == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'NPK:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: index % 2 == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  recommendations[index]['npk'],
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: index % 2 == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Humidity:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: index % 2 == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  recommendations[index]
                                                      ['humidity'],
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: index % 2 == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Temperature:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: index % 2 == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  recommendations[index]
                                                      ['temperature'],
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: index % 2 == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Recommended Plant and Crop:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: index % 2 == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  recommendations[index]
                                                      ['plants'],
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: index % 2 == 0
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
                                    borderRadius: BorderRadius.circular(20),
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
                                          recommendations[index]['image'],
                                          height: 170,
                                          width: 170,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          recommendations[index]['title'],
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
      ),
    );
  }
}
