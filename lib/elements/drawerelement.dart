import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Drawerelement extends StatelessWidget {
  const Drawerelement({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
  backgroundColor: Colors.grey[100],
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      DrawerHeader(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'WeatherZen ☁️',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Peaceful Weather Insights',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),

      ListTile(
        leading: Icon(Icons.person, color: Colors.blueGrey),
        title: Text('Developer: Mridul Sharma'),
        subtitle: Text('Tap to view GitHub'),
        onTap: () {
          launchUrl(Uri.parse('https://github.com/akira2552007'));
        },
      ),

      ListTile(
        leading: Icon(Icons.share, color: Colors.green),
        title: Text('Share this App'),
        onTap: () {
          Share.share("Check out this awesome weather app! 🌤️ https://github.com/mridul25sharma");
        },
      ),

      Divider(),

      ListTile(
        leading: Icon(Icons.lightbulb_outline, color: Colors.orange),
        title: Text(
          'Fun Weather Fact',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '💡 The coldest temperature ever recorded on Earth was −89.2°C in Antarctica!',
        ),
      ),

      ListTile(
        leading: Icon(Icons.format_quote, color: Colors.deepPurple),
        title: Text(
          'Quote of the Day',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '“Wherever you go, no matter what the weather, always bring your own sunshine.”',
        ),
      ),

      Divider(),

      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            '☀️ Made with Flutter · 2025',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ),
    ],
  ),
);

  }
}
