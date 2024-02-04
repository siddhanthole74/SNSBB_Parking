import 'package:flutter/material.dart';
import 'package:snm_parking_final/HomeScreen/homescreen.dart';
import 'package:snm_parking_final/widgets/bottomnavigationbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
class CustomerSupportScreen extends StatelessWidget {
  final String whatsappNumber;

  CustomerSupportScreen({required this.whatsappNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text('Customer Support'),
  backgroundColor: Colors.white,
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    color: Colors.black, // Adjust the color according to your preference
    onPressed: () {
  // Handle back button press here
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => Bottom()),
  );
},
  ),
),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.green, // WhatsApp green color
              radius: 50,
              child: Icon(
                Icons.whatshot,
                size: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Contact our Customer Support on WhatsApp',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Click the button below to start a conversation on Whats app.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Open WhatsApp chat
                launchWhatsApp(whatsappNumber);
              },
              icon: Icon(Icons.chat),
              label: Text('Chat with Customer Support'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to open WhatsApp chat
  Future<void> launchWhatsApp(String number) async {
    final link = WhatsAppUnilink(
      phoneNumber: number,
      text: "Hello, I need support.",
    );
    await launch('$link');
  }
}
