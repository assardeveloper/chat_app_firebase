// ignore_for_file: unused_element, library_private_types_in_public_api

import 'dart:io';

import 'package:chat_app_course/models/chat_model.dart';
import 'package:chat_app_course/provider/auth_provider.dart';
import 'package:chat_app_course/provider/chat_provider.dart';
import 'package:chat_app_course/screen/chat/full_image.dart';
import 'package:chat_app_course/screen/chat/video_play.dart';
import 'package:chat_app_course/screen/chat/voice_recoder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:voice_message_package/voice_message_package.dart';

class ChatDetailPage extends StatefulWidget {
  final String userid;
  final String userImage;
  final String userName;
  final String status;

  const ChatDetailPage(
      {super.key,
      required this.status,
      required this.userImage,
      required this.userid,
      required this.userName});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage>
    with WidgetsBindingObserver {
  User? currentUser = FirebaseAuth.instance.currentUser;
  String groupChatId = "";
  TextEditingController messageController = TextEditingController();
  String timeAgoCustom(DateTime d) {
    // <-- Custom method Time Show  (Display Example  ==> 'Today 7:00 PM')     // WhatsApp Time Show Status Shimila
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (diff.inDays > 0) return DateFormat.E().add_jm().format(d);
    if (diff.inHours > 0) return "Today ${DateFormat('jm').format(d)}";
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    return "just now";
  }

  readLocal() async {
    // prefs = await SharedPreferences.getInstance();

    if (currentUser!.uid.hashCode <= widget.userid.hashCode) {
      groupChatId = '${currentUser!.uid}-${widget.userid}';
    } else {
      groupChatId = '${widget.userid}-${currentUser!.uid}';
    }

    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .update({'chatingWith': widget.userid});

    setState(() {});
  }

  @override
  void initState() {
    AuthProvider authProvider = Provider.of(context, listen: false);
    readLocal();
    authProvider.getCurrentUserData();
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser!.uid)
          .update({
        "status": "Online",
      });
    } else {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser!.uid)
          .update({
        "status": "Ofline",
      });
    }
  }

  _showChats(ChatModel chatModel) {
    String time = timeAgoCustom(
      DateTime.fromMillisecondsSinceEpoch(
        int.parse(chatModel.time),
      ),
    );

    if (chatModel.uid == FirebaseAuth.instance.currentUser!.uid) {
      return chatModel.type == "text"
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 14,
                    right: 14,
                  ),
                  child: Align(
                    alignment: (Alignment.topRight),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 250.0, minWidth: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (Colors.blue[200]),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        chatModel.message,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 20),
                  child: Text(
                    time,
                  ),
                ),
              ],
            )
          : chatModel.type == "image"
              ? InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FullImage(
                        image: chatModel.message,
                      ),
                    ));
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              chatModel.message,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, top: 8),
                            child: Text(
                              time,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : chatModel.type == "video"
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: VideoPaly(
                        videoUrl: chatModel.message,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: VoiceMessage(
                            duration: const Duration(seconds: 4),

                            audioSrc: chatModel.message,
                            played: true, // To show played badge or not.
                            me: true, // Set message side.
                            onPlay: () {}, // Do something when voice played.
                          ),
                        ),
                      ],
                    );
    } else {
      return chatModel.type == "text"
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints:
                      const BoxConstraints(maxWidth: 250.0, minWidth: 50),
                  padding: const EdgeInsets.only(
                    left: 14,
                    right: 14,
                  ),
                  child: Align(
                    alignment: (Alignment.topLeft),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (Colors.grey.shade200),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        chatModel.message,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 14, bottom: 10),
                  child: Text(
                    time,
                  ),
                ),
              ],
            )
          : chatModel.type == "image"
              ? InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FullImage(
                        image: chatModel.message,
                      ),
                    ));
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              chatModel.message,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, top: 8),
                            child: Text(
                              time,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VideoPaly(
                        videoUrl: chatModel.message,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16, top: 8),
                        child: Text(
                          time,
                        ),
                      ),
                    ],
                  ),
                );
    }
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of(context);
    AuthProvider authProvider = Provider.of(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.userImage),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.userName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        widget.status,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.call,
                  color: Colors.black54,
                ),
                const SizedBox(
                  width: 20,
                ),
                const Icon(
                  Icons.videocam_sharp,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chating")
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy("time", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No Chats"),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    reverse: true,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      ChatModel chatModel =
                          ChatModel.fromMap(snapshot.data!.docs[index]);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _showChats(chatModel),
                          const SizedBox(
                            height: 40,
                          )
                        ],
                      );
                    },
                  );
                }
              }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext bc) {
                            return Wrap(
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.image),
                                  title: const Text('Image'),
                                  onTap: () async {
                                    XFile? pickedImage = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);

                                    String imageUrl = await chatProvider
                                        .uploadImage(File(pickedImage!.path));

                                    if (imageUrl.isNotEmpty) {
                                      chatProvider.sendMessage(
                                        groupId: groupChatId,
                                        id: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        message: imageUrl,
                                        type: "image",
                                        name: authProvider.userModel!.userName,
                                      );
                                    }
                                  },
                                ),
                                ListTile(
                                    leading: const Icon(Icons.videocam),
                                    title: const Text('Video'),
                                    onTap: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                        type: FileType.video,
                                      );

                                      if (result != null) {
                                        XFile file =
                                            XFile(result.files.single.path!);

                                        String videoUrl = await chatProvider
                                            .uploadImage(File(file.path));

                                        if (videoUrl.isNotEmpty) {
                                          chatProvider.sendMessage(
                                            groupId: groupChatId,
                                            id: FirebaseAuth
                                                .instance.currentUser!.uid,
                                            message: videoUrl,
                                            type: "video",
                                            name: authProvider
                                                .userModel!.userName,
                                          );
                                        }
                                      } else {
                                        // User canceled the picker
                                      }
                                    }),
                                ListTile(
                                  leading: const Icon(Icons.insert_drive_file),
                                  title: const Text('File'),
                                  onTap: () => {},
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => VoiceRecoder(
                          groupId: groupChatId,
                          currentUserId: FirebaseAuth.instance.currentUser!.uid,
                          userName: authProvider.userModel!.userName,
                        ),
                      ));
                    },
                    child: const Icon(Icons.keyboard_voice_sharp),
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      if (messageController.text.isNotEmpty) {
                        chatProvider.sendMessage(
                          groupId: groupChatId,
                          id: FirebaseAuth.instance.currentUser!.uid,
                          message: messageController.text,
                          type: "text",
                          name: authProvider.userModel!.userName,
                        );
                        messageController.clear();
                      }
                    },
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
