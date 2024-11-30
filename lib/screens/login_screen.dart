import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart'; // Ganti dengan jalur file HomeScreen Anda
import 'signup_screen.dart'; // Ganti dengan jalur file SignupScreen Anda

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/logo.svg',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Welcome Back!',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: const Color(0xFF3F3E3F),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Please log in to your account',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: const Color(0xFF3F3E3F),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildPasswordField(),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : _buildLoginButton(context),
                  const SizedBox(height: 20),
                  _buildGoogleLoginButton(context),
                  const SizedBox(height: 20),
                  _buildSignUpLink(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        border: const OutlineInputBorder(),
        hintText: 'Enter your email',
        prefixIcon: const Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(),
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            _isLoading = true;
          });

          try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

            // Navigasi ke HomeScreen setelah login berhasil
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) =>  HomeScreen()),
            );
          } catch (e) {
            _showErrorDialog(context, 'Login failed: ${e.toString()}');
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        backgroundColor: const Color(0xFF818AF9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Login',
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildGoogleLoginButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        try {
          final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
          if (googleUser == null) {
            return; // Pengguna membatalkan login
          }

          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;

          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          await FirebaseAuth.instance.signInWithCredential(credential);

          // Navigasi ke HomeScreen setelah login berhasil
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>  HomeScreen()),
          );
        } catch (e) {
          _showErrorDialog(context, 'Google login failed: ${e.toString()}');
        }
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
        'Login with Google',
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: const Color(0xFF818AF9),
        ),
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SignupScreen(),
          ),
        );
      },
      child: Text(
        'Don\'t have an account? Sign Up',
        style: GoogleFonts.manrope(
          fontSize: 14,
          color: const Color(0xFF818AF9),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
