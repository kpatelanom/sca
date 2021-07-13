import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sca/Service/Firebase.dart';
import 'package:sca/screens/HomePage.dart';
import 'package:sca/screens/LoginPage.dart';
import 'package:sca/Service/SharedData.dart';
import 'package:sca/screens/NotConnected.dart';

class RouteScreen extends StatefulWidget {
  RouteScreen() : super();
  @override
  _RouteState createState() => _RouteState();
}

class _RouteState extends State<RouteScreen> {
  String userId = '';
  bool isInternet = false;
  final sharedData = Get.put(SharedData());
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FireBaseService fbService = FireBaseService();
  @override
  void initState() {
    super.initState();
    checkInternet();
    init();
    saveToken();
  }

  saveToken() async {
    String fcmToken = await messaging.getToken();
    log(fcmToken);
    if (fcmToken != '' && fcmToken != null && userId != '') {
      fbService.users.doc(userId).update(
          {'token': fcmToken, 'createdAt': FieldValue.serverTimestamp()});
    }
  }

  Future checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isInternet = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isInternet = false;
      });
    }
  }

  Future init() async {
    final value = await sharedData.isUserLogin() ?? '';
    setState(() {
      userId = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isInternet
        ? userId.toString() == ''
            ? LoginPage()
            : MyHomePage(userId.toString())
        : NotConnected();
  }
}
