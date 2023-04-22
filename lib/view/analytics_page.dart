import 'package:flutter/material.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<Map<String, dynamic>> recommendations = [
    // {
    //   'image': 'assets/images/tomato.png',
    //   'title': 'Tomato',
    //   'date': '22-04-2023',
    //   'time': '13:15',
    //   'ph': '8.5',
    //   'npk': '14, 13, 10 (%)',
    //   'humidity': '60%',
    //   'temperature': '22°C',
    //   'plants': 'Tomato and Wheat',
    //   'plant': 'Tomato',
    //   'crop': 'Wheat',
    // },
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
      'plant': 'Avocado',
      'crop': 'Beetroot',
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
                        "Analytics",
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
                        "Your latest gathered soil qualities",
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
                        "All Values",
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
                        width: 87, // Set the width of the divider here
                        child: Divider(
                          color: Colors.white,
                          thickness: 1,
                          height: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.45,
                          height: MediaQuery.of(context).size.height / 6,
                          padding: const EdgeInsets.only(left: 25, right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFa5885e),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "pH",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  recommendations[0]['ph'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.speed_rounded,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.45,
                          height: MediaQuery.of(context).size.height / 6,
                          padding: const EdgeInsets.only(left: 25, right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFa5885e),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "NPK",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  recommendations[0]['npk'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.eco_rounded,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.45,
                          height: MediaQuery.of(context).size.height / 6,
                          padding: const EdgeInsets.only(left: 25, right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFfed269),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Humidity",
                                  style: TextStyle(
                                    //color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  recommendations[0]['humidity'],
                                  style: const TextStyle(
                                    //color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.wb_sunny_rounded,
                                  //color: Colors.white,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.45,
                          height: MediaQuery.of(context).size.height / 6,
                          padding: const EdgeInsets.only(left: 25, right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFfed269),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Temperature",
                                  style: TextStyle(
                                    //color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  recommendations[0]['temperature'],
                                  style: const TextStyle(
                                    //color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.opacity_rounded,
                                  //color: Colors.white,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.15,
                          height: MediaQuery.of(context).size.height / 6,
                          padding: const EdgeInsets.only(left: 25, right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFa5885e),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Recommended Plant and Crop",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Plant:   ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        recommendations[0]['plant'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ]),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Crop:   ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      recommendations[0]['crop'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
