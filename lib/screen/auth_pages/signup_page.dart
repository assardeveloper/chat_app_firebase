import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chat_app_course/provider/auth_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  AuthProvider? authProvider;

  File? pickedFile;

  Future<void> selectImage(ImageSource imageSource) async {
    XFile? pickedImage = await ImagePicker().pickImage(source: imageSource);

    if (pickedImage != null) {
      cropImage(pickedImage);
    }
  }

  Future<void> cropImage(XFile file) async {
    CroppedFile? cropImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);

    if (cropImage != null) {
      setState(() {
        pickedFile = File(cropImage.path);
      });
    }
  }

  void showPhotoOptions() async {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text("Upload Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    selectImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  title: const Text("Gallery"),
                  leading: const Icon(
                    Icons.image,
                  ),
                ),
                ListTile(
                  onTap: () {
                    selectImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  title: const Text("Camera"),
                  leading: const Icon(
                    Icons.camera,
                  ),
                )
              ],
            ),
          );
        });
  }

  void validation() {
    String name = authProvider!.signupName.text.trim();
    String email = authProvider!.signupEmailController.text.trim();
    String password = authProvider!.signupPasswordController.text.trim();

    if (name == "" || email == "" || password == "" || pickedFile == null) {
      Fluttertoast.showToast(
        msg: "Please fill all the fields",
      );
    } else {
      authProvider!.signUpWithEmailAndPassword(context,imageFile: File(pickedFile!.path));
    }
  }



  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Stack(children: [
              CircleAvatar(
                  radius: 70,
                  backgroundImage:
                      (pickedFile != null) ? FileImage(pickedFile!) : null,
                  child: (pickedFile == null)
                      ? const Icon(
                          Icons.person_2,
                          size: 60,
                          color: Colors.white,
                        )
                      : null),
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      showPhotoOptions();
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                          radius: 19,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          )),
                    ),
                  ))
            ]),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: authProvider!.signupName,
              decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: authProvider!.signupEmailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: authProvider!.signupPasswordController,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 53,
              width: double.infinity,
              child: MaterialButton(
                  onPressed: () {
                    validation();
                  },
                  color: Theme.of(context).primaryColor,
                  child: authProvider!.isSignupLoadding == false
                      ? const Text("Signup")
                      : const Center(
                          child: CircularProgressIndicator(color: Colors.red),
                        )),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.blue),
              child: MaterialButton(
                onPressed: () {},
                child: const Text("Signup with Phone"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an account?"),
          TextButton(
              onPressed: () {
              },
              child: const Text("Login"))
        ],
      ),
    );
  }
}
