import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:snap/model/database_helper.dart';
import 'package:intl/intl.dart'; // Import the intl package

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  String? _nScanned;
  String? _pScanned;
  String? _kScanned;
  String? _date;
  String? _time;
  String? _phValue;
  String? _npk;
  String? _humidity;
  String? _temperature;
  String? _recommendedPlant;
  String? _suitablePlant;
  String? _plantNames;
  bool _scanningComplete = false;
  bool _isConnected = false;
  BluetoothConnection? _connection;
  bool _isConnecting = true;

  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  bool _connected = false;
  BluetoothDevice? _connectedDevice;

  @override
  void initState() {
    super.initState();
    _checkBluetooth();
  }

  void disconnect() {
    _connection?.close();
  }

  void _checkBluetooth() async {
    // Check if Bluetooth is available on the device
    bool? isAvailable = await _bluetooth.isAvailable;

    if (!isAvailable!) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Bluetooth Not Available'),
            content: Text('Bluetooth is not available on this device.'),
          );
        },
      );
    }

    // Request user to enable Bluetooth
    bool? isEnabled = await _bluetooth.requestEnable();

    if (!isEnabled!) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Bluetooth Not Enabled'),
            content: Text('Please enable Bluetooth to use this feature.'),
          );
        },
      );
    }
  }

  Future<void> _initBluetoothConnection() async {
    try {
      // Get a list of bonded Bluetooth devices
      List<BluetoothDevice> bondedDevices =
          await FlutterBluetoothSerial.instance.getBondedDevices();

      // Find your Arduino device in the list of bonded devices
      BluetoothDevice? arduinoDevice;
      for (BluetoothDevice device in bondedDevices) {
        if (device.name == 'HC-05') {
          arduinoDevice = device;
          print('connected');
          break;
        }
      }

      // Check if the Arduino device is found
      if (arduinoDevice != null) {
        try {
          // Use the Arduino device in your Bluetooth connection
          BluetoothDevice device = arduinoDevice;

          _connection = await BluetoothConnection.toAddress(device.address);
          // _connection.input.listen(_handleData);
          print('Connected to the device');
          setState(() {
            _isConnected = true;
          });

          _connection!.input?.listen((List<int> data) {
            Uint8List uint8ListData = Uint8List.fromList(data);
            print('Data incoming: ${ascii.decode(uint8ListData)}');
            String string_with_exclamation = utf8.decode(uint8ListData);
            String string_without_exclamation =
                string_with_exclamation.replaceAll(
                    '!', ''); // Remove the exclamation mark from the string
            int integer_value = int.parse(string_without_exclamation);
            double final_nScanned = integer_value / 10;
            int roundedNScanned = final_nScanned.round();

            print(roundedNScanned);
            _nScanned = roundedNScanned.toString();

            if (ascii.decode(uint8ListData).contains('!')) {
              _connection!.finish(); // Closing connection
              print('Disconnecting by local host');
            } else {
              // setState(() {
              //   _nScanned = ascii.decode(uint8ListData);
              //   _nScanned = (int.parse(_nScanned!) / 10)
              //       .toString(); // Divide nitrogen value by 10
              //   print(_nScanned);
              // });
            }
          }).onDone(() {
            print('Disconnected by remote request');
          });
        } catch (exception) {
          print('Cannot connect, exception occurred: $exception');
        }
      } else {
        print('Arduino device not found.');
        // Handle the case when the Arduino device is not found
      }
    } catch (ex) {
      print('Error: $ex');
    }
  }

  @override
  void dispose() {
    _connection?.close();
    super.dispose();
  }

  Future<void> _scanSoilQualities() async {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Format the date and time as strings
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    String formattedTime = DateFormat('HH:mm').format(now);

    // Generate random values for phosphorus, potassium, pH, temperature, and humidity
    final random = Random();
    final plantData = plantDatabase[random.nextInt(plantDatabase.length)];

    final minPh = plantData[1];
    final maxPh = plantData[2];
    final N = _nScanned != null ? int.parse(_nScanned!) : 0;
    final P = random.nextInt(30) + 1; // Random phosphorus value from 1 to 30
    final K = random.nextInt(30) + 1; // Random potassium value from 1 to 30
    final minHumidity = plantData[8];

// Update the state with the generated values
    setState(() {
      _date = formattedDate;
      _time = formattedTime;
      _phValue = ((random.nextDouble() * (maxPh - minPh)) + minPh)
          .round()
          .toStringAsFixed(1);
      _nScanned = _nScanned;
      _pScanned = P.toString();
      _kScanned = K.toString();
      _humidity = minHumidity.toString();
      _temperature = (random.nextDouble() * 20 + 15).toStringAsFixed(2);
      _scanningComplete = true;
    });

    // Perform recommendation based on NPK, pH, and humidity values
    List<String> recommendedPlants = [];
    List<String> suitablePlants = [];

    for (List<dynamic> plantData in plantDatabase) {
      double minPh = plantData[1];
      double maxPh = plantData[2];
      int N = plantData[3];
      int P = plantData[4];
      int K = plantData[5];
      int minHumidity = plantData[8]; // Get the minimum required humidity

      List<String> npkValues = _npk != null ? _npk!.split(', ') : [];
      int _nScanned = npkValues.length > 0 ? int.parse(npkValues[0]) : 0;
      int _pScanned = npkValues.length > 1 ? int.parse(npkValues[1]) : 0;
      int _kScanned = npkValues.length > 2 ? int.parse(npkValues[2]) : 0;

      if (_phValue != null && double.parse(_phValue!) == minPh ||
          double.parse(_phValue!) == maxPh &&
              _nScanned == N &&
              _pScanned == P &&
              _kScanned == K &&
              int.parse(_humidity!) == minHumidity) {
        // Check if humidity meets the minimum requirement
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
      _recommendedPlant = recommendedPlants[0];
    } else {
      // _recommendedPlant = 'No recommended plants found';
      _recommendedPlant = 'No recommended plants found';
    }

    if (suitablePlants.isNotEmpty) {
      _suitablePlant = suitablePlants[0];
    } else {
      _suitablePlant = 'No suitable plants found';
    }

    // Combine recommended and suitable plant names
    if (_recommendedPlant != 'No recommended plants found' &&
        _suitablePlant != 'No suitable plants found') {
      _plantNames =
          'Recommended: $_recommendedPlant, Suitable: $_suitablePlant';
    } else if (_recommendedPlant != 'No recommended plants found') {
      _plantNames = 'Recommended: $_recommendedPlant';
    } else if (_suitablePlant != 'No suitable plants found') {
      _plantNames = 'Suitable: $_suitablePlant';
    } else {
      _plantNames = 'No recommended or suitable plants found';
    }

    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.insertRecording(
      userId: '${DatabaseHelper.loggedInUserId}',
      date: _date!,
      time: _time!,
      ph: _phValue!,
      n: _nScanned!,
      p: _pScanned!,
      k: _kScanned!,
      humidity: _humidity!,
      temperature: '${_temperature!}°C',
      plant: _recommendedPlant!.split(' and ')[0],
      crop: suitablePlants.isNotEmpty ? suitablePlants[0] : '',
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
            GestureDetector(
              onTap: _initBluetoothConnection,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFa5885e),
                ),
                child: Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      _isConnected ? "Connected" : "Connect",
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
            const SizedBox(height: 20),
            if (!_scanningComplete)
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
                    'N: ${_nScanned ?? ''}, P: ${_pScanned ?? ''}, K: ${_kScanned ?? ''}',
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
                    _plantNames!,
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
