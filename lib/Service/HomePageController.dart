import 'dart:developer';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sca/Service/Firebase.dart';
import 'package:sca/Service/SharedData.dart';

class HomePageController extends GetxController {
  FireBaseService fbService = FireBaseService();

  final sharedData = SharedData();
  bool isSearching = false;
  List searchData = [];
  var currentUserData;
  List userChats = [];
  List messages = [];
  String senderUSerId = '';

  searchUSers(username) async {
    EasyLoading.show(status: 'loading...');
    try {
      QuerySnapshot snapshot = await fbService.users
          .where('username', isGreaterThanOrEqualTo: username)
          .where('username', isLessThanOrEqualTo: username + '\uf8ff')
          .get();
      var data = snapshot.docs.map((e) => e.data()).toList();
      searchData.clear();
      data.forEach((element) {
        searchData.add(element);
      });
    } on Exception catch (e) {
      log(e.toString());
    }
    update();
    EasyLoading.dismiss();
  }

  gettingUserId(String number) async {
    String data = '';
    try {
      await fbService.users
          .where('number', isEqualTo: number)
          .get()
          .then((QuerySnapshot snapshot) => snapshot.docs.forEach((element) {
                data = element.reference.id ?? '';
              }));
    } on Exception catch (e) {
      log(e.toString());
    }
    return data;
  }

  addingFriend(
      String currentUserId, String number, String name, String imageurl) async {
    EasyLoading.show(status: 'loading...');
    senderUSerId = await gettingUserId(number);
    if (senderUSerId == currentUserId) {
      EasyLoading.dismiss();
      return -1;
    }
    var isFriendExist = await checkFriendExist(senderUSerId, currentUserId);
    if (isFriendExist) {
      EasyLoading.dismiss();
      return 0;
    }
    await fbService.users.doc(currentUserId).collection('chats').add({
      'sender_user_id': senderUSerId,
      'name': name,
      'image_url': imageurl,
      'number': number,
      'time': DateTime.now().millisecondsSinceEpoch,
      'last_text': ''
    });
    await fbService.users.doc(senderUSerId).collection('chats').add({
      'sender_user_id': currentUserId,
      'name': currentUserData['name'],
      'image_url': currentUserData['image_url'],
      'number': currentUserData['number'],
      'time': DateTime.now().millisecondsSinceEpoch,
      'last_text': ''
    });
    EasyLoading.dismiss();
    return 1;
  }

  checkFriendExist(String senderUserId, String currentUserId) async {
    var data;
    log('senderUserId  ' + senderUSerId);
    try {
      await fbService.users
          .doc(currentUserId)
          .collection('chats')
          .where('sender_user_id', isEqualTo: senderUserId)
          .get()
          .then((QuerySnapshot snap) => snap.docs.forEach((element) {
                data = element.reference.id ?? '';
                log(element.reference.id.toString());
              }));
    } on Exception catch (e) {
      log('Something went wrong ' + e.toString());
    }
    if (data == '' || data == null)
      return false;
    else
      return true;
  }

  getCurrentUserInfo(String userid) async {
    try {
      currentUserData =
          await fbService.users.doc(userid).get().then((value) => value.data());
    } on Exception catch (e) {
      log(e.toString());
    }
    log('curren user data  ' + currentUserData.toString());
    update();
  }

  getChatsOfCurrentUSer(String userid) async {
    userChats.clear();
    try {
      await fbService.users
          .doc(userid)
          .collection('chats')
          .get()
          .then((QuerySnapshot snapshot) => snapshot.docs.forEach((element) {
                userChats.add(element.data());
              }));
    } on Exception catch (e) {
      log(e.toString());
    }
    log(userChats.toString());
    update();
  }

  getUserId(String usernumber) async {
    if (usernumber == '' || usernumber == null) return;
    String data = '';
    log(usernumber);
    await fbService.users
        .where('number', isEqualTo: '+91' + usernumber)
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((element) {
              log(element.toString());
              log('line 133' + element.reference.id.toString());
              data = element.reference.id ?? '';
            }));
    return data;
  }

  getLastMessageAndTime(String senderUserId, String currentUserId) async {
    var data;
    final snap = await fbService.firestore
        .collection(senderUserId + '_' + currentUserId)
        .orderBy('time')
        .limit(1)
        .get();
    if (snap.docs.length == 0) {
      await fbService.firestore
          .collection(currentUserId + '_' + senderUSerId)
          .orderBy('time')
          .limit(1)
          .get()
          .then((value) => value.docs.forEach((element) {
                data = element.data();
              }));
    } else {
      snap.docs.forEach((element) {
        data = element.data();
      });
    }
    log(data.toString());
    return data;
  }

  setIsSearchingTrue() {
    isSearching = true;
  }

  setIsSearchingFalse() {
    isSearching = false;
  }
}

// class Message {
//   final String time;
//   final String text;
//   final bool unread;

//   Message(this.time, this.text, this.unread);
// }
//
//
// var query  = await databaseReference.collection('Staffs').document("horlaz229@gmail.com"). collection('Wallet').getDocuments()
