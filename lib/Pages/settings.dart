import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:snowy/elements/navbar.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool windEnabled = false;
  bool tempIn = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  void loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      windEnabled = prefs.getBool('windEnabled') ?? false;
      tempIn = prefs.getBool('tempIn') ?? false;
    });
  }

  void toggleWind(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('windEnabled', value);
    setState(() {
      windEnabled = value;
    });
  }

  void toggleTemperature(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tempIn', value);
    setState(() {
      tempIn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFdaedef),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0XFFdaedef),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border.all(color: Colors.black),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0XFFdaedef),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(10),
                    right: Radius.circular(10),
                    
                  ),boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(6, 6),
                      spreadRadius: 1,
                      blurRadius: 15,
                    ),
                  ],

                ),
                child: SwitchListTile(
                  title: const Text("Enable Wind Speed"),
                  value: windEnabled,
                  onChanged: toggleWind,
                  activeColor: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0XFFdaedef),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(10),
                    right: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(6, 6),
                      spreadRadius: 1,
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: SwitchListTile(
                  value: tempIn,
                  onChanged: toggleTemperature,
                  title: const Text('Switch Temperature in °C / °F'),
                  activeColor: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomContainer(),
    );
  }
}
