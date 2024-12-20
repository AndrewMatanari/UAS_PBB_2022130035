import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class CreateReservationScreen extends StatefulWidget {
  @override
  _CreateReservationScreenState createState() => _CreateReservationScreenState();
}

class _CreateReservationScreenState extends State<CreateReservationScreen> {
  String? selectedService;
  String? selectedEmployee;
  DateTime? selectedReservationDate;
  DateTime? selectedPickupDate;
  final TextEditingController _notesController = TextEditingController();

  List<String> services = [];
  List<String> employees = [];
  List<String> pets = [];
  List<String> customers = ['Customer 1', 'Customer 2', 'Customer 3'];

  String? selectedPet;
  String? customerId;
  String? customerName;
  String reservationCode = "";
  double totalAmount = 0.0;

  List<Map<String, dynamic>> servicesData = [];
  List<Map<String, dynamic>> petsData = [];
  List<Map<String, dynamic>> employeesData = [];

  static int _lastReservationNumber = 1000;

  Future<void> _getServicesDataFromAPI() async {
    final response = await http.get(Uri.parse('https://petcare.mahasiswarandom.my.id/api/data-services'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var servicesList = data['services'] as List;
      setState(() {
        servicesData = servicesList.map((item) => item as Map<String, dynamic>).toList();
        services = servicesData.map((service) => service['name'] as String).toList();
      });
    } else {
      print('Failed to load services data');
    }
  }

  Future<void> _getPetsDataFromAPI() async {
    final response = await http.get(Uri.parse('https://petcare.mahasiswarandom.my.id/api/data-pets'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var petsList = data as List;
      setState(() {
        petsData = petsList.map((item) => item as Map<String, dynamic>).toList();
        pets = petsData.map((pet) => pet['name'] as String).toList();
      });
    } else {
      print('Failed to load pets data');
    }
  }

  Future<void> _getEmployeesDataFromAPI() async {
    final response = await http.get(Uri.parse('https://petcare.mahasiswarandom.my.id/api/data-employees'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var employeesList = data as List;
      setState(() {
        employeesData = employeesList.map((item) => item as Map<String, dynamic>).toList();
        employees = employeesData.map((employee) => employee['name'] as String).toList();
      });
    } else {
      print('Failed to load employees data');
    }
  }

  Future<void> _getUserDataFromAPI() async {
    final response = await http.get(Uri.parse('https://petcare.mahasiswarandom.my.id/api/data-users'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var latestUser = data.last;
      setState(() {
        customerId = latestUser['id'].toString();
        customerName = latestUser['name'];
      });
    } else {
      print('Failed to load user data');
    }
  }

  void _calculateTotalAmount() {
    if (selectedService != null && selectedReservationDate != null && selectedPickupDate != null) {
      var service = servicesData.firstWhere((service) => service['name'] == selectedService);
      double servicePrice = double.parse(service['price'].toString());
      int daysDifference = selectedPickupDate!.difference(selectedReservationDate!).inDays;

      setState(() {
        totalAmount = servicePrice * daysDifference;
      });
    }
  }

  Future<void> _selectReservationDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedReservationDate = pickedDate;
      });
      _calculateTotalAmount();
    }
  }

  Future<void> _selectPickupDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedPickupDate = pickedDate;
      });
      _calculateTotalAmount();
    }
  }

  String _generateReservationCode() {
    _lastReservationNumber++; // Increment reservation number each time
    return "RSV-${_lastReservationNumber.toString().padLeft(5, '0')}";
  }

  void _createReservation() async {
    if (selectedPet != null && selectedService != null && selectedEmployee != null && selectedReservationDate != null && selectedPickupDate != null && customerId != null) {
      reservationCode = _generateReservationCode();

      var selectedPetData = petsData.firstWhere((pet) => pet['name'] == selectedPet);
      var selectedServiceData = servicesData.firstWhere((service) => service['name'] == selectedService);
      var selectedEmployeeData = employeesData.firstWhere((employee) => employee['name'] == selectedEmployee);

      Map<String, String> reservationData = {
        'kode': reservationCode,
        'customer_id': customerId!,
        'pet_id': selectedPetData['id'].toString(),
        'service_id': selectedServiceData['id'].toString(),
        'employee_id': selectedEmployeeData['id'].toString(),
        'reservation_date': selectedReservationDate!.toLocal().toString().split(' ')[0],
        'pickup_date': selectedPickupDate!.toLocal().toString().split(' ')[0],
        'notes': _notesController.text,
        'amount': totalAmount.toStringAsFixed(2),
      };

      final response = await http.post(
        Uri.parse('https://petcare.mahasiswarandom.my.id/api/add-reservations'),
        body: reservationData,
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Reservation Created'),
              content: Text('Reservation Code: $reservationCode\nYour reservation has been created successfully!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to create reservation. Please try again later.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all the required fields.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserDataFromAPI();
    _getPetsDataFromAPI();
    _getServicesDataFromAPI();
    _getEmployeesDataFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Reservation', style: GoogleFonts.manrope(fontWeight: FontWeight.bold 
        ,color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 123, 61, 223),
        leading: IconButton(
          icon: Icon(FeatherIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Pet Selection Dropdown
            Text('Select Pet:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: selectedPet,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPet = newValue;
                });
              },
              items: pets.map<DropdownMenuItem<String>>((String pet) {
                return DropdownMenuItem<String>(
                  value: pet,
                  child: Text(pet),
                );
              }).toList(),
            ),
            SizedBox(height: 10),

            // Service Selection Dropdown
            Text('Select Service:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: selectedService,
              onChanged: (String? newValue) {
                setState(() {
                  selectedService = newValue;
                });
                _calculateTotalAmount();
              },
              items: services.map<DropdownMenuItem<String>>((String service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
            ),
            SizedBox(height: 10),

            // Employee Selection Dropdown
            Text('Select Employee:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: selectedEmployee,
              onChanged: (String? newValue) {
                setState(() {
                  selectedEmployee = newValue;
                });
              },
              items: employees.map<DropdownMenuItem<String>>((String employee) {
                return DropdownMenuItem<String>(
                  value: employee,
                  child: Text(employee),
                );
              }).toList(),
            ),
            SizedBox(height: 10),

            // Reservation Date
            Text('Reservation Date:', style: TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: _selectReservationDate,
              child: Text(selectedReservationDate == null
                  ? 'Select Date'
                  : DateFormat('yyyy-MM-dd').format(selectedReservationDate!)),
            ),
            SizedBox(height: 10),

            // Pickup Date
            Text('Pickup Date:', style: TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: _selectPickupDate,
              child: Text(selectedPickupDate == null
                  ? 'Select Date'
                  : DateFormat('yyyy-MM-dd').format(selectedPickupDate!)),
            ),
            SizedBox(height: 10),

            // Total Amount
            Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),

            // Notes
            TextField(
              controller: _notesController,
              decoration: InputDecoration(labelText: 'Notes'),
              maxLines: 3,
            ),
            SizedBox(height: 20),

            // Create Reservation Button
            ElevatedButton(
              onPressed: _createReservation,
              child: Text('Create Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
