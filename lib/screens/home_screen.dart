import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:petcare_mobile/models/employees_model.dart';
import 'package:petcare_mobile/models/service_model.dart';
import 'package:petcare_mobile/screens/daycare_screen.dart';
import 'package:petcare_mobile/screens/notification_screen.dart';
import 'package:petcare_mobile/screens/profile_screen.dart';
import 'package:petcare_mobile/screens/reservation_screen.dart';


var selectedServices = 0;
var menus = [FeatherIcons.home, 
                FeatherIcons.fileText ,
                FeatherIcons.bell, 
                FeatherIcons.user
              ];
var selectedMenu = 0;

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedMenu = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    // Daftar halaman
    final List<Widget> pages = [
      _homeContent(),  // Halaman utama
      _reservationsPage(), // Halaman Reservasi
      _notificationsPage(), // Halaman Notifikasi
      _profilePage(), // Halaman Profil
    ];

    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      body: SafeArea(child: pages[selectedMenu]),
    );
  }

  // Konten Halaman Utama
  Widget _homeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _greetings(),
          const SizedBox(height: 20),
          _card(),
          const SizedBox(height: 20),
          _search(),
          const SizedBox(height: 20),
          Text(
            'Services',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          _servicesWithImages(),
          const SizedBox(height: 27),
          Text(
            'Dokter',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          _horizontalEmployees(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Tambahkan konten halaman lainnya
  Widget _reservationsPage() {
    return ReservationScreen();
  }

  Widget _notificationsPage() {
    return NotificationScreen();
  }

  Widget _profilePage() {
    return ProfileScreen();
  }

  // Perbaikan BottomNavigationBar
  Widget _bottomNavigationBar() {
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
              transform: Matrix4.identity()
                ..scale(selectedMenu == index ? 1.1 : 1.0),
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
}


Widget _servicesWithImages() {
  return SizedBox(
    height: 100,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Buka DaycareScreen untuk layanan "Daycare"
            if (Service.all()[index] == "Daycare") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DaycareScreen(),
                ),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: const Color(0xFFF6F6F6),
                  border: Border.all(
                    color: selectedServices == index
                        ? const Color(0xFF818AF9)
                        : Colors.transparent,
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/service_${index + 1}.png'), // Pastikan path benar
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                Service.all()[index],
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3F3E3F),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 15),
      itemCount: Service.all().length,
    ),
  );
}


   Widget _horizontalEmployees() {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return Container(
            width: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF1E5E5).withOpacity(.22),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/${employee.image}'), // Replace with actual employee image paths
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  employee.name,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3F3E3F),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  employee.service.join(", "),
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    color: const Color(0xFFCACACA),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemCount: employees.length,
      ),
    );
  }

  Container _bottomNavigationBar() => Container(
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
          selectedMenu = index;
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
          child: TweenAnimationBuilder(
            tween: ColorTween(
              begin: Colors.transparent,
              end: selectedMenu == index
                  ? const Color(0xFF818AF9).withOpacity(0.1)
                  : Colors.transparent,
            ),
            duration: const Duration(milliseconds: 250),
            builder: (context, color, child) {
              return Icon(
                menus[index],
                color: selectedMenu == index
                    ? const Color(0xFF818AF9)
                    : const Color(0xFFCACACA).withOpacity(0.6),
              );
            },
          ),
        ),
      ),
    ),
  ),
);


  ListView _employees() {
    return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => _employee(employees[index]),
        separatorBuilder: (context, index) => const SizedBox(height: 11),
        itemCount: employees.length);
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
              )),
          const SizedBox(
            width: 20,
          ),
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
              const SizedBox(
                height: 7,
              ),
              RichText(
                  text: TextSpan(
                      text: "Service: ${employeesModel.service.join(", ")} ",
                      style: GoogleFonts.manrope(
                          fontSize: 12, color: Colors.black))),
              const SizedBox(
                height: 7,
              ),
              Row(children: [
                const Icon(
                  FeatherIcons.phone,
                  size: 14,
                  color: Color(0xFFCACACA),
                ),
                const SizedBox(
                  width: 7,
                ),
                Text("${employeesModel.phone}",
                    style:
                        GoogleFonts.manrope(fontSize: 12, color: Colors.black))
              ]),
              SizedBox(height: 7),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF34C759)),
                  child: Text("Bersedia",
                      style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: Colors.white,
                          height: 150 / 100))),
            ],
          )
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
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: selectedServices == index
                ? Color(0xFF818AF9)
                : const Color(0xFFF6F6F6),
            border: selectedServices == index
                ? Border.all(
                    color: const Color(0xFFF1E5E5).withOpacity(.22),
                    width: 2,
                  )
                : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Text(
            Service.all()[index],
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: selectedServices == index
                  ? Colors.white
                  : const Color(0xFFCACACA).withOpacity(.6),
              height: 150 / 100,
            ),
          )),
        ),
        separatorBuilder: (context, index) => const SizedBox(
          width: 10,
        ),
        itemCount: Service.all().length,
      ),
    );
  }

  Widget _search() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFFF6F6F6),
      ),
      child: TextFormField(
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(FeatherIcons.search,
                color: const Color(0xFFCACACA), size: 20),
            hintText: "Day Care, Walking, and Pet Sitter",
            hintStyle: GoogleFonts.roboto(
                fontSize: 12,
                color: const Color(0xFFCACACA),
                height: 150 / 100)),
      ),
    );
  }

  AspectRatio _card() {
    return AspectRatio(
      aspectRatio: 336 / 184,
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFF818AF9),
        ),
        child: Stack(children: [
          Image.asset('assets/images/Background-card.png',
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: double.maxFinite),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        text: " (Nama Hewan)",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                        children: [
                      TextSpan(
                        text: " akan \nmendapatkan service ",
                        style: GoogleFonts.manrope(
                            fontSize: 15,
                            color: const Color(0xFFDEE1FE),
                            height: 150 / 100),
                      ),
                      TextSpan(text: " (waktu).")
                    ])),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.4),
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.12),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                  child: Text(
                    "See Details",
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
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
            'Hello, Pelanggan!',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: const Color(0xFF3F3E3F),
            ),
          ),
        ],
      ),
    );
    
  }

