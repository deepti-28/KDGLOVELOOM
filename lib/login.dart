import 'package:flutter/material.dart';
import 'services/api_service.dart';  // Adjust path if needed

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? usernameError;
  String? passwordError;
  String? loginError;
  bool _isLoading = false;

  final Color pink = const Color(0xFFF45D6B);
  final Color darkText = const Color(0xFF282828);

  final ApiService _apiService = ApiService();

  void _showLoginSuccessAndNavigate() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => Center(
        child: Container(
          width: 255,
          height: 230,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 14,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE5EA),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, size: 38, color: pink),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 2,
                        child: Container(
                          width: 65,
                          height: 4,
                          color: Colors.yellow[600],
                        ),
                      ),
                      Text(
                        "Log In",
                        style: TextStyle(
                          color: pink,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.5,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 2,
                        child: Container(
                          width: 95,
                          height: 4,
                          color: Colors.yellow[600],
                        ),
                      ),
                      Text(
                        "Successful",
                        style: TextStyle(
                          color: pink,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.5,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.of(context, rootNavigator: true).pop();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(
          context,
          '/dashboard',
          arguments: {
            'userName': _usernameController.text,
          },
        );
      });
    });
  }

  void _validateAndLogin() async {
    setState(() {
      usernameError = null;
      passwordError = null;
      loginError = null;
    });

    final usernameText = _usernameController.text.trim();
    final passwordText = _passwordController.text;

    if (usernameText.isEmpty) {
      setState(() {
        usernameError = "Please enter username or email";
      });
    }

    if (passwordText.isEmpty) {
      setState(() {
        passwordError = "Please enter password";
      });
    } else if (passwordText.length < 6) {
      setState(() {
        passwordError = "Password too short";
      });
    }

    if (usernameError == null && passwordError == null) {
      setState(() => _isLoading = true);

      try {
        bool success = await _apiService.login(usernameText, passwordText);
        if (success) {
          _showLoginSuccessAndNavigate();
        } else {
          setState(() {
            loginError = "Invalid username or password";
          });
        }
      } catch (e) {
        setState(() {
          loginError = "Login failed: ${e.toString()}";
        });
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: pink,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Center(
              child: Text(
                'LOVE LOOM',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                  fontSize: 36,
                  color: pink,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Username / Email',
                style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person, color: pink),
                hintText: 'Enter username or email',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: pink, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: pink, width: 1.5),
                ),
                errorText: usernameError,
              ),
              style: TextStyle(fontSize: 16, color: darkText),
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Password',
                style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: pink),
                hintText: 'Enter password',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: pink, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: pink, width: 1.5),
                ),
                errorText: passwordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: pink,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              style: TextStyle(fontSize: 16, color: darkText),
            ),
            if (loginError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  loginError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _isLoading ? null : _validateAndLogin,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Log In',
                        style: TextStyle(
                            fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(color: darkText, fontSize: 15),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(
                        color: pink,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
