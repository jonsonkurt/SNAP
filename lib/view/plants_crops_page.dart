import 'package:flutter/material.dart';

class PlantsCropsPage extends StatefulWidget {
  const PlantsCropsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PlantsCropsPageState createState() => _PlantsCropsPageState();
}

class _PlantsCropsPageState extends State<PlantsCropsPage> {
  @override
  Widget build(BuildContext context) {
    List<String> plantsCrops = [
      'Ampalaya',
      'Atis',
      'Avocado',
      'Bayabas',
      'Bukchoy',
      'Cabbage',
      'Cacao',
      'Caimito',
      'Calamansi',
      'Cassava',
      'Cauliflower',
      'Chico',
      'Corn',
      'Dalandan',
      'Duhat',
      'Durian',
      'Eggplant',
      'Gabi',
      'Garlic',
      'Ginger',
      'Grapes',
      'Guyabano',
      'Jackfruit',
      'Lanzones',
      'Lemon',
      'Mango',
      'Mangosteen',
      'Sampaloc',
      'Santol',
      'Sayote',
    ];

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
                        width: 179, // Set the width of the divider here
                        child: Divider(
                          color: Colors.white,
                          thickness: 1,
                          height: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 450,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        // This next line does the trick.
                        scrollDirection: Axis.vertical,
                        itemCount: plantsCrops.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: index % 2 == 0
                                ? const Color(0xFFa5885e)
                                : const Color(0xFFfed269),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                plantsCrops[index],
                                style: TextStyle(
                                  color: index % 2 == 0
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }
}
