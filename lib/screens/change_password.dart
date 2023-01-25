import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../utils/services.dart/auth_services.dart';
import '../widgets/input_box.dart';
import '../widgets/text.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  _updatePassword() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    if (_newPasswordController.text.isEmpty ||
        _currentPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
                const AppText("Updating password"),
                const SizedBox(height: 15.0),
                const SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            ))));

    var payload = {
      "currentPassword": _currentPasswordController.text,
      "newPassword": _newPasswordController.text,
      "userId": authProvider.user?.id ?? "",
    };
    await authProvider
        .updatePassword(context, payload: payload)
        .then((value) {})
        .whenComplete(() => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Password",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
        child: ListView(
          children: [
            const AppText("Current password"),
            const SizedBox(height: 5.0),
            InputBox(
                controller: _currentPasswordController, labelText: "********"),
            const SizedBox(height: 10.0),
            const AppText("New password"),
            const SizedBox(height: 5.0),
            InputBox(controller: _newPasswordController, labelText: "********"),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
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
                child: const AppText(
                  "UPDATE PASSWORD",
                  weight: FontWeight.w700,
                  color: Colors.white,
                  size: 11.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
