import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:user_app/utils/animate_route.dart';
import 'package:user_app/widgets/input_box.dart';

import '../../utils/palette.dart';
import '../../utils/services.dart/auth_services.dart';
import '../../widgets/text.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);

      var registerPayload = {
        "firstname": _firstNameController.text,
        "lastname": _lastNameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "password": _passwordController.text,
      };

      await authProvider
          .register(context, payload: registerPayload)
          .then((value) {
        setState(() {
          _isLoading = false;
        });

        //If Register successful, navigate to Login page with credentials
        if (value != null) {
          Navigator.pushReplacement(
              context,
              MyCustomRoute(
                  builder: (context) => LoginPage(
                      email: _emailController.text,
                      tempPassword: _passwordController.text)));
        }
      });
    }
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
                    "Sign Up",
                    weight: FontWeight.w600,
                    size: 20.0,
                  ),
                ),
                SizedBox(height: 20.0),
                InputBox(
                  controller: _firstNameController,
                  labelText: "First name",
                  prefixIcon: const Icon(Icons.person),
                ),
                InputBox(
                    controller: _lastNameController,
                    labelText: "Last name",
                    prefixIcon: const Icon(Icons.person)),
                InputBox(
                    controller: _emailController,
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email)),
                InputBox(
                    controller: _phoneController,
                    labelText: "Phone",
                    prefixIcon: const Icon(Icons.phone)),
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
                      onPressed: _register,
                      child: !_isLoading
                          ? const Text(
                              "Sign up",
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
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MyCustomRoute(builder: (context) => LoginPage()));
                      },
                      child: Text(
                        'Login',
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
