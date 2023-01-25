import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:user_app/utils/services.dart/auth_services.dart';

import '../widgets/text.dart';

class UpdateProfileImage extends StatefulWidget {
  const UpdateProfileImage({super.key});

  @override
  State<UpdateProfileImage> createState() => _UpdateProfileImageState();
}

dynamic profileImage;

class _UpdateProfileImageState extends State<UpdateProfileImage> {
  bool _isLoading = false;
  dynamic image() {
    if (profileImage != null && profileImage.toString().isNotEmpty) {
      return FileImage(File(profileImage));
    } else
      return AssetImage("assets/avatar.png");
  }

  onSave() {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    authProvider
        .updateAvater(context, imgPath: profileImage)
        .then((value) => setState(() {
              _isLoading = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Profile Image",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 150.0),
        child: Column(children: [
          GestureDetector(
            onTap: () async {
              showFilePicker(FileType.image);
            },
            child: Align(
              alignment: Alignment.center,
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
          ),
          SizedBox(height: 50.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                onSave();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
              ),
              child: !_isLoading
                  ? AppText(
                      "UPDATE IMAGE",
                      weight: FontWeight.w700,
                      color: Colors.white,
                      size: 11.0,
                    )
                  : SizedBox(
                      height: 17.0,
                      width: 17.0,
                      child: CircularProgressIndicator(
                          strokeWidth: 1.0, color: Colors.white),
                    ),
            ),
          ),
        ]),
      ),
    );
  }

  showFilePicker(FileType fileType) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: fileType);

    if (result != null) {
      final filePath = result.files.single.path;

      setState(() {
        profileImage = filePath;
      });
    }
  }
}
