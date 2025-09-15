import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'userdata.dart'; // users list
import 'chat.dart'; // Import chat page

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final LatLng initialCenter = LatLng(28.6430, 77.0750); // Center near your users
  final double initialZoom = 16.5; // Enough to see all bubbles

  @override
  void initState() {
    super.initState();
    print("=== USER DEBUG OUTPUT ===");
    print(users);
    print("Total users: ${users.length}");
    for (var u in users) {
      print("User: ${u.name} at ${u.location}");
    }
    print("=========================");
  }

  void _openChat(user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          contactUsername: user.name,
          contactAvatarUrl: user.profileImageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vikaspuri Users')),
      body: FlutterMap(
        options: MapOptions(
          center: initialCenter,
          zoom: initialZoom,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: users.map(
              (user) {
                print('Rendering marker for user: ${user.name}, ${user.location}');
                return Marker(
                  width: 70,
                  height: 70,
                  point: user.location,
                  builder: (_) => GestureDetector(
                    onTap: () => _openChat(user),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.amber,
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
                        if (user.replyCount > 0)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 19,
                              height: 19,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                "${user.replyCount}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
