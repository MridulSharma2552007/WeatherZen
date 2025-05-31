import 'package:flutter/material.dart';
import 'package:snowy/elements/containerForSettings.dart';
import 'package:snowy/elements/navbar.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFdaedef),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0XFFdaedef),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight:Radius.circular(20) ),
         border: Border.all(
          
          color: Colors.black
         )
        ),
        child: ListView(
          children: [
            Containerforsettings(),
            Containerforsettings()
          ],
        )
    
      ),
      bottomNavigationBar: BottomContainer(),
    );
  }
}
