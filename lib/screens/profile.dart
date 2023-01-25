import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/screens/auth/login.dart';
import 'package:user_app/utils/animate_route.dart';
import 'package:user_app/utils/palette.dart';
import 'package:user_app/utils/services.dart/auth_services.dart';
import 'package:user_app/widgets/input_box.dart';

import '../utils/models/user.dart';
import '../widgets/text.dart';
import 'change_profile_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  bool _isLoading = true;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _walletController = TextEditingController();
  TextEditingController _stripeController = TextEditingController();
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

      _firstNameController.text = user?.firstName ?? "";
      _lastNameController.text = user?.lastName ?? "";
      _emailController.text = user?.email ?? "";
      _phoneController.text = user?.phoneNum ?? "";
      _firstNameController.text = user?.firstName ?? "";
      _walletController.text = user?.wallet ?? "";
      _stripeController.text = user?.stripeCustomerId ?? "";
      setState(() {
        _isLoading = false;
      });
    });
  }

  dynamic image() {
    if (profileImage != null && profileImage.toString().isNotEmpty) {
      return FileImage(File(profileImage));
    } else if (authProvider.user?.profileImg != null &&
        authProvider.user!.profileImg!.isNotEmpty)
      return NetworkImage(authProvider.user!.profileImg!);
    else
      return AssetImage("assets/avatar.png");
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

  _updatePassword() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    if (_newPasswordController.text.isEmpty ||
        _currentPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xffF21919),
          content: AppText("Please enter all password fields",
              color: Colors.white)));
      return;
    }
    showDialog(
        context: context,
        builder: (context) => SizedBox(
            height: 100.0,
            child: AlertDialog(
                content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText("Updating password"),
                SizedBox(height: 15.0),
                SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            ))));

    var payload = {
      "currentPassword": _currentPasswordController.text,
      "newPassword": _newPasswordController.text,
      "userId": user?.id ?? "",
    };
    await authProvider.updatePassword(context, payload: payload).then((value) {
      Navigator.of(context).pop();
    });
  }

  _deleteAccount() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        buttonPadding: EdgeInsets.zero,
        title: Text(
          'Are you sure you want to\ndelete your account?',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(fontWeight: FontWeight.w700, fontSize: 14.0),
        ),
        content: Text(
          'This action is irreversible and your\naccount will no longer be accessible',
          textAlign: TextAlign.center,
          style:
              Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 12.0),
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    alignment: Alignment.center,
                    height: 35.0,
                    color: Palette.primaryColor,
                    child: Text(
                      'NO',
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);

                    setState(() {
                      _isLoading = true;
                    });
                    await authProvider.deleteAccount(context).then((value) {
                      if (value == null) {
                        setState(() {
                          _isLoading = false;
                        });
                        return;
                      }

                      Navigator.of(context).pushReplacement(
                          MyCustomRoute(builder: (context) => LoginPage()));
                    }).whenComplete(() => setState(() {
                          _isLoading = false;
                        }));
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 35.0,
                      color: Color(0xFF993030),
                      child: Text(
                        'YES',
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 96,
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 80,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                onSave();
              },
              child: Text(
                "Update",
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
        ],
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: !_isLoading
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 150.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.0),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              showFilePicker(FileType.image);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black.withOpacity(.5),
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: image(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF251D2A),
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 40.0),
                          Expanded(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    AppText("${user?.followersCount}",
                                        weight: FontWeight.w600, size: 18.0),
                                    SizedBox(height: 5.0),
                                    AppText("Followers", size: 10.0)
                                  ],
                                ),
                                SizedBox(width: 10.0),
                                Column(
                                  children: [
                                    AppText("${user?.followedCount}",
                                        weight: FontWeight.w600, size: 18.0),
                                    SizedBox(height: 5.0),
                                    AppText("Following", size: 10.0)
                                  ],
                                ),
                                SizedBox(width: 10.0),
                                Column(
                                  children: [
                                    AppText("${user?.hostedEvenCount}",
                                        weight: FontWeight.w600, size: 18.0),
                                    SizedBox(height: 5.0),
                                    AppText("Events Hosted", size: 10.0)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      AppText("Bio", weight: FontWeight.bold),
                      SizedBox(height: 3.0),
                      AppText(user?.bio ?? ""),
                      SizedBox(height: 20.0),
                      BuildInfoRow(
                          title: "First Name",
                          controller: _firstNameController),
                      BuildInfoRow(
                          title: "Last name", controller: _lastNameController),
                      BuildInfoRow(
                          title: "Phone", controller: _phoneController),
                      BuildInfoRow(
                          title: "Email", controller: _emailController),
                      BuildInfoRow(
                          title: "Wallet", controller: _walletController),
                      BuildInfoRow(
                        title: "Stripe ID",
                        controller: _stripeController,
                      ),
                      AppText("Current password"),
                      SizedBox(height: 5.0),
                      InputBox(
                          controller: _currentPasswordController,
                          labelText: "********"),
                      SizedBox(height: 10.0),
                      AppText("New password"),
                      SizedBox(height: 5.0),
                      InputBox(
                          controller: _newPasswordController,
                          labelText: "********"),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            _updatePassword();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            alignment: Alignment.center,
                          ),
                          child: AppText(
                            "UPDATE PASSWORD",
                            weight: FontWeight.w700,
                            color: Colors.white,
                            size: 11.0,
                          ),
                        ),
                      ),
                    ]),
              ),
            )
          : Center(
              child: CircularProgressIndicator(strokeWidth: 3.0),
            ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: _deleteAccount,
          style: ElevatedButton.styleFrom(
            primary: Color(0xFFA83434),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            alignment: Alignment.center,
          ),
          child: AppText(
            "DELETE ACCOUNT",
            weight: FontWeight.w700,
            color: Colors.white,
            size: 11.0,
          ),
        ),
      ),
    );
  }

  showFilePicker(FileType fileType) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: fileType);

    if (result != null) {
      final filePath = result.files.single.path;

      setState(() {
        user?.profileImg = filePath;
        profileImage = filePath;
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
          SizedBox(height: 5.0),
          InputBox(controller: controller, isEnabled: false),
          //AppText(detail, size: 16.0),
        ],
      ),
    );
  }
}
