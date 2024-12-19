import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';
import 'register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String errorMessage = '';

  Future<void> loginUser() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // Validasi form di sisi aplikasi
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      errorMessage = ''; // Reset error message
    });

    final url = Uri.parse('https://petcare.mahasiswarandom.my.id/api/login'); // URL API Laravel untuk login
    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Memastikan respons memiliki 'token'
        if (data['token'] != null) {
          final token = data['token'];

          // Memastikan respons memiliki user data
          if (data['user'] != null) {
            final user = data['user'];
            final userId = user['id'];
            final userName = user['name'];

            // Simpan token dan userId ke SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', token); // Store token
            await prefs.setInt('userId', userId); // Store userId
            await prefs.setString('userName', userName); // Store userName

            // Navigasi ke HomeScreen setelah login berhasil
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            setState(() {
              errorMessage = 'User data not found, please try again.';
            });
          }
        } else {
          setState(() {
            errorMessage = 'Token not found, please try again.';
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage = 'Invalid credentials, please check your email and password.';
        });
      } else {
        setState(() {
          errorMessage = 'An unexpected error occurred. Please try again later.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
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
      onPressed: loginUser,
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

  Widget _buildSignUpLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RegisterScreen(),
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
}
