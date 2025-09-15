import 'package:flutter/material.dart';
import 'register.dart';
import 'dashboard.dart';
import 'login.dart';
import 'editprofile.dart';
import 'findthematch.dart';
import 'message.dart';
import 'chat.dart';
import 'splash_page.dart';
import 'note_dialog.dart';
import 'userdata.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoveLoom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Nunito',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/note': (context) => const NoteMapPage(),
        '/findthematch': (context) => const FindTheMatchPage(),
        '/message': (context) => const MessagePage(),
        '/chat': (context) => ChatPage(
          contactUsername: '', contactAvatarUrl: '',
        ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/editprofile') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          return MaterialPageRoute(
            builder: (context) => EditProfilePage(
              name: args['name'] as String? ?? '',
              initialDob: args['dob'] as String? ?? '',
              initialImage: args['image'] as String?,
              initialLocation: args['location'] as String?,
              initialGalleryImages: (args['galleryImages'] as List<dynamic>?)?.cast<String>(),
              initialNotes: (args['notes'] as List<dynamic>?)?.cast<String>(),
            ),
          );
        }
        if (settings.name == '/chat') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          return MaterialPageRoute(
            builder: (context) => ChatPage(
              contactUsername: args['contactUsername'] ?? '',
              contactAvatarUrl: args['contactAvatarUrl'] ?? '',
            ),
          );
        }
        return null;
      },
    );
  }
}

class NoteMapPage extends StatefulWidget {
  const NoteMapPage({Key? key}) : super(key: key);

  @override
  State<NoteMapPage> createState() => _NoteMapPageState();
}

class _NoteMapPageState extends State<NoteMapPage> {
  List<String> droppedNotes = [];

  // Center map on Vikaspuri, Delhi
  final LatLng vikaspuriCenter = LatLng(28.6430, 77.0750);
  final double vikaspuriZoom = 16.5;

  void _showNoteDialog() async {
    String? note = await showDialog<String>(
      context: context,
      builder: (_) => NoteDialog(),
    );
    if (note != null && note.trim().isNotEmpty) {
      setState(() {
        droppedNotes.add(note);
      });
    }
  }

  void _openChat(user) {
    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {
        'contactUsername': user.name,
        'contactAvatarUrl': user.profileImageUrl,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("=== USER DEBUG OUTPUT ===");
    print(users);
    print("Total users: ${users.length}");
    for (var user in users) {
      print("User: ${user.name} at ${user.location}");
    }
    print("=========================");

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(center: vikaspuriCenter, zoom: vikaspuriZoom),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: users.map((user) {
                  print('Rendering marker for user: ${user.name}, ${user.location}');
                  return Marker(
                    width: 70,
                    height: 70,
                    point: user.location,
                    builder: (_) => GestureDetector(
                      onTap: () => _openChat(user),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.amber, // Gold highlight ring
                            width: 5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(user.profileImageUrl),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          droppedNotes.isNotEmpty
              ? Positioned(
                  top: 50,
                  left: 15,
                  right: 15,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(droppedNotes.last),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNoteDialog,
        child: const Icon(Icons.add),
        tooltip: "Drop a note",
      ),
    );
  }
}
