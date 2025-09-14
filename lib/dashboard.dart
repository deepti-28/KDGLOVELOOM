import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'findthematch.dart';  // Import FindTheMatchPage
import 'editprofile.dart';
import 'message.dart';  // Import MessagePage
import 'openstreetmap_search_page.dart'; // Import your new OpenStreetMap search screen

class DashboardPage extends StatefulWidget {
  final String? userName;
  final String? profileImagePath;

  const DashboardPage({Key? key, this.userName, this.profileImagePath}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? uploadedImagePath;

  // Sample users list; replace with backend data as needed
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    uploadedImagePath = widget.profileImagePath;
  }

  void _openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          name: widget.userName ?? 'User',
          dob: '',
          initialName: widget.userName,
          initialDob: '',
        ),
      ),
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        uploadedImagePath = result['image'] ?? uploadedImagePath;
      });
    }
  }

  // Open OpenStreetMap search page
  void _openMapSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OpenStreetMapSearchPage()),
    );
  }

  // Fetch nearby users from backend
  Future<List<Map<String, dynamic>>> fetchUsersForArea(LatLng areaLatLng) async {
    final url = Uri.parse(
        'http://10.0.2.2:3000/users-nearby?lat=${areaLatLng.latitude}&lon=${areaLatLng.longitude}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print('Fetch users error: $e');
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final pink = const Color(0xFFF45B62);

    final topRightIcons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _openEditProfile,  // "+" button opens Edit Profile now
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: pink,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.1),
              boxShadow: [
                BoxShadow(color: pink.withOpacity(0.17), spreadRadius: 8, blurRadius: 20),
              ],
            ),
            child: const Icon(Icons.add, size: 26, color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _openEditProfile,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: pink,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.1),
              boxShadow: [
                BoxShadow(color: pink.withOpacity(0.17), spreadRadius: 8, blurRadius: 20),
              ],
            ),
            child: const Icon(Icons.person, size: 26, color: Colors.white),
          ),
        ),
      ],
    );

    final profileCircle = Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 178,
          height: 178,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: pink.withOpacity(0.12),
          ),
        ),
        DottedBorder(
          dashPattern: const [6, 5],
          strokeWidth: 3,
          color: pink,
          borderType: BorderType.Circle,
          padding: EdgeInsets.zero,
          child: CircleAvatar(
            radius: 87,
            backgroundColor: Colors.white,
            backgroundImage:
                (uploadedImagePath != null) ? FileImage(File(uploadedImagePath!)) : null,
            child: (uploadedImagePath == null)
                ? Icon(Icons.person, size: 70, color: Colors.grey[400])
                : null,
          ),
        ),
        Positioned(
          bottom: 15,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: pink,
            child: const Icon(Icons.favorite, color: Colors.white, size: 27),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.menu, size: 28, color: Colors.black87),
                      SizedBox(width: 12),
                      Text(
                        "New Delhi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  topRightIcons,
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 90),
                Padding(
                  padding: const EdgeInsets.only(left: 23),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: "Hi, ",
                        style: TextStyle(
                          color: pink,
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
                          fontFamily: 'Nunito',
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.userName ?? "User",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 21,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                profileCircle,
                const SizedBox(height: 40),
                Column(
                  children: [
                    Text(
                      "in this chaos let's find your",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        fontFamily: 'Nunito',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "cosmos!",
                      style: TextStyle(
                        color: pink,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 37),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(33),
                            ),
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(vertical: 19),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => OpenStreetMapSearchPage()),
                            );
                          },
                          child: const Text(
                            'Find a match',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(33),
                            ),
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(vertical: 19),
                          ),
                          onPressed: () {
                            // You can define behavior for Explore button here if desired
                          },
                          child: const Text(
                            'Explore',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 64,
        decoration: BoxDecoration(
          color: pink,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
          boxShadow: [
            BoxShadow(
              color: pink.withOpacity(0.11),
              blurRadius: 18,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(Icons.home, size: 26, color: Colors.white),
                const Icon(Icons.explore, size: 26, color: Colors.white),
                const Icon(Icons.search, size: 30, color: Colors.white),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, size: 26, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MessagePage()),
                    );
                  },
                ),
                const Icon(Icons.person, size: 26, color: Colors.white),
              ],
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
