import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../widgets/text.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? user;
  String? token;
  

  Map<String, String> getHeaders({String? content_type, int? id}) {
    return {"Authorization": "Bearer ${user?.token}"};
  }

  Future<dynamic> register(context, {payload}) async {
    var uri = Uri.parse("https://demoapi.ppleapp.com/api/v1/user/create-user");

    try {
      var res = await http.post(uri, body: payload);
      var body = json.decode(res.body);

      if (res.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color(0xffF21919),
            content: AppText(body['message'], color: Colors.white)));

        return null;
      }

      print(body);
      user = User.fromJson(payload);

      notifyListeners();

      return body;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> login(context, {payload}) async {
    var uri = Uri.parse("https://demoapi.ppleapp.com/api/v1/user/login-user");

    try {
      var res = await http.post(uri, body: payload);
      var body = json.decode(res.body);
      if (res.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color(0xffF21919),
            content: AppText(body['message'], color: Colors.white)));
      }

      user = User.fromJson(body['user']);
      token = body['token'];
      user?.token = body['token'];

      notifyListeners();
      return body;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> getUserProfile(context) async {
    var uri =
        Uri.parse("https://demoapi.ppleapp.com/api/v1/user/user-profile-by-id");

    try {
      var payload = {"userId": user?.id};

      var res = await http.post(uri, body: payload, headers: getHeaders());
      print(res);
      var body = json.decode(res.body);

      if (res.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color(0xffF21919),
            content: AppText(body['message'], color: Colors.white)));
      }
      print(body);

      user = User.fromJson(body['user']);
      user?.token = token;

      notifyListeners();
      return body;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updatePassword(context, {payload}) async {
    var uri =
        Uri.parse("https://demoapi.ppleapp.com/api/v1/user/change-password");

    try {
      var res = await http.post(uri, body: payload);
      var body = json.decode(res.body);
      if (res.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color(0xffF21919),
            content: AppText(body['message'], color: Colors.white)));
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xff34A853),
          content: AppText(body['message'], color: Colors.white)));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> updateAvater(context, {imgPath}) async {
    var uri = "https://demoapi.ppleapp.com/api/v1/user/edit-profile-avatar";

    var photoFile;
    if (imgPath != null) {
      photoFile = MultipartFile.fromBytes(File(imgPath).readAsBytesSync(),
          filename: "avatar.jpg");
    }

    var payload = {"avatar": photoFile, "userId": user?.id};

    try {
      var dio = Dio();
      FormData formData = FormData.fromMap(payload);
      var res = await dio.post(
        uri,
        data: formData,
        options: Options(
          headers: getHeaders(),
        ),
      );

      if (res.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color(0xffF21919),
            content: AppText(res.data['message'], color: Colors.white)));
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xff34A853),
          content: AppText(res.data['message'], color: Colors.white)));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> deleteAccount(context) async {
    var uri =
        Uri.parse("https://demoapi.ppleapp.com/api/v1/user/delete-account");

    try {
      var res = await http.post(uri, headers: getHeaders());
      var body = json.decode(res.body);
      if (res.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color(0xffF21919),
            content: AppText(body['message'], color: Colors.white)));
        return null;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xff34A853),
          content: AppText(body['message'], color: Colors.white)));

      return body;
    } catch (e) {
      throw Exception(e);
    }
  }
}
