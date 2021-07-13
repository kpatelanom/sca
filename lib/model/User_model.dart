class UserModel {
  String username;
  String name;
  String number;
  String gender;
  String imageUrl;
  String bio;
  bool isOnline;
  int lastSeen;

  UserModel(this.username, this.name, this.number, this.gender, this.imageUrl,
      this.bio, this.isOnline, this.lastSeen);

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    name = json['name'];
    number = json['number'];
    gender = json['gender'];
    imageUrl = json['image_url'];
    bio = json['bio'];
    isOnline = json['isonline'];
    lastSeen = json['last_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['name'] = this.name;
    data['number'] = '+91' + this.number;
    data['gender'] = this.gender;
    data['image_url'] = this.imageUrl;
    data['bio'] = this.bio;
    data['isonline'] = this.isOnline;
    data['last_seen'] = this.lastSeen;

    return data;
  }
}
