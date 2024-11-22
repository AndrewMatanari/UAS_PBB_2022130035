import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Screen',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          NotificationCard(
            title: 'Reservation Reminder',
            description: 'Your reservation for the conference room is about to expire in 10 minutes.',
            onTap: () {
              _showSnackBar(context, 'Tapped on Reservation Reminder');
            },
          ),
          const SizedBox(height: 10),
          NotificationCard(
            title: 'Payment Due',
            description: 'Your payment is due in 3 days. Please make sure to pay on time.',
            onTap: () {
              _showSnackBar(context, 'Tapped on Payment Due');
            },
          ),
          const SizedBox(height: 10),
          NotificationCard(
            title: 'Event Reminder',
            description: 'Don\'t forget about the team meeting tomorrow at 10 AM.',
            onTap: () {
              _showSnackBar(context, 'Tapped on Event Reminder');
            },
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}