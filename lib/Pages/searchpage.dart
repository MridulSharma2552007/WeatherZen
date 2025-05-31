import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
          'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$searchtext&aqi=no');
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

  @override
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
        decoration: const BoxDecoration(
          color: Color(0xfff3f4f5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 70,
                width: 400,
                decoration: BoxDecoration(
                  color: const Color(0xfff3f4f5),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20),
                    right: Radius.circular(20),
                  ),
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
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (searchtext.isNotEmpty) Text('Search results for $searchtext'),
            const SizedBox(height: 0),

            /// FIXED HERE
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              )
            else if (city.isNotEmpty)
              Searchcontainer(
                label: temperature,
                time: condition,
                imagePath: getWeatherIcon(condition),
                glowColor: Colors.pink,
                city: city,
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomContainer(),
    );
  }
}
