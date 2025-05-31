import 'package:flutter/material.dart';

class Containerforsettings extends StatelessWidget {
  const Containerforsettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 400,
        height: 100,
        decoration: BoxDecoration(
          color: Color(0XFFdaedef),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}