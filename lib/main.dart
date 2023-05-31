import 'dart:io';

import 'package:chat_app_course/screen/auth_pages/login_page.dart';
import 'package:chat_app_course/screen/chat/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_course/provider/auth_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBPtIuP1tiO2EKq4jErq--uQ-Z9UHGqvMQ",
          appId: "1:819877828803:ios:462cfaa7f55c1024d76a76",
          messagingSenderId: "819877828803",
          projectId: "chat--app-co",
          storageBucket: "chat--app-co.appspot.com"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        theme: ThemeData(
          primaryColor:  const Color(0xffE187B0),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffE187B0)),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LoginPage();
            } else {
              return const HomePage();
            }
          },
        ),
      ),
    );
  }
}
