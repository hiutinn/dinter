import 'package:dinter/constants/colors.dart';
import 'package:dinter/screens/register/set_profile.dart';
import 'package:dinter/services/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Đăng ký !',
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
                  _signUp();
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đã có tài khoản ? Đăng nhập.'))
        ]),
      ),
    );
  }

  void _showAlertDialog(String message) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Cảnh báo!"),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
        barrierDismissible: true);
  }

  bool _validateInput(BuildContext context) {
    if (_emailController.text == "") {
      _showAlertDialog("Bạn chưa nhập email");
      return false;
    }

    if (_passwordController.text == "") {
      _showAlertDialog("Bạn chưa nhập password");
      return false;
    }
    return true;
  }

  Future<void> _signUp() async {
    try {
      await _authService
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((value) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const SetProfileScreen()));
      });
      // Authentication successful, navigate to the next screen or perform desired actions.
    } catch (e) {
      // Handle authentication failure, show an error message, or perform any other necessary actions.
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text("Cảnh báo!"),
                content: const Text("Đăng ký thất bại!"),
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
}
