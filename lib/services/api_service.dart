import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as path;

// For Android emulator localhost access use 10.0.2.2, update in production deployment
const String baseUrl = 'http://10.0.2.2:5000/api';

final storage = FlutterSecureStorage();

class ApiService {
  // Login user and save JWT token securely
  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['token'] != null) {
        await storage.write(key: 'jwt', value: data['token']);
        return true;
      }
    }
    return false;
  }

  // Get stored JWT token
  Future<String?> getToken() async => await storage.read(key: 'jwt');

  // Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    final token = await getToken();
    if (token == null) throw Exception('User not authenticated');

    final url = Uri.parse('$baseUrl/user/profile');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load profile');
  }

  // Upload profile image
  Future<String?> uploadProfileImage(File imageFile) async {
    final token = await getToken();
    if (token == null) throw Exception('User not authenticated');

    final uri = Uri.parse('$baseUrl/user/uploadProfileImage');

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();

    var multipartFile =
        http.MultipartFile('profileImage', stream, length, filename: path.basename(imageFile.path));

    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonResp = jsonDecode(respStr);
      if (jsonResp['imageUrl'] != null) {
        return jsonResp['imageUrl'];
      }
    } else {
      print('Image upload failed with status: ${response.statusCode}');
    }
    return null;
  }

  // Update user profile info
  Future<bool> updateProfile({
    String? name,
    String? location,
    String? profileImagePath,
    String? dob,
    String? username,
    List<String>? galleryImages,
    List<String>? notes,
  }) async {
    final token = await getToken();
    if (token == null) throw Exception('User not authenticated');

    final url = Uri.parse('$baseUrl/user/profile');

    Map<String, dynamic> data = {};
    if (name != null && name.isNotEmpty) data['name'] = name;
    if (location != null && location.isNotEmpty) data['location'] = location;
    if (profileImagePath != null && profileImagePath.isNotEmpty) data['profileImagePath'] = profileImagePath;
    if (dob != null && dob.isNotEmpty) data['dob'] = dob;
    if (username != null && username.isNotEmpty) data['username'] = username;
    if (galleryImages != null) data['galleryImages'] = galleryImages;
    if (notes != null) data['notes'] = notes;

    final response = await http.patch(
      url,
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      print('Profile update failed: ${response.statusCode} - ${response.body}');
    }
    return false;
  }

  // Logout
  Future<void> logout() async {
    await storage.delete(key: 'jwt');
  }

  // --- Place related methods ---

  // Get list of places
  Future<List<dynamic>> getPlaces() async {
    final url = Uri.parse('$baseUrl/places');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load places');
    }
  }

  // Get place details by ID
  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    final url = Uri.parse('$baseUrl/places/$placeId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load place details');
    }
  }

  // Like or unlike place by placeId - requires auth
  Future<bool> toggleLikePlace(String placeId) async {
    final token = await getToken();
    if (token == null) throw Exception('User not authenticated');

    final url = Uri.parse('$baseUrl/places/$placeId/like');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Toggle like failed: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  // Get notes for a place
  Future<List<dynamic>> getPlaceNotes(String placeId) async {
    final url = Uri.parse('$baseUrl/places/$placeId/notes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load place notes');
    }
  }

  // Add note to a place - requires auth
  Future<bool> addPlaceNote(String placeId, String text) async {
    final token = await getToken();
    if (token == null) throw Exception('User not authenticated');

    final url = Uri.parse('$baseUrl/places/$placeId/notes');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Add note failed: ${response.statusCode} - ${response.body}');
      return false;
    }
  }
}
