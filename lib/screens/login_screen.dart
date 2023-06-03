import 'package:dinter/constants/colors.dart';
import 'package:dinter/screens/home_screen.dart';
import 'package:dinter/screens/register/register_screen.dart';
import 'package:dinter/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      await _authService
          .signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen()));
      });
      // Authentication successful, navigate to the next screen or perform desired actions.
    } catch (e) {
      // Handle authentication failure, show an error message, or perform any other necessary actions.
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text("Cảnh báo!"),
                content: const Text("Thông tin đăng nhập sai!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
          barrierDismissible: true);
      // ignore: avoid_print
      print('Authentication failed: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Đăng nhập !',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(color: Colors.grey)),
                label: const Text('Email')),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            obscureText: true,
            controller: _passwordController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              label: const Text('Password'),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(MyColor.primaryColor)),
              onPressed: () {
                if (_validateInput(context)) {
                  _signIn();
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text('Chưa có tài khoản ? Đăng ký.'))
        ]),
      ),
    );
  }

  bool _validateInput(BuildContext context) {
    if (_emailController.text == "") {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text("Cảnh báo!"),
                content: const Text("Bạn chưa nhập email!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
          barrierDismissible: true);
      return false;
    }

    if (_passwordController.text == "") {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text("Cảnh báo!"),
                content: const Text("Bạn chưa nhập password!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
          barrierDismissible: true);
      return false;
    }
    return true;
  }
}
