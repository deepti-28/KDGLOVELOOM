import 'package:flutter/material.dart';
import 'register.dart';
import 'dashboard.dart';
import 'login.dart';
import 'editprofile.dart';
import 'findthematch.dart';
import 'message.dart';
import 'chat.dart';
import 'note_dialog.dart'; // Adjusted name to match NoteDialogPage file
import 'openstreetmap_search_page.dart';
import 'explore.dart';
import 'userprofile.dart';
import 'userdata.dart';
import 'splash_page.dart';
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
        '/note_dialogue': (context) => const NoteDialogPage(placeId: ''), // Temporary default placeId
        '/note': (context) => const NoteDialogPage(placeId: ''), // For backward compatibility if needed
        '/findthematch': (context) => const FindTheMatchPage(),
        '/message': (context) => const MessagePage(),
        '/chat': (context) => ChatPage(contactUsername: '', contactAvatarUrl: ''),
        '/openstreetmap_search_page': (context) => OpenStreetMapSearchPage(),
        '/explore': (context) => const ExplorePage(),
        // Removed fixed /userprofile route to use onGenerateRoute below
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
              initialName: args['name'] as String? ?? '',
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
        if (settings.name == '/userprofile') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          return MaterialPageRoute(
            builder: (context) => UserProfilePage(
              avatarUrl: args['avatarUrl'] ?? '',
              username: args['username'] ?? '',
              name: args['name'] ?? '',
              location: args['location'] ?? '',
              age: args['age'] ?? 0,
              aboutMe: args['aboutMe'] ?? '',
              galleryImages: (args['galleryImages'] as List<dynamic>?)?.cast<String>() ?? const [],
            ),
          );
        }
        if (settings.name == '/note_dialogue') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          final placeId = args['placeId'] as String? ?? '';
          return MaterialPageRoute(
            builder: (context) => NoteDialogPage(placeId: placeId),
          );
        }
        return null;
      },
    );
  }
}
