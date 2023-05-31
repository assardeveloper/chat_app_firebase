// ignore_for_file: library_private_types_in_public_api

import 'package:chat_app_course/provider/chat_provider.dart';
import 'package:chat_app_course/screen/auth_pages/login_page.dart';
import 'package:chat_app_course/screen/profile/profile.dart';
import 'package:chat_app_course/widgets/conversationList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    ChatProvider chatProvider = Provider.of(context, listen: false);
    chatProvider.getHomeUsers();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Conversations',
            style: TextStyle(fontSize: 25),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then(
                  (value) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                );
              },
              icon: const Icon(Icons.logout),
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ));
                },
                icon: const Icon(Icons.person)),
          ]),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            chatProvider.usersList.isEmpty
                ? const Center(
                    child: Text("No Data"),
                  )
                : ListView.builder(
                    itemCount: chatProvider.usersList.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 16),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ConversationList(
                        name: chatProvider.usersList[index].userName,
                        messageText: "hi i'm flutter dev",
                        imageUrl: chatProvider.usersList[index].userImage,
                        time: "4:20 PM",
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
