import 'package:sca/Service/Firebase.dart';
import 'package:sca/model/User_model.dart';

class AddUser {
  String name;
  String number;
  String username;
  String imageUrl;
  String gender;
  String bio;

  AddUser(String username, String name, String number, String gender,
      String imageUrl, String bio) {
    this.username = username;
    this.name = name.toLowerCase();
    this.number = '+91' + number;
    this.gender = gender;
    this.imageUrl = imageUrl;
    this.bio = bio;
  }

  FireBaseService fbService = FireBaseService();

  Future<String> addUser() async {
    return await fbService.users.add({
      'username': username,
      'name': name,
      'number': number,
      'gender': gender,
      'image_url': imageUrl,
      'bio': bio,
      'isonline': true,
      'last_seen': DateTime.now().millisecondsSinceEpoch
    }).then((value) => value.id);
  }
}
