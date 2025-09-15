import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showPassword = false;
  bool rememberMe = false;

  String name = '';
  String username = '';
  String password = '';
  String email = '';
  String day = '16';
  String month = '04';
  String year = '1998';

  final Map<String, bool> genders = {
    'Male': false,
    'Female': false,
    'Others': false,
  };

  final List<String> days =
      List.generate(31, (i) => (i + 1).toString().padLeft(2, '0'));
  final List<String> months =
      List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
  final List<String> years =
      List.generate(100, (i) => (DateTime.now().year - i).toString());

  final Color pink = const Color(0xFFF45B5B);
  final Color gray = const Color(0xFF444444);
  final Color backgroundGray = const Color(0xFFF9F9F9);

  String? nameError;
  String? usernameError;
  String? passwordError;
  String? emailError;
  String? genderError;

  bool _isLoading = false;
  String? _registerError;

  static const String baseUrl = 'http://10.0.2.2:5000/api';

  Future<bool> register({
    required String name,
    required String username,
    required String password,
    required String email,
    required String gender,
    required String dob,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'username': username,
        'password': password,
        'email': email,
        'gender': gender, // Now this will be lowercase
        'dob': dob,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('Registration failed: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Container(
            width: 290,
            height: 270,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: pink.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(Icons.person, size: 64, color: pink),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  "Registered\nSuccessfully",
                  style: TextStyle(
                      color: Color(0xFFF45B6B),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      height: 1.17),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.of(context, rootNavigator: true).pop();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/editprofile', arguments: {
          'name': name,
          'dob': "$day/$month/$year",
        });
      });
    });
  }

  bool _validateEmail(String em) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(em);
  }

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
      _registerError = null;
    });

    try {
      String selectedGender = genders.entries.firstWhere((e) => e.value).key;
      String genderForBackend = selectedGender.toLowerCase(); // convert to lowercase

      bool success = await register(
        name: name.trim(),
        username: username.trim(),
        password: password,
        email: email.trim(),
        gender: genderForBackend,
        dob: "$year-$month-$day",
      );

      if (success) {
        _showSuccessDialog();
      } else {
        setState(() {
          _registerError = "Registration failed. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _registerError = "Error: ${e.toString()}";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onRegister() {
    setState(() {
      nameError = null;
      usernameError = null;
      passwordError = null;
      emailError = null;
      genderError = null;
      _registerError = null;

      if (name.trim().isEmpty) {
        nameError = "Please fill this";
      }
      if (username.trim().isEmpty) {
        usernameError = "Please fill this";
      }
      if (password.trim().isEmpty) {
        passwordError = "Please fill this";
      } else if (password.length < 6) {
        passwordError = "Password must be at least 6 characters";
      }
      if (email.trim().isEmpty) {
        emailError = "Please fill this";
      } else if (!_validateEmail(email.trim())) {
        emailError = "Invalid email";
      }
      if (!genders.containsValue(true)) {
        genderError = "Select at least one";
      }
    });

    if ([nameError, usernameError, passwordError, emailError, genderError]
        .any((e) => e != null)) {
      return;
    }
    _registerUser();
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
    String? errorText,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600)),
          TextField(
            obscureText: obscureText,
            onChanged: onChanged,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: pink),
              hintText: hint,
              hintStyle: TextStyle(color: pink.withOpacity(0.5)),
              filled: true,
              fillColor: Colors.white,
              errorText: errorText,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: pink, width: 2),
              ),
              suffixIcon: suffixIcon,
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      {required String currentValue,
      required List<String> items,
      required ValueChanged<String?> onChanged}) {
    return Container(
      width: 90,
      height: 50,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        border: Border.all(color: pink.withOpacity(0.5)),
      ),
      child: DropdownButton<String>(
        value: currentValue,
        isExpanded: true,
        underline: const SizedBox(),
        onChanged: onChanged,
        items: items.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: genders.keys.map((gender) {
              return Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: genders[gender],
                      onChanged: (val) {
                        setState(() {
                          genders.updateAll((key, value) => false);
                          genders[gender] = val ?? false;
                        });
                      },
                      activeColor: pink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    Text(gender),
                  ],
                ),
              );
            }).toList(),
          ),
          if (genderError != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                genderError ?? '',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGray,
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: Color(0xFFF45B5B)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 10),
            buildHeader(),
            const SizedBox(height: 20),
            _buildGenderSelector(),
            _buildInputField(
                label: 'Name',
                hint: 'Enter your name',
                icon: Icons.person,
                onChanged: (val) => setState(() => name = val),
                errorText: nameError),
            _buildInputField(
                label: 'Username',
                hint: 'Enter your username',
                icon: Icons.person,
                onChanged: (val) => setState(() => username = val),
                errorText: usernameError),
            _buildInputField(
                label: 'Password',
                hint: 'Enter password',
                icon: Icons.lock,
                obscureText: !showPassword,
                onChanged: (val) => setState(() => password = val),
                errorText: passwordError,
                suffixIcon: IconButton(
                  icon:
                      Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => showPassword = !showPassword),
                )),
            _buildInputField(
                label: 'Email',
                hint: 'Enter your email',
                icon: Icons.mail,
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) => setState(() => email = val),
                errorText: emailError),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDropdown(
                    currentValue: day,
                    items: days,
                    onChanged: (val) => setState(() => day = val ?? day)),
                _buildDropdown(
                    currentValue: month,
                    items: months,
                    onChanged: (val) => setState(() => month = val ?? month)),
                _buildDropdown(
                    currentValue: year,
                    items: years,
                    onChanged: (val) => setState(() => year = val ?? year)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                    value: rememberMe,
                    onChanged: (val) => setState(() => rememberMe = val ?? false),
                    activeColor: pink),
                const Text('Remember me'),
              ],
            ),
            if (_registerError != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                child: Text(
                  _registerError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pink,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Register',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(color: gray, fontSize: 15),
                children: [
                  TextSpan(
                    text: 'Log in',
                    style: TextStyle(
                      color: pink,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      )),
    );
  }

  Widget buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('♡', style: TextStyle(fontSize: 26, color: pink.withOpacity(0.5))),
            const SizedBox(width: 4),
            Text('♡', style: TextStyle(fontSize: 20, color: pink.withOpacity(0.3))),
            const SizedBox(width: 4),
            Text('♡', style: TextStyle(fontSize: 14, color: pink.withOpacity(0.15))),
            const SizedBox(width: 4),
            Text('♡', style: TextStyle(fontSize: 30, color: pink.withOpacity(0.7))),
            const SizedBox(width: 4),
            Text('♡', style: TextStyle(fontSize: 14, color: pink.withOpacity(0.15))),
            const SizedBox(width: 4),
            Text('♡', style: TextStyle(fontSize: 20, color: pink.withOpacity(0.3))),
            const SizedBox(width: 4),
            Text('♡', style: TextStyle(fontSize: 26, color: pink.withOpacity(0.5))),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          "LOVE LOOM",
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: pink,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
