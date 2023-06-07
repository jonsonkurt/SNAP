import 'package:flutter/material.dart';
import 'package:snap/model/database_helper.dart';
import 'package:intl/intl.dart'; // Import the intl package

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  String? _date;
  String? _time;
  String? _phValue;
  String? _npk;
  String? _humidity;
  String? _temperature;
  String? _recommendedCrop;
  bool _scanningComplete = false;

  Future<void> _scanSoilQualities() async {
  // Get the current date and time
  DateTime now = DateTime.now();

  // Format the date and time as strings
  String formattedDate = DateFormat('dd-MM-yyyy').format(now);
  String formattedTime = DateFormat('HH:mm').format(now);

  // Implement soil scanning logic here
  // Once the soil scanning is complete, update the state with the results
  setState(() {
    _date = formattedDate;
    _time = formattedTime;
    _phValue = '8';
    _npk = '6, 8, 9';
    _humidity = '70%';
    _temperature = '28';
    _scanningComplete = true; // Set the variable to true when scanning is complete
  });

  // Perform recommendation based on NPK and pH values
  List<dynamic> recommendedPlants = [];
  List<dynamic> suitablePlants = [];

  for (List<dynamic> plantData in plantDatabase) {
    double minPh = plantData[1];
    double maxPh = plantData[2];
    int minN = plantData[3];
    int minP = plantData[4];
    int minK = plantData[5];

    List<String> npkValues = _npk!.split(', ');
    int scannedN = int.parse(npkValues[0]);
    int scannedP = int.parse(npkValues[1]);
    int scannedK = int.parse(npkValues[2]);

    if (_phValue != null &&
        double.parse(_phValue!) >= minPh &&
        double.parse(_phValue!) <= maxPh &&
        scannedN >= minN &&
        scannedP >= minP &&
        scannedK >= minK) {
      recommendedPlants.add(plantData[0]);
    }

    // Check if the hard-coded pH value falls within the suitable pH range
    if (_phValue != null &&
        double.parse(_phValue!) >= minPh &&
        double.parse(_phValue!) <= maxPh) {
      suitablePlants.add(plantData[0]);
    }
  }

  if (recommendedPlants.isNotEmpty) {
    _recommendedCrop = '${recommendedPlants[0]} and ${suitablePlants[1]}'; // Display the first two suitable plants
  } else if (suitablePlants.isNotEmpty) {
    _recommendedCrop = suitablePlants[0]; // Get the first suitable plant
  } else {
    _recommendedCrop = 'No recommended crops found';
  }

  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  await databaseHelper.insertRecording(
    userId: '${DatabaseHelper.loggedInUserId}',
    date: _date!,
    time: _time!,
    ph: _phValue!,
    n: _npk!.split(',')[0],
    p: _npk!.split(',')[1],
    k: _npk!.split(',')[2],
    humidity: _humidity!,
    temperature: '${_temperature!}°C',
    plant: _recommendedCrop!.split(' and ')[0],
    crop: suitablePlants.isNotEmpty ? suitablePlants[1] : '', // Get the first plant from suitablePlants list
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Soil Qualities'),
        backgroundColor: const Color(0xFFa5885e),
      ),
      backgroundColor: const Color(0xFF518554),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_scanningComplete) // Render the button only if scanning is not complete
              //onPressed: _scanSoilQualities,
              GestureDetector(
                onTap: _scanSoilQualities,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFa5885e),
                  ),
                  child: const Center(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Start Scanning",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (_date != null) const SizedBox(height: 20),
            if (_date != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Date of Recording:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _date!,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Time of Recording:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _time!,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'pH Value:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _phValue!,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'NPK:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _npk!,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Humidity:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _humidity!,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Temperature:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _temperature!,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Recommended Plant or Crop:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _recommendedCrop!,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
