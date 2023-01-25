import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:user_app/utils/services.dart/auth_services.dart';
import 'package:user_app/widgets/input_box.dart';

import '../widgets/text.dart';

class VerifyUser extends StatefulWidget {
  const VerifyUser({super.key});

  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  bool _isLoading = false;
  TextEditingController _codeController = TextEditingController();

  _verifyUser() async {
    setState(() {
      _isLoading = true;
    });
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    await authProvider
        .verifyAccount(context, code: _codeController.text)
        .whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Verify User",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputBox(
                controller: _codeController,
                labelText: "Enter Verification Code"),
            SizedBox(
              width: 150.0,
              child: ElevatedButton(
                onPressed: _verifyUser,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  alignment: Alignment.center,
                ),
                child: !_isLoading
                    ? const AppText(
                        "VERIFY ACCOUNT",
                        weight: FontWeight.w700,
                        color: Colors.white,
                        size: 11.0,
                      )
                    : const SizedBox(
                        height: 17.0,
                        width: 17.0,
                        child: CircularProgressIndicator(
                            strokeWidth: 1.0, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
