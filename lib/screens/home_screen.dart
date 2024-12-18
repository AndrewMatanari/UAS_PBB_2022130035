import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:petcare_mobile/models/employees_model.dart';
import 'package:petcare_mobile/models/service_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedServices = 0;
  int selectedMenu = 0;
  String username = 'Pelanggan'; // Default username if the API call fails or is empty

  var menus = [
    FeatherIcons.home,
    FeatherIcons.fileText,
    FeatherIcons.bell,
    FeatherIcons.user
  ];

  int userId = 10;  // Placeholder user ID. You should replace this with the actual user ID of the logged-in user.

  @override
  void initState() {
    super.initState();
    _getUsernameFromAPI(userId);  // Fetch the username using the userId
  }

  Future<void> _getUsernameFromAPI(int id) async {
    final response = await http.get(Uri.parse('https://petcare.mahasiswarandom.my.id/api/data-users'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // Find the user with the matching ID from the response
      var user = data.firstWhere((user) => user['id'] == id, orElse: () => null);

      if (user != null) {
        setState(() {
          username = user['name']; // Update the username with the fetched value
        });
      } else {
        print('User not found');
      }
    } else {
      print('Failed to load user data');
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
              _greetings(),  // Display the username in the greeting message
              const SizedBox(height: 20),
              _card(),
              const SizedBox(height: 20),
              _search(),
              const SizedBox(height: 20),
              _services(),
              const SizedBox(height: 27),
              _employees(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

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

  ListView _employees() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => _employee(employees[index]),
      separatorBuilder: (context, index) => const SizedBox(height: 11),
      itemCount: employees.length,
    );
  }

  Container _employee(EmployeesModel employeesModel) {
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
            child: Image.asset(
              'assets/images/${employeesModel.image}',
              width: 88,
              height: 103,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employeesModel.name,
                style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3F3E3F)),
              ),
              const SizedBox(height: 7),
              RichText(
                  text: TextSpan(
                      text: "Service: ${employeesModel.service.join(", ")} ",
                      style: GoogleFonts.manrope(
                          fontSize: 12, color: Colors.black))),
              const SizedBox(height: 7),
              Row(
                children: [
                  const Icon(
                    FeatherIcons.phone,
                    size: 14,
                    color: Color(0xFFCACACA),
                  ),
                  const SizedBox(width: 7),
                  Text("${employeesModel.phone}",
                      style: GoogleFonts.manrope(fontSize: 12, color: Colors.black))
                ],
              ),
              SizedBox(height: 7),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF34C759)),
                  child: Text("Bersedia",
                      style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: Colors.white,
                          height: 150 / 100))),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox _services() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var service = Service.all()[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: selectedServices == index
                  ? Color(0xFF818AF9)
                  : const Color(0xFFF6F6F6),
              border: selectedServices == index
                  ? Border.all(color: const Color(0xFF818AF9), width: 2)
                  : Border.all(color: const Color(0xFFF6F6F6), width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedServices = index;
                });
              },
              child: Center(
                child: Text(
                  service,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: selectedServices == index ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: Service.all().length,
      ),
    );
  }

  Padding _search() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(FeatherIcons.search),
          hintText: 'Search for a service or employee...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Padding _greetings() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hello, $username!',
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: const Color(0xFF3F3E3F)),
          ),
        ],
      ),
    );
  }

  _card() {
    return Container(); // Add card widget if needed.
  }
}