import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String city = '';
  String temperature = '';
  String condition = '';
  String iconUrl = '';

  String getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return 'assets/images/sunny-day.png';
      case 'cloudy':
        return 'assets/images/cloudy-day.png';
      case 'rainy':
        return 'assets/images/rainy-day.png';
      case 'snowy':
        return 'assets/images/snowman.png';
      default:
        return 'assets/images/weather-news.png'; 
    }
  }

  final String apiKey = 'aaae26bd36ea49968d234532253005';

  @override
  void initState() {
    super.initState();
    getWeatherForCurrentLocation();
  }

  Future<void> getWeatherForCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      // Handle the case where location permission is not granted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xffdaedef),
          content: Text(
            'Location permission is required to get weather data.',
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
      );
      return;
    }

    // ✅ This should be inside the permission block
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double lat = position.latitude;
    double lon = position.longitude;

    print('Latitude: $lat, Longitude: $lon');
    Uri url = Uri.parse(
      'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$lat,$lon&aqi=no',
    );

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        city = data['location']['name'];
        temperature = '${data['current']['temp_c']}°C';
        condition = data['current']['condition']['text'];
        iconUrl = data['current']['condition']['icon'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xffdaedef),
          content: Text(
            'Failed to fetch weather data.',
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFdaedef),
      appBar: AppBar(
        backgroundColor: Color(0XFFdaedef),
        elevation: 0,
        title: Text(
          'Snowy',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xfff3f4f5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: 350,
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-6, -6),
                      spreadRadius: 1,
                      blurRadius: 15,
                    ),
                    BoxShadow(
                      color: Color(0xffd1d5db),
                      offset: Offset(6, 6),
                      spreadRadius: 1,
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        ' $condition',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25, color: Colors.grey[400]),
                      ),
                      const SizedBox(height: 10),
                      Text(temperature,
                        style: const TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if(iconUrl.isNotEmpty)
                        Image.asset(
                          getWeatherIcon(condition),
                          width: 100,
                          height: 200,
                        ),
                      const SizedBox(height: 10),
                      Text(
                        city,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
