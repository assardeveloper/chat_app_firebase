import 'dart:io';

import 'package:chat_app_course/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthProvider? authProvider;
  XFile? xFile;
  getImageFormGallary() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile;
    xFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.xFile = xFile;
    });
  }

  TextEditingController? profileEmailController;
  TextEditingController? profileNameController;
  @override
  void initState() {
    AuthProvider authProviderInit =
        Provider.of<AuthProvider>(context, listen: false);
    authProviderInit.getCurrentUserData();
    profileEmailController =
        TextEditingController(text: authProviderInit.userModel!.userEmail);
    profileNameController =
        TextEditingController(text: authProviderInit.userModel!.userName);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: authProvider!.userModel != null
          ? ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () => {
                    getImageFormGallary(),
                  },
                  child: authProvider!.userModel!.userImage == ""
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(File(xFile!.path)),
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(authProvider!.userModel!.userImage),
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: profileNameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: profileEmailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 53,
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                        authProvider!.getCurrentUserData();
                      },
                      color: Theme.of(context).primaryColor,
                      child: const Text("Update Profile"),
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
