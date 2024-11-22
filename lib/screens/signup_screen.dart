import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petcare_mobile/screens/home_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tambahkan logo di sini
                SvgPicture.asset(
                  'assets/svg/logo.svg', // Ganti dengan path logo Anda
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 40),
                Text(
                  'Create Account',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: const Color(0xFF3F3E3F),
                  ),
                ),
                const SizedBox(height: 20),
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 20),
                _buildConfirmPasswordField(),
                const SizedBox(height: 40),
                _buildSignupButton(context),
                const SizedBox(height: 20),
                _buildGoogleSignupButton(context), // Pass context
                const SizedBox(height: 20),
                _buildLoginLink(context), // Link untuk kembali ke login
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        hintText: 'Enter your email',
        prefixIcon: const Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        border: OutlineInputBorder(),
        hintText: 'Re-enter your password',
        prefixIcon: const Icon(Icons.lock),
      ),
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Logika untuk mendaftar
        // Misalnya, validasi dan navigasi ke halaman utama
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        backgroundColor: const Color(0xFF818AF9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Sign Up',
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildGoogleSignupButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        signUpWithGoogle(context); // Panggil fungsi pendaftaran Google
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFF818AF9)),
        ),
      ),
      icon: Image.asset(
        'assets/images/Google.png',
        height: 24,
      ),
      label: Text(
        'Sign Up with Google',
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: const Color(0xFF818AF9),
        ),
      ),
    );
  }

  Future<void> signUpWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser  = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser ?.authentication;

      if (googleAuth != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        print(userCredential.user?.displayName);
        
        // Navigasi ke HomeScreen setelah pendaftaran berhasil
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>  HomeScreen()),
        );
      }
    } catch (error) {
      print(error); // Anda bisa menampilkan pesan kesalahan di UI
    }
  }

  Widget _buildLoginLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // Kembali ke halaman login
      },
      child: Text(
        'Already have an account? Login',
        style: GoogleFonts.manrope(
          fontSize: 14,
          color: const Color(0xFF818AF9),
        ),
      ),
    );
  }
}
