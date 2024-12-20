import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false;
  String _userId = "1"; // Replace with actual user ID when using real data
  String _currentProfileImage = ""; // URL or local path to the current profile image

  // Fetch the user data (Replace with actual API call)
  Future<void> _getUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('https://petcare.mahasiswarandom.my.id/api/data-users'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var userData = data.isNotEmpty ? data.last : {};  // Assuming the last user in the list is the one we need
		
        // Now, populate the form fields
        setState(() {
          _nameController.text = userData['name'];
          _emailController.text = userData['email'];
          _phoneController.text = userData['phone'];
          _currentProfileImage = userData['profile_image']; // URL or local path
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching user data')));
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Function to pick the image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Function to update the user profile (Replace with actual API call)
  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final uri = Uri.parse('https://petcare.mahasiswarandom.my.id/api/update-user');
      var request = http.MultipartRequest('POST', uri);

      request.fields['user_id'] = _userId;
      request.fields['name'] = _nameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['phone'] = _phoneController.text;

      if (_profileImage != null) {
        var profileImageFile = await http.MultipartFile.fromPath('profile_image', _profileImage!.path);
        request.files.add(profileImageFile);
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating profile')));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData(); // Fetch user data when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: GoogleFonts.manrope(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!) // Display picked image
                              : (_currentProfileImage.isNotEmpty
                                  ? NetworkImage(_currentProfileImage) // Use the profile image URL
                                  : AssetImage('assets/default_profile.png') as ImageProvider), // Default image
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Name',
                      style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(hintText: _nameController.text.isEmpty ? 'Enter your name' : _nameController.text),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Email',
                      style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(hintText: _emailController.text.isEmpty ? 'Enter your email' : _emailController.text),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Phone Number',
                      style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(hintText: _phoneController.text.isEmpty ? 'Enter your phone number' : _phoneController.text),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Save Changes', style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

