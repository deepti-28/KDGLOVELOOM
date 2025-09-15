import 'package:latlong2/latlong.dart';

class User {
  final String name;
  final LatLng location;
  final String profileImageUrl;
  final String notes;

  const User({
    required this.name,
    required this.location,
    required this.profileImageUrl,
    required this.notes,
  });
}

final List<User> users = [
  User(
    name: "RIYA",
    location: LatLng(28.643430031477237, 77.07278678504603),
    profileImageUrl: "https://randomuser.me/api/portraits/women/10.jpg",
    notes: "I am passionate about photography and travel.",
  ),
  User(
    name: "SHRISHTI",
    location: LatLng(28.64264087739207, 77.07806716776741),
    profileImageUrl: "https://randomuser.me/api/portraits/women/11.jpg",
    notes: "I love baking and painting.",
  ),
  User(
    name: "AMAN",
    location: LatLng(28.642424890063463, 77.0764554951324),
    profileImageUrl: "https://randomuser.me/api/portraits/men/12.jpg",
    notes: " I enjoy cycling and gaming.",
  ),
];
