import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/screens/auth/signup.dart';
import 'package:user_app/screens/home.dart';
import 'package:user_app/utils/animate_route.dart';
import 'package:user_app/utils/services.dart/auth_services.dart';

import '../../utils/palette.dart';
import '../../widgets/input_box.dart';
import '../../widgets/text.dart';

class LoginPage extends StatefulWidget {
  String? email;
  String? tempPassword;
  LoginPage({this.email, this.tempPassword, super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthProvider? authProvider;

  _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      var loginPayload = {
        "email": _emailController.text,
        "password": _passwordController.text
      };
      authProvider?.login(context, payload: loginPayload).then((value) {
        setState(() {
          _isLoading = false;
        });

        if (value != null) {
          Navigator.pushReplacement(
              context, MyCustomRoute(builder: (context) => HomePage()));
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    _emailController.text = widget.email ?? "";
    _passwordController.text = widget.tempPassword ?? "";
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*   Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Image.asset(
                    'assets/color_logo.png',
                    height: 60.0,
                  ),
                ), */

                Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    "Login",
                    weight: FontWeight.w600,
                    size: 20.0,
                  ),
                ),
                SizedBox(height: 20.0),
                InputBox(
                    controller: _emailController,
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email)),
                InputBox(
                    controller: _passwordController,
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.key)),
                const SizedBox(
                  height: 20.0,
                ),
                Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    color: Palette.primaryColor,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: _login,
                      child: !_isLoading
                          ? const Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            )
                          : const SizedBox(
                              width: 17,
                              height: 17,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                    )),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MyCustomRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                            color: Palette.primaryColor),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
