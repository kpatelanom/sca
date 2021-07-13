import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import 'package:sca/Service/Firebase.dart';

class CheckUserUsername {
  String username;
  CheckUserUsername(this.username);
  FireBaseService fbService = FireBaseService();

  checkUsername() async {
    QuerySnapshot querySnapshot = await fbService.users.get();
    final allData = querySnapshot.docs.map((e) => e.data()).toList();
    String isExist;
    allData.forEach((element) {
      if (element['username'] == username) {
        log("match");
        isExist = "Username exist";
      } else {
        log("not match");
        isExist = null;
      }
    });
    return isExist;
  }
}
