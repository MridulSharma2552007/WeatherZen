import 'package:flutter/material.dart';

class Containerastro extends StatelessWidget {
  final String label;
  final String time;
  final String imagePath;
  final Color glowColor;

  const Containerastro({
    super.key,
    required this.label,
    required this.time,
    required this.imagePath,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 250,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$label: $time',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            
          ],
          
          
          
        ),
        
      ),
      
    );


  }
}
