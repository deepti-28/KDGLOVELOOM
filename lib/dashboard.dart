import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'findthematch.dart';
import 'editprofile.dart';
import 'message.dart';
import 'openstreetmap_search_page.dart';
import 'explore.dart';
import 'userprofile.dart'; // Added import for UserProfilePage
import 'note_dialog.dart'; // Import for the new NoteDialog

class DashboardPage extends StatefulWidget {
  final String? userName;
  final String? profileImagePath;

  const DashboardPage({Key? key, this.userName, this.profileImagePath})
      : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? uploadedImagePath;
  List<Map<String, dynamic>> users = [];
  List<String> userNotes = [];

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

  void _openMapSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OpenStreetMapSearchPage()),
    );
  }

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

  Future<void> _openNoteDialog() async {
    final newNote = await showDialog<String>(
      context: context,
      builder: (ctx) => NoteDialogPage(placeId: '1' ),
    );

    if (newNote != null && newNote.trim().isNotEmpty) {
      setState(() {
        userNotes.insert(0, newNote.trim());
      });
    }
  }

  void _showNoteList() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Your Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (userNotes.isEmpty)
              const Text('No notes added yet.', style: TextStyle(color: Colors.black45)),
            if (userNotes.isNotEmpty)
              ...userNotes.map((note) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.note, color: Color(0xFFF45B62), size: 21),
                    const SizedBox(width: 8),
                    Expanded(child: Text(note, style: const TextStyle(fontSize: 16))),
                  ],
                ),
              )),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF45B62),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
              ),
              onPressed: _showAddNoteDialog,
              child: const Text('Add a new note'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteDialog() async {
    String newNote = '';
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add a note', style: TextStyle(color: Color(0xFFF45B62))),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: "Type your note here"),
          onChanged: (val) => newNote = val,
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF45B62),
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
            onPressed: () {
              if (newNote.trim().isNotEmpty) {
                setState(() => userNotes.insert(0, newNote.trim()));
              }
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pink = const Color(0xFFF45B62);
    final babyPink = const Color(0xFFFFE4EF);

    final topRightIcons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _openNoteDialog,
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserProfilePage(
                  avatarUrl: uploadedImagePath ?? '',
                  username: widget.userName ?? '',
                  name: widget.userName ?? '',
                  location: '',
                  age: 0,
                  aboutMe: '',
                  galleryImages: [],
                ),
              ),
            );
          },
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: pink),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: pink),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: pink),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: pink),
              title: const Text("About"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: pink),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: babyPink,
      body: SafeArea(
        child: Container(
          color: babyPink,
          child: Stack(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      child: Row(
                        children: [
                          const Icon(Icons.menu, size: 28, color: Colors.black87),
                          const SizedBox(width: 12),
                          Text(
                            "loveloom",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: pink,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
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
                  const SizedBox(height: 22),
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
                      const SizedBox(height: 23),
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
                              MaterialPageRoute(
                                  builder: (_) => OpenStreetMapSearchPage()),
                            );
                          },
                          child: const Text(
                            'Find your match',
                            style: TextStyle(
                              color: Colors.white,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ExplorePage()),
                            );
                          },
                          child: const Text(
                            'Explore',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, size: 26, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.explore, size: 26, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => OpenStreetMapSearchPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.search, size: 30, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExplorePage()),
                );
              },
            ),
            IconButton(
              icon:
              const Icon(Icons.chat_bubble_outline, size: 26, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MessagePage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, size: 26, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserProfilePage(
                      avatarUrl: uploadedImagePath ?? '',
                      username: widget.userName ?? '',
                      name: widget.userName ?? '',
                      location: '',
                      age: 0,
                      aboutMe: '',
                      galleryImages: [],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
