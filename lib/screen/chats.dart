// ignore_for_file: unnecessary_null_comparison


import 'package:chat_app_course/models/user_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/chat_model.dart';
import 'chat_details.dart';

class ChatsPage extends StatefulWidget {
  final UserModel userModel;
  const ChatsPage({super.key,required this.userModel});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            setState(() {
              for (var chat in chatData) {
                chat.isSelected = false;
              }
            });
          },
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: chatData.length,
                  itemBuilder: (context, index) {
                    final chat = chatData[index];
                    return ListTile(
                      leading: chat.isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 40,
                            )
                          : CircleAvatar(
                              backgroundImage: AssetImage(chat.image)),
                      title: Text(chat.name),
                      subtitle: Text(chat.lastMessage),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailPage(chat: chat),
                          ),
                        );
                      },
                      onLongPress: () {
                        setState(() {
                          chat.isSelected = !chat.isSelected;
                        });
                      },
                      trailing: chat.isSelected
                          ? IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  chatData.removeAt(index);
                                });
                              },
                            )
                          : chat.isOnline
                              ? Container(
                                  height: 10,
                                  width: 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                )
                              : Text(
                                  DateFormat.jm().format(chat.lastOnline),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Enter Name'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Enter name',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Open Chat'),
                    onPressed: () {
                      String input = _textEditingController.text;

                      bool isChatExist =
                          chatData.any((chat) => chat.name == input);

                      if (isChatExist) {
                        // Chat already exists, open the existing chat
                        ChatModel chat =
                            chatData.firstWhere((chat) => chat.name == input);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailPage(chat: chat),
                          ),
                        );
                      } else {
                        //  create new chat
                        ChatModel newChat = ChatModel(
                          image: 'images/1.png',
                          name: input,
                          lastMessage: '...',
                          isOnline: false,
                          isSelected: false,
                          lastOnline: DateTime.now(),
                        );

                        setState(() {
                          chatData.add(newChat);
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailPage(chat: newChat),
                          ),
                        );
                      }

                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
