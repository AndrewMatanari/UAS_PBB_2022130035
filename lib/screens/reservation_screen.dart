import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ReservationScreen extends StatelessWidget {
  ReservationScreen({super.key});

  final List<Map<String, dynamic>> reservations = [
    {
      "doctor": "Dr. Alice",
      "petName": "Buddy",
      "service": "Daycare",
      "amount": 50,
      "reservationDate": "2024-11-22",
      "pickupDate": "2024-11-23",
      "notes": "Ensure Buddy gets extra treats!"
    },
    {
      "doctor": "Dr. Bob",
      "petName": "Max",
      "service": "Walking",
      "amount": 30,
      "reservationDate": "2024-11-25",
      "pickupDate": "2024-11-25",
      "notes": "Walk in the park for 45 minutes."
    },
    {
      "doctor": "Dr. Clara",
      "petName": "Luna",
      "service": "Pet Sitting",
      "amount": 100,
      "reservationDate": "2024-11-29",
      "pickupDate": "2024-12-01",
      "notes": "Feed Luna twice daily."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reservations",
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
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: reservations.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final reservation = reservations[index];
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
                    title: "Doctor",
                    value: reservation["doctor"] ?? "No doctor assigned",
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    icon: FeatherIcons.mapPin,
                    title: "Pet",
                    value: reservation["petName"] ?? "Unknown Pet",
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    icon: FeatherIcons.briefcase,
                    title: "Service",
                    value: reservation["service"] ?? "No service",
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    icon: FeatherIcons.dollarSign,
                    title: "Amount",
                    value: "\$${reservation["amount"] ?? 0}",
                    textColor: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    icon: FeatherIcons.calendar,
                    title: "Reservation Date",
                    value: reservation["reservationDate"] ?? "No date",
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    icon: FeatherIcons.calendar,
                    title: "Pickup Date",
                    value: reservation["pickupDate"] ?? "No date",
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    icon: FeatherIcons.fileText,
                    title: "Notes",
                    value: reservation["notes"] ?? "No notes provided",
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
