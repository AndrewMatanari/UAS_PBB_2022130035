import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                  height: double.maxFinite),
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