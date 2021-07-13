class Message {
  int time;
  String text;
  bool isRead;
  String isMe;

  Message(this.time, this.text, this.isRead, this.isMe);

  Message.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    text = json['text'];
    isRead = json['isread'];
    isMe = json['isme'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['text'] = this.text;
    data['isread'] = this.isRead;
    data['isme'] = this.isMe;
    return data;
  }
}
