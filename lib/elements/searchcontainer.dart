import 'package:flutter/material.dart';

class Searchcontainer extends StatelessWidget {
  final String label;       // condition
  final String time;        // temperature
  final String imagePath;
  final Color glowColor;
  final String city;

  const Searchcontainer({
    super.key,
    required this.label,
    required this.time,
    required this.imagePath,
    required this.glowColor,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
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
        child: Row(
          children: [
            // Left Side: Weather Icon
            Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: glowColor,
                        blurRadius: 50,
                        spreadRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
            ),

            
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 10), 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Text(
                        time,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Text(
                        city,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
        
      ),
    );
    
  }
}
