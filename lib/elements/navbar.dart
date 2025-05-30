import 'package:flutter/material.dart';
import 'package:snowy/Pages/home.dart';
import 'package:snowy/Pages/search.dart';

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0XFFdaedef),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              offset: const Offset(-6, -6),
              spreadRadius: 1,
              blurRadius: 2,
            ),
            BoxShadow(
              color: const Color(0xffd1d5db),
              offset: const Offset(6, 6),
              spreadRadius: 1,
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              icon: const Icon(Icons.home, color: Colors.black, size: 30),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Search()),
                );
              },
              icon: const Icon(Icons.search, color: Colors.black, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
