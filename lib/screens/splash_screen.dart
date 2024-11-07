import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                height: 30
              ),
              SvgPicture.asset('assets/svg/logo.svg', width: 300, height: 300,
              ),
              const Text.rich(TextSpan(text: "Membantu anda untuk memelihara",
              children: [
                TextSpan(text: " beban keluarga anda"),
                TextSpan(text: "\ndengan senang hati.")]
              ),
              textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

