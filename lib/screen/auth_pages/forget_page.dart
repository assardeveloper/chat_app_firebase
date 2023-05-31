import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({super.key});

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  TextEditingController emailController = TextEditingController();

  void validation() {
    String email = emailController.text.trim();

    if (email == "") {
      Fluttertoast.showToast(
        msg: "Please enter valid email!",
      );
    } else {
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forget Password")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Enter your email to reset password, we will send a\n a verification link.",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                validation();
              },
              color: Theme.of(context).primaryColor,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
