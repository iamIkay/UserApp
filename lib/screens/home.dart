import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/screens/auth/login.dart';
import 'package:user_app/screens/change_password.dart';
import 'package:user_app/screens/delete_account.dart';
import 'package:user_app/screens/profile.dart';
import 'package:user_app/screens/verify_user.dart';
import 'package:user_app/utils/animate_route.dart';
import 'package:user_app/utils/services.dart/auth_services.dart';
import 'package:user_app/widgets/input_box.dart';

import '../utils/models/user.dart';
import '../widgets/text.dart';
import 'change_profile_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;
  bool _isLoading = true;
  dynamic _profileImage;

  late AuthProvider authProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    await authProvider.getUserProfile(context).then((value) {
      user = authProvider.user;

      setState(() {
        _isLoading = false;
      });
    });
  }

  onSave() {
    setState(() {
      _isLoading = true;
    });
    authProvider
        .updateAvater(context, imgPath: user?.profileImg)
        .then((value) => setState(() {
              _isLoading = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leadingWidth: 96,
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MyCustomRoute(builder: (context) => LoginPage()));
          },
          child: Row(
            children: [
              const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              ),
              const AppText(
                "Logout",
                color: Colors.white,
                weight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
      body: ListView(padding: const EdgeInsets.only(top: 5.0), children: [
        ListTile(
            title: const AppText("Profile"),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              size: 25,
              color: Colors.black,
            ),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfilePage()))),
        ListTile(
          title: const AppText("Verify Account"),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            size: 25,
            color: Colors.black,
          ),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const VerifyUser())),
        ),
        ListTile(
            title: const AppText("Change Password"),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              size: 25,
              color: Colors.black,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UpdatePassword()))),
        ListTile(
            title: const AppText("Update Profile Image"),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              size: 25,
              color: Colors.black,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UpdateProfileImage()))),
        ListTile(
            title: const AppText("Delete Account"),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              size: 25,
              color: Colors.black,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DeleteAccountPage()))),
      ]),
    );
  }

  showFilePicker(FileType fileType) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: fileType);

    if (result != null) {
      final filePath = result.files.single.path;

      setState(() {
        user?.profileImg = filePath;
        _profileImage = filePath;
      });
    }
  }
}

class BuildInfoRow extends StatelessWidget {
  final title;
  final detail;
  final controller;
  const BuildInfoRow({this.title, this.detail, this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90.0, child: AppText("$title ")),
          const SizedBox(height: 5.0),
          InputBox(controller: controller, isEnabled: false),
          //AppText(detail, size: 16.0),
        ],
      ),
    );
  }
}
