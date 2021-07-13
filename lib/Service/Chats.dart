import 'package:sca/Service/Firebase.dart';

class UserChats {
  final String userId;
  final String username;
  final String time;
  final String text;
  final String unread;

  UserChats(this.userId, this.username, this.time, this.text, this.unread);
  FireBaseService fbService = FireBaseService();

  Future<String> userChats(String userId) {
    return fbService.users.doc(userId).collection('chats').add({
      'userid': userId,
      'username': username,
      'time': time,
      'text': text,
      'unread': unread,
    }).then((value) => value.id);
  }
}
