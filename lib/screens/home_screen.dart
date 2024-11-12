import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:petcare_mobile/models/employees_model.dart';
import 'package:petcare_mobile/models/service_model.dart';

var selectedServices = 0;

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          const SizedBox(
            height: 20
            ),
            _greetings(),
          const SizedBox(
            height: 20
            ),
            _card(),
          const SizedBox(
            height: 20
            ),
            _search(),
          const SizedBox(
            height: 20,
          ),
          _services(),
          const SizedBox(
            height: 27,
            ),
            _employees(),
          ],
        )
      ),
    );
  }

  ListView _employees() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal:20),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => _employee(employees[index]),
            separatorBuilder: (context, index) => const SizedBox(
              height: 11
            ),
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
              )],
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
                )
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text(employeesModel.name,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3F3E3F)),
                      ),
                    const SizedBox(
                      height: 7,
                    ),
                    RichText(text: TextSpan(
                      
                    ))
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
            padding: EdgeInsets.symmetric(horizontal:20),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,),
              decoration: BoxDecoration(
                color: selectedServices == index
                  ? Color(0xFF818AF9)
                  : const Color(0xFFF6F6F6),
                  border: selectedServices == index ?
                  Border.all(
                    color:
                    const Color(0xFFF1E5E5).withOpacity(.22),
                    width: 2,)
                    : null,
                borderRadius: BorderRadius.circular(10),
                  ),
              child: Center(
                child: Text(Service.all() [index],
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: selectedServices == index
                      ? Colors.white
                      : const Color(0xFFCACACA).withOpacity(.6),
                    height: 150/100,),
              )
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(
              width: 10,),
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
                color: const Color(0xFFCACACA),
                size: 20),
                hintText: "Day Care, Walking, and Pet Sitter",
                hintStyle: GoogleFonts.roboto(
                  fontSize: 12,
                  color: const Color(0xFFCACACA),
                  height: 150/100
                )
              ),
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
              child: Stack(
                children: [
                  Image.asset('assets/images/Background-card.png', 
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                  height: double.maxFinite
                  ),
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
                          height: 150/100),
                        ),
                    TextSpan(
                      text: " \n(nama service)",
                    ),
                        TextSpan(
                          text: " (waktu)."
                          )]
                    )
                  ),
                  const SizedBox(
                    height: 20
                    ),
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
                    ]
                  ),
                ),
              );
      }

  Padding _greetings() {
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Hello, Pelanggan!', style: GoogleFonts.manrope(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: const Color(0xFF3F3E3F)),
                ),
                Stack(
                  children: [
                    IconButton(
                    onPressed: (){
                    //logic untuk notifikasi saat pelanggan melakukan reservasi
                    },
                    icon: const Icon(FeatherIcons.shoppingBag,
                    color:  Color(0xFF818AF9),)
                    ),
                    Positioned(
                      right: 4,
                      top: 6,
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(color: const Color(0xFFEF6497),
                        borderRadius: BorderRadius.circular(15/2)
                        ),
                        child: Center(child: Text("2",
                        style: GoogleFonts.mPlus1p(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800),
                        ),
                      ),
                      ),
                    )
                ])
                ],
            )
          );
  }
}