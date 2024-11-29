import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  // Mock user profile data
  final String userName = "John Doe";
  final String userEmail = "john.doe@example.com";
  final String userPhone = "+1 234 567 890";
  final String userAddress = "1234 Main St, Springfield, IL";
  final String userProfilePhotoUrl = "https://via.placeholder.com/150"; // Example URL for profile photo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF5F5F9F),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.blueGrey.shade50,
            ],
          ),
        ),
        child: ListView(
          children: [
            // Profile picture with smooth shadow and border
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(userProfilePhotoUrl),
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Profile details inside a Card with rounded corners and gradient background
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileDetail(title: "Name", value: userName),
                    const SizedBox(height: 12),
                    _buildProfileDetail(title: "Email", value: userEmail),
                    const SizedBox(height: 12),
                    _buildProfileDetail(title: "Phone Number", value: userPhone),
                    const SizedBox(height: 12),
                    _buildProfileDetail(title: "Address", value: userAddress),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Edit profile button with smooth animation, elevation, and rounded corners
            AnimatedButton(
              onPressed: () {
                // Navigate to edit profile screen
                Navigator.pushNamed(context, '/edit-profile');
              },
              label: "Edit Profile",
              icon: Icons.edit_outlined,
              backgroundColor: const Color(0xFF818AF9),
            ),
            const SizedBox(height: 20),

            // Log out button with smooth animation, elevation, and rounded corners
            AnimatedButton(
              onPressed: () {
                // Logic for logout
                _logout(context);
              },
              label: "Log Out",
              icon: Icons.logout,
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display profile information in a row
  Widget _buildProfileDetail({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "$title: ",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5F5F9F),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF333333),
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  // Mock logout function
  void _logout(BuildContext context) {
    // Perform logout logic here (e.g., clearing session, navigating to login screen)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Logged out successfully!"),
      ),
    );

    // Navigate to login screen or home screen
    // Navigator.pushReplacementNamed(context, '/login'); // Example navigation
  }
}

// Custom animated button widget for edit and logout
class AnimatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Color backgroundColor;

  const AnimatedButton({
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.15),
      ),
      icon: Icon(icon),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
