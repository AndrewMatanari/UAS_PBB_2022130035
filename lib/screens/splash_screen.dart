import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petcare_mobile/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    Future.delayed(const Duration(seconds: 3)).then((value){
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
      ),
          (route) => false);
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 20
              ),
              SvgPicture.asset('assets/svg/logo.svg', width: 200, height: 200,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Siap melayani untuk \nmemelihara",
                  style: GoogleFonts.manrope(
                    fontSize: 30,
                    color: const Color(0xFFDEE1FE),
                    letterSpacing: 3.5/100,
                    height: 152/100
                  ),
                  children: [
                    TextSpan(text: " beban keluarga anda",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                    ),
                    TextSpan(text: " dengan senang hati.")]
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

