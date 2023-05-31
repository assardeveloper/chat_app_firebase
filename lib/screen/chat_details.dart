import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/chat_model.dart';

class ChatDetailPage extends StatelessWidget {
  final ChatModel chat;

  const ChatDetailPage({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
                // radius: 25,
                backgroundImage: AssetImage(
              chat.image,
            )),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chat.name),
                SizedBox(height: 4),
                chat.isOnline
                    ? Text(
                        'Online',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber,
                        ),
                      )
                    : Text(
                        DateFormat.jm().format(chat.lastOnline),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Chat detail page'),
      ),
    );
  }
}
