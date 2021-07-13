import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import 'package:sca/Service/Firebase.dart';

class CheckUserNumber {
  FireBaseService fbService = FireBaseService();

  getUserId(String usernumber) async {
    String data = '';
    await fbService.users
        .where('number', isEqualTo: '+91' + usernumber)
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((element) {
              data = element.reference.id ?? '';
            }));
    return data;
  }
}
