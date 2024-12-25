import 'package:clima2/services/networking.dart';
import 'package:flutter/material.dart';

import 'package:clima2/services/location.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    setState(() {
      latitude = location.latitude;
      longitude = location.longitude;
    });

    Networking networking = Networking(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=7859731d3adf1f5b64677e5efb2838e9');

    var weatherData = await networking.getData();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Get Location'),
      ),
    );
  }
}
