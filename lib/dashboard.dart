import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'findthematch.dart';
import 'editprofile.dart';
import 'message.dart';
import 'openstreetmap_search_page.dart';
import 'explore.dart';

class DashboardPage extends StatefulWidget {
  final String? userName;
  final String? profileImagePath;
  final String? userLocation;

  const DashboardPage({
    Key? key,
    this.userName,
    this.profileImagePath,
    this.userLocation,
  }) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? uploadedImagePath;
  String? userName;
  String? userLocation;
  List<String> userNotes = [];

  final Color pink = const Color(0xFFF45A62);
  final Color babyPink = const Color(0xFFFFEDEF);

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    uploadedImagePath = widget.profileImagePath;
    userName = widget.userName;
    userLocation = widget.userLocation;
  }

  Future<void> _openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          name: userName ?? '',
          dob: '',
          initialImage: uploadedImagePath,
          initialLocation: userLocation,
          initialGalleryImages: [],
          initialNotes: userNotes,
          initialDob: '',
          initialName: userName,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        uploadedImagePath = result['image'] ?? uploadedImagePath;
        userName = result['name'] ?? userName;
        userLocation = result['location'] ?? userLocation;
        if (result['notes'] != null && result['notes'] is List<String>) {
          userNotes = List<String>.from(result['notes']);
        }
      });
    }
  }

  void _showAddNoteDialog() {
    String newNote = "";
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Add Note", style: TextStyle(color: pink)),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: "Write your note here"),
          onChanged: (val) => newNote = val,
        ),
        actions: [
          TextButton(
            child: Text("Add", style: TextStyle(color: pink, fontWeight: FontWeight.bold)),
            onPressed: () {
              if (newNote.trim().isNotEmpty) {
                setState(() {
                  userNotes.insert(0, newNote.trim());
                });
              }
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _showNotes() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Your Notes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (userNotes.isEmpty)
              const Text("No notes added yet.", style: TextStyle(color: Colors.grey)),
            if (userNotes.isNotEmpty)
              ...userNotes.map(
                (note) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.note, color: pink, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(note, style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showAddNoteDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: pink,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
              ),
              child: const Text("Add a new note"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Row(
            children: [
              const Icon(Icons.menu, size: 28, color: Colors.black87),
              const SizedBox(width: 10),
              Text(
                userLocation ?? "lovelorn",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: pink,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: _showNotes,
              child: Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: pink,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [BoxShadow(color: pink.withOpacity(0.2), blurRadius: 10)],
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: _openEditProfile,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: pink,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [BoxShadow(color: pink.withOpacity(0.2), blurRadius: 10)],
                ),
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildProfileCircle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 170,
          height: 170,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: pink.withOpacity(0.15),
          ),
        ),
        CircleAvatar(
          radius: 80,
          backgroundColor: Colors.white,
          backgroundImage: (uploadedImagePath != null && uploadedImagePath!.isNotEmpty)
              ? (uploadedImagePath!.startsWith("http")
                  ? NetworkImage(uploadedImagePath!)
                  : FileImage(File(uploadedImagePath!))) as ImageProvider
              : null,
          child: (uploadedImagePath == null || uploadedImagePath!.isEmpty)
              ? Icon(Icons.person, size: 80, color: Colors.grey[400])
              : null,
        ),
        Positioned(
          bottom: 20,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: pink,
            child: const Icon(Icons.favorite, color: Colors.white),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: pink),
              child: const Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      backgroundColor: babyPink,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildTopBar(),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Hi, ",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: pink),
                  ),
                  Flexible(
                    child: Text(
                      userName ?? "User",
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(child: _buildProfileCircle()),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  Text(
                    "in this chaos\nlet's find your cosmos!",
                    style: TextStyle(
                        fontSize: 22, color: pink, fontWeight: FontWeight.w600, height: 1.3),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const FindTheMatchPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: pink,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        "Find a match",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ExplorePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: pink,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        "Explore",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: pink,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.home, color: Colors.white)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.explore, color: Colors.white)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.white)),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MessagePage()),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.person, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
