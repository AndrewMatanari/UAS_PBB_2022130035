import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';


class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          const SizedBox(
            height: 22
            ),
            _greetings(),
          const SizedBox(
            height: 17
            ),
            _card()
          ],
        )
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