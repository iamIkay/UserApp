import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/screens/auth/login.dart';
import 'package:user_app/utils/palette.dart';
import 'package:user_app/utils/services.dart/auth_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'User App',
        theme: ThemeData(primarySwatch: Palette.primarySwatch),
        home: LoginPage(),
      ),
    );
  }
}
