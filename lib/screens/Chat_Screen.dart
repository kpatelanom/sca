import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sca/Service/ChatController.dart';
import 'package:sca/Service/Firebase.dart';
import 'package:sca/model/Message_model.dart';
import 'dart:developer';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String senderUserId;
  final String currentUserId;
  final String name;
  final String imageUrl;
  ChatScreen(this.senderUserId, this.currentUserId, this.name, this.imageUrl);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatC = Get.put(ChatController());
  TextEditingController textMessage = TextEditingController();
  FireBaseService fbService = FireBaseService();
  ScrollController _scrollController = new ScrollController();
  // bool isCollectionAvailable = true;
  @override
  void initState() {
    super.initState();
    chatC.getSenderData(widget.senderUserId);
    //callCheckCollection();
  }

  // callCheckCollection() async {
  //   bool a =
  //       await chatC.checkCollection(widget.senderUserId, widget.currentUserId);
  //   setState(() {
  //     isCollectionAvailable = a;
  //   });
  // }

  _chatBubble(QueryDocumentSnapshot message) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(message['time']);
    String formatedTime = DateFormat.jm().format(date);
    log(formatedTime.toString());
    if (message['isme'] != widget.currentUserId) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Color(0xff12DBDA),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5)
                  ],
                ),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: formatedTime,
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w300,
                      wordSpacing: 1,
                      letterSpacing: 0.3,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(text: '\n'),
                  TextSpan(
                    text: message['text'],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        wordSpacing: 1,
                        letterSpacing: 0.3,
                        color: Colors.white),
                  ),
                ]))),
          )
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5)
                  ],
                ),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: formatedTime,
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w300,
                      wordSpacing: 1,
                      letterSpacing: 0.3,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(text: '\n'),
                  TextSpan(
                    text: message['text'],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        wordSpacing: 1,
                        letterSpacing: 0.3,
                        color: Colors.white),
                  ),
                ]))),
          )
        ],
      );
    }
  }

  _sendMessageArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.photo),
              iconSize: 20,
              color: Theme.of(context).primaryColor,
              onPressed: () {}),
          Expanded(
            child: TextField(
              controller: textMessage,
              decoration:
                  InputDecoration.collapsed(hintText: 'Enter a message'),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              iconSize: 26,
              color: Theme.of(context).primaryColor,
              onPressed: () {
                log(textMessage.text);
                chatC.sendMessage(
                  textMessage.text,
                  widget.senderUserId,
                  widget.currentUserId,
                );
                textMessage.text = '';
                _scrollController.animateTo(
                  0.0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF6F6F6),
        appBar: AppBar(
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Colors.white),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.imageUrl),
              ),
              Container(
                padding: EdgeInsets.only(left: 7),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: widget.name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)),
                      TextSpan(text: '\n'),
                      TextSpan(
                          text: chatC.senderData == null
                              ? ''
                              : chatC.senderData['isonline'] == 'true'
                                  ? 'online'
                                  : '',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => {Navigator.pop(context)},
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: fbService.firestore
                        .collection(widget.currentUserId + 'msg')
                        .doc(widget.senderUserId)
                        .collection('message')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                final element = snapshot.data.docs[index];
                                log(element.toString());
                                return _chatBubble(element);
                              });
                    })),
            _sendMessageArea()
          ],
        ));
  }
}
