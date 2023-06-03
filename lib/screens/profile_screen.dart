import 'package:dinter/constants/colors.dart';
import 'package:dinter/screens/edit_profile_screen.dart';
import 'package:dinter/screens/login_screen.dart';
import 'package:dinter/services/auth_service.dart';
import 'package:dinter/services/user_service.dart';
import 'package:dinter/widgets/choice_button.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.userId,
  });
  final String userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  bool isCurrentUser = false;
  final UserService userService = UserService();
  final AuthService authService = AuthService();
  void getUser() async {
    await userService.getUserById(widget.userId).then((u) => setState(() {
          user = User(u.id, u.name, u.age, u.gender, u.bio, u.imageUrl);
          isCurrentUser = user!.id == authService.currentUser!.uid;
        }));
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.redAccent,
                size: isCurrentUser ? 24 : 0,
              )),
        ],
      ),
      body: user == null
          ? const CircularProgressIndicator()
          : Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(user!.imageUrl))),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${user!.name}, ${user!.age}",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: MyColor.primaryColor),
                        ),
                        Text(
                          user!.gender,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Giới thiệu",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: MyColor.primaryColor),
                        ),
                        Text(
                          user!.bio,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (isCurrentUser)
                          ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      MyColor.primaryColor)),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => EditProfileScreen(
                                          user: user!,
                                        )));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 12),
                                child: const Text(
                                  'Chỉnh sửa',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              )),
                      ],
                    ),
                  ),
                ],
              ),
              if (!isCurrentUser)
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: const ChoiceButton(
                            width: 80,
                            height: 80,
                            iconSize: 30,
                            iconColor: Colors.red,
                            icon: Icons.clear_outlined,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {},
                          child: const ChoiceButton(
                            width: 80,
                            height: 80,
                            iconSize: 30,
                            iconColor: Colors.greenAccent,
                            icon: Icons.favorite,
                          ),
                        )
                      ],
                    ),
                  ),
                )
            ]),
    );
  }

  void signOut() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Xác nhận"),
              content: const Text("Bạn muốn đăng xuất ?"),
              actions: [
                TextButton(
                  onPressed: () async {
                    await authService.signOut().then((value) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (route) => false);
                    });
                  },
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Khum');
                  },
                  child: const Text('Khum'),
                )
              ],
            ),
        barrierDismissible: true);
  }
}
