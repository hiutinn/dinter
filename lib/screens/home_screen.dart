import 'package:dinter/screens/match_screen.dart';
import 'package:dinter/screens/profile_screen.dart';
import 'package:dinter/services/services.dart';
import 'package:dinter/widgets/choice_button.dart';
import 'package:dinter/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<User> users = [];
  final UserService userService = UserService();
  final MatchService matchService = MatchService();
  final _swipeController = SwipableStackController();
  @override
  void initState() {
    super.initState();

    getUsers();
  }

  void getUsers() async {
    List<User>? userList = await userService.getUserList();
    setState(() {
      users.addAll(userList!);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _swipeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dinter",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                getUsers();
              },
              icon: const Icon(Icons.restore)),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MatchScreen()));
              },
              icon: const Icon(Icons.message_outlined)),
          IconButton(
              onPressed: () {
                String id = AuthService().currentUser!.uid;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                          userId: id,
                        )));
              },
              icon: const Icon(Icons.person)),
        ],
      ),
      body: Stack(children: [
        Column(
          children: [
            if (users.isNotEmpty)
              SwipableCard(
                users: users,
                controller: _swipeController,
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: CircularProgressIndicator(),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () {
                      _swipeController.next(
                          swipeDirection: SwipeDirection.left);
                    },
                    child: const ChoiceButton(
                      width: 80,
                      height: 80,
                      iconSize: 30,
                      iconColor: Colors.red,
                      icon: Icons.clear_outlined,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      _swipeController.next(
                          swipeDirection: SwipeDirection.right);
                    },
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
            )
          ],
        ),
      ]),
    );
  }
}

class SwipableCard extends StatefulWidget {
  const SwipableCard({
    super.key,
    required this.users,
    required this.controller,
  });

  final List<User> users;
  final SwipableStackController controller;

  @override
  State<SwipableCard> createState() => _SwipableCardState();
}

class _SwipableCardState extends State<SwipableCard> {
  final MatchService matchService = MatchService();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SwipableStack(
          detectableSwipeDirections: const {
            SwipeDirection.right,
            SwipeDirection.left,
          },
          controller: widget.controller,
          itemCount: widget.users.length,
          horizontalSwipeThreshold: 1,
          onSwipeCompleted: (index, direction) async {
            if (direction == SwipeDirection.right) {
              // Handle right swipe
              await matchService.like(widget.users[index]);
            } else if (direction == SwipeDirection.left) {
              // Handle left swipe
              await matchService.unmatch(widget.users[index]);
              return;
            }
          },
          builder: (context, swipeProperty) =>
              UserCard(user: widget.users[swipeProperty.index])),
    );
  }
}
