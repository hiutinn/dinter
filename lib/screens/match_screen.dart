import 'package:dinter/screens/profile_screen.dart';
import 'package:dinter/services/services.dart';
import 'package:dinter/widgets/chat_row.dart';
import 'package:flutter/material.dart';
import 'package:dinter/models/models.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  late List<MatchModel> likes;
  late Stream<List<MatchModel>> likesStream;
  late List<MatchModel> matchedList;
  late Stream<List<MatchModel>> matchesStream;

  final MatchService matchService = MatchService();
  // void getLikes() async {
  //   List<MatchModel> likesList = await matchService.getUserLikes();
  //   setState(() {
  //     likes.addAll(likesList);
  //   });
  // }

  void getLikesStream() async {
    likesStream = matchService.getUserLikesStream();
  }

  void getMatchesStream() async {
    matchesStream = matchService.getMatchedListStream();
  }

  @override
  void initState() {
    super.initState();
    // getLikes();
    getMatchesStream();
    getLikesStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Match",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Người thích bạn",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                  height: 100,
                  child: StreamBuilder(
                      stream: likesStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        List<MatchModel> updatedLikes = snapshot.data!;
                        // Update the messages list
                        likes = updatedLikes;
                        return ListView.builder(
                          itemCount: likes.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ProfileScreen(
                                          userId: likes[index].user!.id,
                                        )));
                              },
                              child: SmallUserCard(user: likes[index].user!)),
                        );
                      }),
                ),
                Text(
                  "Tin nhắn",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                StreamBuilder(
                  stream: matchesStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    List<MatchModel> updatedMessages = snapshot.data!;
                    // Update the messages list
                    matchedList = updatedMessages;
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: matchedList.length,
                        itemBuilder: (context, index) {
                          return ChatRow(
                            match: matchedList[index],
                          );
                        });
                  },
                )
              ]),
        ),
      ),
    );
  }
}

class SmallUserCard extends StatelessWidget {
  final User user;
  const SmallUserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8.0, top: 4.0),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(user.imageUrl), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10.0)),
        ),
        Text(
          user.name,
          style: Theme.of(context).textTheme.labelLarge,
        )
      ],
    );
  }
}
