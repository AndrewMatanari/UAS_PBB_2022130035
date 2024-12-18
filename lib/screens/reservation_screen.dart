import 'dart:convert';
import 'dart:async'; // Import the timer class for real-time updates
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ReservationScreen extends StatefulWidget {
  ReservationScreen({super.key});

  // Define the API URL to fetch all reservations
  final String apiUrl = 'https://petcare.mahasiswarandom.my.id/api/data-reservations';

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List<Map<String, dynamic>> _reservations = []; // Use a list to store multiple reservations
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchReservationData();
    _startPolling(); // Start polling for real-time updates
  }

  // Function to fetch the reservation data from the API
  Future<void> _fetchReservationData() async {
    final response = await http.get(Uri.parse(widget.apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _reservations = List<Map<String, dynamic>>.from(data); // Parse response as a list of reservations
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  }

  // Function to start polling the API for updates every 10 seconds
  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      _fetchReservationData(); // Re-fetch reservation data every 10 seconds
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the polling when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reservations List",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF5F5F9F),
        elevation: 0,
        centerTitle: true,
      ),
      body: _reservations.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while data is fetched
          : ListView.builder(
              itemCount: _reservations.length,
              itemBuilder: (context, index) {
                final reservation = _reservations[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  shadowColor: Colors.grey.withOpacity(0.3),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow(
                          icon: FeatherIcons.user,
                          title: "Customer",
                          value: reservation["customer"]?["name"] ?? "No customer name",
                        ),
                        const SizedBox(height: 12),
                        _infoRow(
                          icon: FeatherIcons.tag,
                          title: "Pet",
                          value: reservation["pet"]?["name"] ?? "Unknown Pet",
                        ),
                        const SizedBox(height: 12),
                        _infoRow(
                          icon: FeatherIcons.briefcase,
                          title: "Service",
                          value: reservation["service"]?["name"] ?? "No service",
                        ),
                        const SizedBox(height: 12),
                        _infoRow(
                          icon: FeatherIcons.dollarSign,
                          title: "Amount",
                          value: "Rp ${reservation["amount"] ?? "0"}",
                          textColor: Colors.green,
                        ),
                        const SizedBox(height: 12),
                        _infoRow(
                          icon: FeatherIcons.calendar,
                          title: "Reservation Date",
                          value: reservation["reservation_date"] ?? "No date",
                        ),
                        const SizedBox(height: 12),
                        _infoRow(
                          icon: FeatherIcons.calendar,
                          title: "Pickup Date",
                          value: reservation["pickup_date"] ?? "No date",
                        ),
                        const SizedBox(height: 12),
                        _infoRow(
                          icon: FeatherIcons.fileText,
                          title: "Notes",
                          value: reservation["notes"] ?? "No notes provided",
                        ),
                        const SizedBox(height: 12),
                        _infoRow(
                          icon: FeatherIcons.user,
                          title: "Employee",
                          value: reservation["employee"]?["name"] ?? "No employee assigned",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
    Color textColor = const Color(0xFF333333),
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF5F5F9F), size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: "$title: ",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5F5F9F),
              ),
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
