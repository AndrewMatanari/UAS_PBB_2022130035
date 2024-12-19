import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:petcare_mobile/screens/splash_screen.dart';
import 'package:petcare_mobile/screens/login_screen.dart';
import 'package:petcare_mobile/screens/profile_screen.dart';
import 'package:petcare_mobile/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) =>  LoginScreen(),
        '/profile': (context) =>  ProfileScreen(),
        '/home': (context) =>  HomeScreen(),
        
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
