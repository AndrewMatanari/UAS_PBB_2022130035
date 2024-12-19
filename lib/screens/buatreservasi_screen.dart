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

  List<String> services = [];  // Populated with data from API
  List<String> employees = []; // Populated with data from API
  List<String> pets = [];      // Populated with data from API
  List<String> customers = ['Customer 1', 'Customer 2', 'Customer 3'];

  String? selectedPet;
  String? customerId;
  String? customerName;
  String reservationCode = "";  // This will hold the auto-generated code
  double totalAmount = 0.0;     // Store total amount for reservation

  // Model for Service data to store price along with service name
  List<Map<String, dynamic>> servicesData = [];

  // Fetch services data from the API (now includes prices)
  Future<void> _getServicesDataFromAPI() async {
    final response = await http.get(Uri.parse('https://petcare.mahasiswarandom.my.id/api/data-services'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var servicesList = data['services'];  // Access the 'services' key from the response
      setState(() {
        servicesData = List<Map<String, dynamic>>.from(servicesList);
        services = servicesData.map<String>((service) => service['name'].toString()).toList();
      });
    } else {
      print('Failed to load services data');
    }
  }

  // Fetch pets data from the API
  Future<void> _getPetsDataFromAPI() async {
    final response = await http.get(Uri.parse('https://petcare.mahasiswarandom.my.id/api/data-pets'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var petsData = List.from(data);  // Assuming the response contains a list of pets
      setState(() {
        pets = petsData.map<String>((pet) => pet['name'].toString()).toList();
      });
    } else {
      print('Failed to load pets data');
    }
  }

  // Fetch employees data from the API
  Future<void> _getEmployeesDataFromAPI() async {
    final response = await http.get(Uri.parse('https://petcare.mahasiswarandom.my.id/api/data-employees'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var employeesData = List.from(data);  // Assuming the response contains a list of employees
      setState(() {
        employees = employeesData.map<String>((employee) => employee['name'].toString()).toList();
      });
    } else {
      print('Failed to load employees data');
    }
  }

  // Fetch user data from the API
  Future<void> _getUserDataFromAPI() async {
    final response = await http.get(Uri.parse('https://petcare.mahasiswarandom.my.id/api/data-users'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var latestUser = data.last;  // Get the last user data
      setState(() {
        customerId = latestUser['id'].toString();
        customerName = latestUser['name'];
      });
    } else {
      print('Failed to load user data');
    }
  }

  // Calculate the total amount based on service price and reservation duration
  void _calculateTotalAmount() {
    if (selectedService != null && selectedReservationDate != null && selectedPickupDate != null) {
      // Find the selected service's price
      var service = servicesData.firstWhere((service) => service['name'] == selectedService);
      double servicePrice = double.parse(service['price'].toString());  // Assuming price is in the 'price' field

      // Calculate number of days between reservation and pickup date
      int daysDifference = selectedPickupDate!.difference(selectedReservationDate!).inDays;

      // Calculate total amount
      setState(() {
        totalAmount = servicePrice * daysDifference;
      });
    }
  }

  // Select reservation date
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
      _calculateTotalAmount();  // Recalculate price when reservation date changes
    }
  }

  // Select pickup date
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
      _calculateTotalAmount();  // Recalculate price when pickup date changes
    }
  }

  // Generate reservation code
  String _generateReservationCode() {
    // Get the latest reservation code or generate a new one
    // Assuming your backend provides a reservation count or you calculate it here
    int newReservationNumber = 1;  // For simplicity, you can increase this logic
    return "RSV-${newReservationNumber.toString().padLeft(5, '0')}";
  }

  // Create reservation and send data to API
  void _createReservation() async {
    if (selectedPet != null &&
        selectedService != null &&
        selectedEmployee != null &&
        selectedReservationDate != null &&
        selectedPickupDate != null &&
        customerId != null) {

      // Generate the reservation code
      reservationCode = _generateReservationCode();

      // Prepare data for the API
      Map<String, String> reservationData = {
        'kode': reservationCode,  // The auto-generated reservation code
        'customer_id': customerId!,  // Customer ID (from API)
        'pet_id': selectedPet!,  // Pet ID (from the dropdown)
        'service_id': selectedService!,  // Service ID (from the dropdown)
        'employee_id': selectedEmployee!,  // Employee ID (from the dropdown)
        'reservation_id': "1",  // This can be dynamic if you have a reservation count
        'reservation_date': selectedReservationDate!.toLocal().toString().split(' ')[0],  // Date format: YYYY-MM-DD
        'pickup_date': selectedPickupDate!.toLocal().toString().split(' ')[0],  // Date format: YYYY-MM-DD
        'notes': _notesController.text,  // Notes from the TextField
        'amount': totalAmount.toStringAsFixed(2),  // The calculated total amount
      };

      // Send the data to the API
      final response = await http.post(
        Uri.parse('https://petcare.mahasiswarandom.my.id/api/add-reservations'),
        body: reservationData,
      );

      // Handle the response
      if (response.statusCode == 200) {
        // Successfully created the reservation
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
        // Failed to create reservation
        showDialog(
          context: context,
          builder: (BuildContext context) {
            print('Error: Failed to create reservation. Status code: ${response.statusCode}.');
            print('Response body: ${response.body}');
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to create reservation. Please try again later.\nStatus code: ${response.statusCode}\nResponse body: ${response.body}'),
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
      // If required fields are not filled
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
        title: Row(
          children: [
            Text(
              'Create Reservation',
              style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(FeatherIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (customerName != null)
                Text(
                  'Name',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              SizedBox(height: 5),
              Text(
                customerName ?? '',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

              if (customerId == null) CircularProgressIndicator() else SizedBox(),

              Text(
                'Select Pet',
                style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              DropdownButton<String>(
                value: selectedPet,
                items: pets.map<DropdownMenuItem<String>>((pet) {
                  return DropdownMenuItem<String>(
                    value: pet,
                    child: Text(pet),
                  );
                }).toList(),
                onChanged: (newPet) {
                  setState(() {
                    selectedPet = newPet;
                  });
                },
              ),

              SizedBox(height: 20),

              Text(
                'Select Service',
                style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              DropdownButton<String>(
                value: selectedService,
                items: services.map<DropdownMenuItem<String>>((service) {
                  return DropdownMenuItem<String>(
                    value: service,
                    child: Text(service),
                  );
                }).toList(),
                onChanged: (newService) {
                  setState(() {
                    selectedService = newService;
                    _calculateTotalAmount();  // Recalculate total amount when service changes
                  });
                },
              ),

              SizedBox(height: 20),

              Text(
                'Select Employee',
                style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              DropdownButton<String>(
                value: selectedEmployee,
                items: employees.map<DropdownMenuItem<String>>((employee) {
                  return DropdownMenuItem<String>(
                    value: employee,
                    child: Text(employee),
                  );
                }).toList(),
                onChanged: (newEmployee) {
                  setState(() {
                    selectedEmployee = newEmployee;
                  });
                },
              ),

              SizedBox(height: 20),

              Text(
                'Select Reservation Date',
                style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Text(
                    selectedReservationDate != null
                        ? selectedReservationDate!.toLocal().toString().split(' ')[0]
                        : 'No date selected',
                    style: GoogleFonts.manrope(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(FeatherIcons.calendar),
                    onPressed: _selectReservationDate,
                  ),
                ],
              ),

              SizedBox(height: 20),

              Text(
                'Select Pickup Date',
                style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Text(
                    selectedPickupDate != null
                        ? selectedPickupDate!.toLocal().toString().split(' ')[0]
                        : 'No date selected',
                    style: GoogleFonts.manrope(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(FeatherIcons.calendar),
                    onPressed: _selectPickupDate,
                  ),
                ],
              ),

              SizedBox(height: 20),

              Text(
                'Additional Notes',
                style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter any additional notes here...',
                ),
              ),

              SizedBox(height: 20),

              // Displaying the calculated price
              Text(
                'Total Amount: Rp. ${NumberFormat('#,##0', 'id_ID').format(totalAmount == null ? 0 : totalAmount)}',
                style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _createReservation,
                child: Text('Create Reservation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
