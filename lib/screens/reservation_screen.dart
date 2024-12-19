import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// HomeScreen widget
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Screen",
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
      body: Center(
        child: Text(
          'Home Screen',
          style: GoogleFonts.poppins(fontSize: 24),
        ),
      ),
    );
  }
}

// ReservationScreen widget
class ReservationScreen extends StatefulWidget {
  ReservationScreen({super.key});

  final String apiUrl = 'https://petcare.mahasiswarandom.my.id/api/data-reservations';

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List<Map<String, dynamic>> _reservations = [];
  List<Map<String, dynamic>> _filteredReservations = [];
  late Timer _timer;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchReservationData();
    _startPolling();
  }

  Future<void> _fetchReservationData() async {
    final response = await http.get(Uri.parse(widget.apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _reservations = List<Map<String, dynamic>>.from(data)..sort((a, b) {
          final dateA = DateTime.parse(a["reservation_date"]);
          final dateB = DateTime.parse(b["reservation_date"]);
          return -dateA.compareTo(dateB);
        });
        _filterReservations();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      _fetchReservationData();
    });
  }

  void _filterReservations() {
    setState(() {
      if (_selectedDate == null) {
        _filteredReservations = _reservations;
      } else {
        _filteredReservations = _reservations
            .where((reservation) => DateTime.parse(reservation["reservation_date"]).isAtSameMomentAs(_selectedDate!))
            .toList();
        if (_filteredReservations.isEmpty) {
          _showNoDataAlert();
        }
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _filterReservations();
    }
  }

  void _showNoDataAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Data Tidak Ditemukan'),
          content: Text('Tidak ada reservasi pada tanggal yang dipilih.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
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
        actions: [
          IconButton(
            icon: Icon(FeatherIcons.calendar),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: _filteredReservations.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _filteredReservations.length,
              itemBuilder: (context, index) {
                final reservation = _filteredReservations[index];
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

// MainScreen with BottomNavigationBar
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens to navigate between
  final List<Widget> _screens = [
    HomeScreen(),
    ReservationScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.fileText),
            label: 'Reservations',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF818AF9),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainScreen(),
  ));
}
