import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petcare_mobile/models/employees_model.dart';
import 'package:petcare_mobile/models/service_model.dart';
import 'package:http/http.dart' as http;
import 'package:petcare_mobile/screens/reservation_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedServices = 0;
  int selectedMenu = 0;
  String? name;
  int userId = 0;
  Map<String, dynamic>? lastReservation;

  List<EmployeeModel> employees = [];
  List<ServiceModel> services = [];

  var menus = [
    FeatherIcons.home,
    FeatherIcons.fileText,
    FeatherIcons.bell,
    FeatherIcons.user
  ];

  @override
  void initState() {
    super.initState();
    _getUserDataFromAPI();
    _getEmployeeData();
    _getServiceData();
    _getLastReservation();
  }

  // Fetch user data
  Future<void> _getUserDataFromAPI() async {
    final response = await http.get(Uri.parse('https://petcare.mahasiswarandom.my.id/api/data-users'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var latestUser = data.last;
      setState(() {
        userId = latestUser['id'];
        name = latestUser['name'];
      });
    } else {
      print('Failed to load user data');
    }
  }

  // Fetch employee data
  Future<void> _getEmployeeData() async {
    final response = await http.get(Uri.parse('https://petcare.mahasiswarandom.my.id/api/data-employees'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<EmployeeModel> employeeList = [];
      for (var emp in data) {
        employeeList.add(EmployeeModel.fromJson(emp));
      }
      setState(() {
        employees = employeeList;
      });
    } else {
      print('Failed to load employee data');
    }
  }

  // Fetch service data
  Future<void> _getServiceData() async {
    final response = await http.get(Uri.parse('https://petcare.mahasiswarandom.my.id/api/data-services'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['services'];
      List<ServiceModel> serviceList = [];
      for (var service in data) {
        serviceList.add(ServiceModel.fromJson(service));
      }
      setState(() {
        services = serviceList;
      });
    } else {
      print('Failed to load service data');
    }
  }

  // Fetch last reservation
  Future<void> _getLastReservation() async {
    final response = await http.get(Uri.parse('https://petcare.mahasiswarandom.my.id/api/reservations'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var latestReservationData = data.isNotEmpty ? data.last : null;
      setState(() {
        lastReservation = latestReservationData;
      });
    } else {
      print('Failed to load reservation data');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _greetings(),
              const SizedBox(height: 20),
              _createReservationButton(),
              const SizedBox(height: 20),
              _lastReservationCard(),
              const SizedBox(height: 20),
              _services(),
              const SizedBox(height: 20),
              _employees(),
            ],
          ),
        ),
      ),
    );
  }

  // Bottom navigation bar
  Container _bottomNavigationBar() {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDADADA).withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          menus.length,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                selectedMenu = index;
              });
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReservationScreen()),
                );
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: selectedMenu == index
                    ? const Color(0xFF818AF9).withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              transform: Matrix4.identity()..scale(selectedMenu == index ? 1.1 : 1.0),
              child: Icon(
                menus[index],
                color: selectedMenu == index
                    ? const Color(0xFF818AF9)
                    : const Color(0xFFCACACA).withOpacity(0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Employees List
  ListView _employees() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var employee = employees[index];
        return _employee(employee);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 11),
      itemCount: employees.length,
    );
  }

  // Employee Widget
// Employee Widget
Container _employee(EmployeeModel employee) {
  String baseUrl = 'https://petcare.mahasiswarandom.my.id/storage/'; // Base URL
  String imageUrl = baseUrl + employee.photo;  // Complete image URL

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: const Color(0xFFF1E5E5).withOpacity(.22),
          blurRadius: 20,
          offset: const Offset(0, 10),
        )
      ],
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.network(
            imageUrl,
            width: 88,
            height: 103,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, size: 88); // If image fails to load, show error icon
            },
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              employee.name,
              style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3F3E3F)),
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const Icon(
                  FeatherIcons.phone,
                  size: 14,
                  color: Color(0xFFCACACA),
                ),
                const SizedBox(width: 7),
                Text(employee.phone,
                    style: GoogleFonts.manrope(fontSize: 12, color: Colors.black))
              ],
            ),
          ],
        ),
      ],
    ),
  );
  }

  // Services List
  SizedBox _services() {
    return SizedBox(
      height: 136,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        itemBuilder: (context, index) {
          return _service(services[index]);
        },
      ),
    );
  }

  // Service Widget
  Padding _service(ServiceModel service) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 220,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF1E5E5).withOpacity(.22),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service.name,
                style: GoogleFonts.manrope(
                    fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF3F3E3F))),
            const SizedBox(height: 10),
            Text(service.description,
                style: GoogleFonts.manrope(fontSize: 12, color: const Color(0xFF6B6A6A))),
            const SizedBox(height: 10),
            Text(service.price,
                style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF818AF9)))
          ],
        ),
      ),
    );
  }

  // Last Reservation Card
  Widget _lastReservationCard() {
    if (lastReservation == null) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF1E5E5).withOpacity(.22),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last Reservation',
            style: GoogleFonts.manrope(
                fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF3F3E3F)),
          ),
          const SizedBox(height: 10),
          Text(
            'Service: ${lastReservation!['service']['name']}',
            style: GoogleFonts.manrope(fontSize: 14, color: const Color(0xFF818AF9)),
          ),
          const SizedBox(height: 10),
          Text(
            'Date: ${lastReservation!['created_at']}',
            style: GoogleFonts.manrope(fontSize: 12, color: const Color(0xFF6B6A6A)),
          ),
        ],
      ),
    );
  }

  // Greeting Widget
  Widget _greetings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Hello, $name',
            style: GoogleFonts.manrope(
                fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF3F3E3F)),
          ),
        ),
      ],
    );
  }

  // Create Reservation Button
  ElevatedButton _createReservationButton() {
    return ElevatedButton(
      onPressed: () {
        // Implement your reservation logic
      },
      child: const Text('Create Reservation'),
    );
  }
}

