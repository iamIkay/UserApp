import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/utils/services.dart/auth_services.dart';

import '../utils/animate_route.dart';
import '../utils/palette.dart';
import '../widgets/text.dart';
import 'auth/login.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool _isLoading = false;
  _deleteAccount() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
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
          title: Text(
            "Update Profile Image",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
        bottomNavigationBar: Container(
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
            child: !_isLoading
                ? AppText(
                    "DELETE ACCOUNT",
                    weight: FontWeight.w700,
                    color: Colors.white,
                    size: 11.0,
                  )
                : SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white)),
          ),
        ));
  }
}
