import 'package:dinter/models/models.dart';
import 'package:dinter/screens/profile_screen.dart';
import 'package:dinter/services/services.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final MatchModel match;
  const ChatScreen({super.key, required this.match});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Message> messages;
  late Stream<List<Message>> messagesStream;
  final MatchService matchService = MatchService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  void getMessages(String matchId) {
    messagesStream = matchService.getMessagesStream(widget.match.id);
  }

  @override
  void initState() {
    super.initState();
    getMessages(widget.match.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_search_rounded),
            onPressed: () {
              User opponentUser =
                  widget.match.user!.id == AuthService().currentUser!.uid
                      ? widget.match.secondUser!
                      : widget.match.user!;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ProfileScreen(userId: opponentUser.id)));
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.person_off,
              color: Colors.red,
            ),
            onPressed: () async {
              User opponentUser =
                  widget.match.user!.id == AuthService().currentUser!.uid
                      ? widget.match.secondUser!
                      : widget.match.user!;
              await matchService
                  .unmatch(opponentUser)
                  .then((value) => Navigator.of(context).pop());
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<List<Message>>(
              stream: messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Message> updatedMessages = snapshot.data!;
                // Update the messages list
                messages = updatedMessages;

                // Scroll to the last message
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                });
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Align(
                          alignment: messages[index].senderId ==
                                  AuthService().currentUser!.uid
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Card(
                            elevation: 10,
                            color: messages[index].senderId ==
                                    AuthService().currentUser!.uid
                                ? Colors.blue
                                : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                messages[index].message,
                                style: TextStyle(
                                  color: messages[index].senderId ==
                                          AuthService().currentUser!.uid
                                      ? Colors.white
                                      : Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )),
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 80,
                    child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(color: Colors.blue)),
                          hintText: "Nhập",
                        ))),
                IconButton(
                    onPressed: () async {
                      if (_messageController.text.isEmpty) return;
                      String receiverId = widget.match.user!.id ==
                              AuthService().currentUser!.uid
                          ? widget.match.secondUser!.id
                          : widget.match.user!.id;
                      await matchService.sendMessage(
                          widget.match, receiverId, _messageController.text);
                      _messageController.text = "";
                      setState(() {});
                    },
                    icon: const Icon(Icons.send))
              ],
            )
          ],
        ),
      ),
    );
  }
}
