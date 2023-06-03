import 'package:flutter/material.dart';

import '../models/models.dart';

class UserCard extends StatelessWidget {
  final User user;
  const UserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 1.4,
      child: Stack(children: [
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 4,
                      spreadRadius: 4,
                      offset: const Offset(3, 3))
                ],
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(user.imageUrl)))),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              gradient: const LinearGradient(
                  colors: [Colors.transparent, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.7, 1])),
        ),
        Positioned(
          bottom: 30,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.name}, ${user.age}",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                  Text(
                    user.bio,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}
