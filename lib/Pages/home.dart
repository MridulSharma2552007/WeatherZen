import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snowy/elements/containerastro.dart';
import 'package:snowy/elements/drawerelement.dart';
import 'package:snowy/elements/navbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String city = '';
  double tempCelsius = 0.0;

  String condition = '';
  String iconUrl = '';
  String sunrise = '';
  String sunset = '';
  String moonrise = '';
  String moonset = '';
  bool isLoading = true;
  String windSpeed = '';
  bool tempIn = false;
  String temperature = '';

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
      case 'patchy rain nearby':
        return 'assets/images/patchyrain.png';
      case 'clear':
        return 'assets/images/clear.png';

      default:
        return 'assets/images/Forgot_to_add_Icon_for_this_weather-removebg-preview.png';
    }
  }

  final String apiKey = 'aaae26bd36ea49968d234532253005';

  @override
  void initState() {
    super.initState();
    getSettings();
    getWeatherForCurrentLocation();
  }

  bool windEnabled = false;

  void getSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      windEnabled = prefs.getBool('windEnabled') ?? false;
      tempIn = prefs.getBool('tempIn') ?? false;
    });
  }

  Future<void> getWeatherForCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
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

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double lat = position.latitude;
    double lon = position.longitude;

    Uri url = Uri.parse(
      'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$lat,$lon&days=1&aqi=no&alerts=no',
    );

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (!mounted) return;
      setState(() {
        city = data['location']['name'];
        tempCelsius = data['current']['temp_c'].toDouble();
        temperature = '${data['current']['temp_c']}°C';
        condition = data['current']['condition']['text'];
        iconUrl = data['current']['condition']['icon'];
        sunrise = data['forecast']['forecastday'][0]['astro']['sunrise'];
        sunset = data['forecast']['forecastday'][0]['astro']['sunset'];
        moonrise = data['forecast']['forecastday'][0]['astro']['moonrise'];
        moonset = data['forecast']['forecastday'][0]['astro']['moonset'];
        windSpeed = '${data['current']['wind_kph']} km/h';

        isLoading = false;
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
    String displayTemp =
        tempIn
            ? '${((tempCelsius * 9 / 5) + 32).toStringAsFixed(1)}°F' // Fahrenheit
            : '${tempCelsius.toStringAsFixed(1)}°C'; // Celsius

    return Scaffold(
      backgroundColor: const Color(0XFFdaedef),
      appBar: AppBar(
        backgroundColor: const Color(0XFFdaedef),
        elevation: 0,
        title: const Text(
          'WeatherZen',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawerelement(),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueGrey,
                  strokeWidth: 3,
                ),
              )
              : Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
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
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                tempIn ? displayTemp : temperature,
                                style: const TextStyle(
                                  fontSize: 100,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(height: 10),
                              iconUrl.isNotEmpty
                                  ? Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.pink.withOpacity(0.5),
                                          blurRadius: 30,
                                          spreadRadius: 5,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      getWeatherIcon(condition),
                                      width: 200,
                                      height: 200,
                                    ),
                                  )
                                  : const SizedBox(height: 200),
                              const SizedBox(height: 40),
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
                    const SizedBox(height: 20),
                    Containerastro(
                      label: 'Sunrise',
                      time: sunrise,
                      imagePath: 'assets/images/sunrise.png',
                      glowColor: const Color.fromARGB(255, 239, 181, 94),
                    ),
                    Containerastro(
                      label: 'Sunset',
                      time: sunset,
                      imagePath: 'assets/images/sunset.png',
                      glowColor: const Color.fromARGB(255, 108, 182, 243),
                    ),
                    Containerastro(
                      label: 'Moonrise',
                      time: moonrise,
                      imagePath: 'assets/images/moonrise.png',
                      glowColor: const Color.fromARGB(255, 217, 138, 231),
                    ),
                    Containerastro(
                      label: 'Moonset',
                      time: moonset,
                      imagePath: 'assets/images/moonset.png',
                      glowColor: const Color.fromARGB(255, 120, 208, 123),
                    ),
                    if (windEnabled)
                      Containerastro(
                        label: 'WindSpeed',
                        time: windSpeed,
                        imagePath: 'assets/images/windsock_6288895.png',
                        glowColor: Colors.blue,
                      ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Weather data provided by WeatherAPI.com',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: const BottomContainer(),
    );
  }
}
