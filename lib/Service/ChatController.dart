import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sca/Service/Firebase.dart';
import 'package:sca/model/Message_model.dart';

class ChatController extends GetxController {
  FireBaseService fbService = FireBaseService();

  var senderData;
  var messageData = [];

  getSenderData(String senderUserId) async {
    log(senderUserId.toString());
    senderData = await fbService.users
        .doc(senderUserId)
        .get()
        .then((value) => value.data());
    log(senderData.toString());
    update();
  }

  getFriendMessage(String senderUserId, String currentUserId) async {
    try {
      CollectionReference chatsMessage =
          fbService.firestore.collection(currentUserId + '_' + senderUserId);
      chatsMessage
          .orderBy('time')
          .limit(10)
          .snapshots()
          .map((QuerySnapshot snap) => {
                snap.docs.forEach((element) {
                  log(element.toString());
                  // messageData.add(Message.fromDocumentSnapshot(element));
                })
              })
          .printError(info: 'error exist!!!!!!!!!!!!!!!!!');
      // messageData = querySnapshot.docs.map((doc) => doc.data()).toList();
      log(messageData.toString());
      update();
    } on Exception catch (e) {
      log("There is an error");
    }
  }

  sendMessage(String text, String senderUserId, String currentUserId) async {
    if (currentUserId == '' || senderUserId == '') return;

    CollectionReference chatsMessage =
        fbService.firestore.collection(currentUserId + 'msg');
    int time = DateTime.now().millisecondsSinceEpoch;
    Message message = Message(time, text, false, currentUserId);
    var data = message.toJson();
    await chatsMessage.doc(senderUserId).collection('message').add(data);
    CollectionReference senderChatMessage =
        fbService.firestore.collection(senderUserId + 'msg');
    Message message1 = Message(time, text, false, currentUserId);
    var data1 = message1.toJson();
    await senderChatMessage.doc(currentUserId).collection('message').add(data1);
    // fbService.firestore.collection(senderUserId + 'msg');

    await updateLastMessage(text, time, senderUserId, currentUserId);
    await updateLastMessage(text, time, currentUserId, senderUserId);
    // getFriendMessage(senderUserId, currentUserId);
    update();
  }

  updateLastMessage(
      String text, int time, String senderId, String currentUserId) async {
    await fbService.users
        .doc(currentUserId)
        .collection('chats')
        .where('sender_user_id', isEqualTo: senderId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        element.reference.update({'last_text': text, 'time': time});
      });
    });
  }

  // checkCollection(String senderId, String currentUserId) async {
  //   final snapshot = await fbService.firestore
  //       .collection(senderId + '_' + currentUserId)
  //       .get();
  //   if (snapshot.docs.length == 0) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }
}
