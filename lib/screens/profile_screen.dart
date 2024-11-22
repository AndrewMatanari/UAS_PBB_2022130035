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
            // Profile picture with shadow and border
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
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

            // Profile details inside a Card with rounded corners
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

            // Edit profile button with elevation and rounded corners
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to edit profile screen
                Navigator.pushNamed(context, '/edit-profile');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF818AF9),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              icon: const Icon(Icons.edit_outlined),
              label: Text(
                "Edit Profile",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Log out button with elevation and rounded corners
            ElevatedButton.icon(
              onPressed: () {
                // Logic for logout
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              icon: const Icon(Icons.logout),
              label: Text(
                "Log Out",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
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

