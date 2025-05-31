import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:snowy/elements/containerastro.dart';
import 'package:snowy/elements/navbar.dart';
import 'package:snowy/elements/searchcontainer.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  final TextEditingController _textEditingController = TextEditingController();
  String searchtext = '';
  final String apiKey = 'aaae26bd36ea49968d234532253005';
  String city = '';
  String condition = '';
  String temperature = '';
  bool isLoading = false;
  String iconUrl = '';
  String sunrise = '';
  String sunset = '';
  String moonrise = '';
  String moonset = '';

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
      case 'patchy light rain':
      case 'light rain shower':
        return 'assets/images/patchyrain.png';
      case 'clear':
        return 'assets/images/clear.png';
      case 'partly cloudy':
        return 'assets/images/partly-cloudy.png';
      case 'mist':
        return 'assets/images/mist.png';
      case 'overcast':
        return 'assets/images/overcast.png';
      case 'patchy light rain in area with thunder':
        return 'assets/images/stormy-cloud-with-rain-and-thunder.png';
      default:
        return 'assets/images/Forgot_to_add_Icon_for_this_weather-removebg-preview.png';
    }
  }

  Future<void> fetchWeatherdata() async {
    if (searchtext.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final Uri url = Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$searchtext&aqi=no',

    
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (!mounted) return;

        setState(() {
          city = data['location']['name'];
          temperature = '${data['current']['temp_c']}°C';
          condition = data['current']['condition']['text'];
          iconUrl = data['current']['condition']['icon'];
          isLoading = false;
          sunrise = data['forecast']['forecastday'][0]['astro']['sunrise'];
          sunset = data['forecast']['forecastday'][0]['astro']['sunset'];
          moonrise = data['forecast']['forecastday'][0]['astro']['moonrise'];
          moonset = data['forecast']['forecastday'][0]['astro']['moonset'];
        });
      } else {
        setState(() => isLoading = false);
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
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xffdaedef),
          content: Text(
            'An error occurred: $e',
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
      );
    }
  }

 
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0XFFdaedef),
    appBar: AppBar(
      backgroundColor: const Color(0XFFdaedef),
      elevation: 0,
      title: const Text(
        'Search',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xfff3f4f5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        border: Border.all(color: Colors.black),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xfff3f4f5),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-6, -6),
                    spreadRadius: 1,
                    blurRadius: 2,
                  ),
                  BoxShadow(
                    color: Color(0xffd1d5db),
                    offset: Offset(6, 6),
                    spreadRadius: 1,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      onSubmitted: (value) => fetchWeatherdata(),
                      onChanged: (value) {
                        setState(() {
                          searchtext = value;
                        });
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.search, color: Colors.grey[400]),
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Optional: Display what user searched for
            if (searchtext.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('Search results for "$searchtext"',
                    style: TextStyle(color: Colors.black87)),
              ),

            const SizedBox(height: 10),

            // Spinner
            if (isLoading)
              const Center(
                child: SpinKitWaveSpinner(
                  color: Color(0XFFdaedef),
                  waveColor: Colors.white,
                ),
              )
            else if (city.isNotEmpty)
              Column(
                children: [
                  Searchcontainer(
                    label: temperature,
                    time: condition,
                    imagePath: getWeatherIcon(condition),
                    glowColor: const Color.fromARGB(255, 249, 126, 167),
                    city: city,
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
                  const SizedBox(height: 20),
                ],
              ),
          ],
        ),
      ),
    ),
    bottomNavigationBar: BottomContainer(),
  );
}

  }

