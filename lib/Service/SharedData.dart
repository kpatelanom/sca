import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SharedData {
  static final storage = new FlutterSecureStorage();
  static final _userid = 'userid';
  static final _themeMode = 'thememode';
  static final _uid = 'auth_uid';
  setUserLogin(userid) async {
    await storage.write(key: _userid, value: userid);
  }

  isUserLogin() async {
    return await storage.read(key: _userid);
  }

  setUid(uid) async {
    await storage.write(key: _uid, value: uid);
  }

  getUid() async {
    return await storage.read(key: _uid);
  }

  static setThemeMode(String thememode) async {
    await storage.write(key: _themeMode, value: thememode);
  }

  removeUser() async {
    return await storage.delete(key: _userid);
  }

  static getThemeMode() async {
    return await storage.read(key: _themeMode);
  }
}
