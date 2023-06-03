import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinter/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';
import '../services/services.dart';

class ChatRow extends StatefulWidget {
  final MatchModel match;

  const ChatRow({
    super.key,
    required this.match,
  });

  @override
  State<ChatRow> createState() => _ChatRowState();
}

class _ChatRowState extends State<ChatRow> {
  final String currentUserId = AuthService().currentUser!.uid;
  String getTime(Timestamp timestamp) {
    String formattedDateTime =
        DateFormat('HH:mm, dd/MM').format(timestamp.toDate());
    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ChatScreen(match: widget.match)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white70,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.match.user?.id == currentUserId
                          ? widget.match.secondUser!.imageUrl
                          : widget.match.user!.imageUrl)),
                  shape: BoxShape.circle),
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.match.user?.id == currentUserId
                      ? widget.match.secondUser!.name
                      : widget.match.user!.name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    widget.match.chat!.messages.isEmpty
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: const Text(
                              "BẠN ĐÃ CÓ THỂ NHẮN TIN VỚI NGƯỜI NÀY",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ))
                        : SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              widget
                                  .match
                                  .chat!
                                  .messages[
                                      widget.match.chat!.messages.length - 1]
                                  .message,
                              overflow: TextOverflow.ellipsis,
                            )),
                    widget.match.chat!.messages.isNotEmpty
                        ? Text(getTime(widget
                            .match
                            .chat!
                            .messages[widget.match.chat!.messages.length - 1]
                            .dateTime))
                        : const Text(""),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}