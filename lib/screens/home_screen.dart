import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20
              ),
              child: Row(
                children: [
                Text('Hello, Pelanggan!', style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  color: const Color(0xFF3F3E3F)),
                  ),],
              )
            )
      ])
      ),
    );
  }
}