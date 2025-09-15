import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as path;

// For Android emulator accessing localhost, use 10.0.2.2
// Replace with your real backend URL when deployed
const String baseUrl = 'http://10.0.2.2:5000/api';

final storage = FlutterSecureStorage();

class ApiService {
  // Login user with email and password
  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Save JWT token securely for later use
      await storage.write(key: 'jwt', value: data['token']);
      return true;
    } else {
      return false;
    }
  }

  // Fetch user profile data using stored JWT token
  Future<Map<String, dynamic>> getUserProfile() async {
    final token = await storage.read(key: 'jwt');
    final url = Uri.parse('$baseUrl/user/profile');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  // Fetch gallery images list with authorization
  Future<List<dynamic>> getGallery() async {
    final token = await storage.read(key: 'jwt');
    final url = Uri.parse('$baseUrl/gallery');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load gallery');
    }
  }

  // Upload user profile image
  Future<String?> uploadProfileImage(File imageFile) async {
    final token = await storage.read(key: 'jwt');
    final uri = Uri.parse('$baseUrl/user/uploadProfileImage');

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();

    var multipartFile = http.MultipartFile(
      'profileImage',
      stream,
      length,
      filename: path.basename(imageFile.path),
    );

    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonResp = jsonDecode(respStr);
      if (jsonResp['imageUrl'] != null) {
        return jsonResp['imageUrl'];
      } else {
        return null;
      }
    } else {
      print('Image upload failed with status: ${response.statusCode}');
      return null;
    }
  }

  // Update user profile info, including optionally profile photo URL
  Future<bool> updateProfile({
    String? name,
    String? location,
    String? profileImagePath,
    String? dob,
    String? username,
    List<String>? galleryImages,
    List<String>? notes,
  }) async {
    final token = await storage.read(key: 'jwt');
    final url = Uri.parse('$baseUrl/user/profile');

    Map<String, dynamic> data = {};
    if (name != null && name.isNotEmpty) data['name'] = name;
    if (location != null && location.isNotEmpty) data['location'] = location;
    // Send profileImagePath only if not null and not empty string
    if (profileImagePath != null && profileImagePath.isNotEmpty) {
      data['profileImagePath'] = profileImagePath;
    }
    if (dob != null && dob.isNotEmpty) data['dob'] = dob;
    if (username != null && username.isNotEmpty) data['username'] = username;
    if (galleryImages != null) data['galleryImages'] = galleryImages;
    if (notes != null) data['notes'] = notes;

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Profile update failed: ${response.statusCode} - ${response.body}');
      return false;
    }
  }
}
