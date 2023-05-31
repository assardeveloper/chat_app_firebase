import 'package:flutter/material.dart';
import 'package:chat_app_course/provider/auth_provider.dart';
import 'package:chat_app_course/screen/auth_pages/signup_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'forget_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<LoginPage> {
  AuthProvider? authProvider;

  void validation() {
    String email = authProvider!.emailController.text.trim();
    String password = authProvider!.passwordController.text.trim();

    if (email == "" || password == "") {
      Fluttertoast.showToast(
        msg: "Please fill all the fields",
      );
    } else {
      authProvider!.loginWithEmailAndPassword(context);
    }
  }

  void signup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (builder) => SignupPage()));
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: authProvider!.emailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: authProvider!.passwordController,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => ForgetPage()));
                    },
                    child: Text("Forget Password?"))
              ],
            ),
            SizedBox(
              height: 52,
              width: double.infinity,
              child: MaterialButton(
                onPressed: () {
                  validation();
                },
                color: Theme.of(context).primaryColor,
                child: authProvider!.isLoginLoadding == false
                    ? Text("Login")
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account?"),
          TextButton(
            onPressed: () {
              signup();
            },
            child: Text("Signup"),
          )
        ],
      ),
    );
  }
}
