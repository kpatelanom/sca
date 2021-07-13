import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sca/Service/ChatController.dart';
import 'package:sca/model/Message_model.dart';
import 'package:sca/screens/Chat_Screen.dart';
import 'package:sca/Service/HomePageController.dart';
import 'package:intl/intl.dart';
import 'package:sca/Service/Firebase.dart';

class ChatList extends StatefulWidget {
  final String userId;
  ChatList(this.userId) : super();
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final homePageController = Get.put(HomePageController());
  final chatC = Get.put(ChatController());
  FireBaseService fbService = FireBaseService();
  bool isCollectionAvailable = true;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await homePageController.getChatsOfCurrentUSer(widget.userId);
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            fbService.users.doc(widget.userId).collection('chats').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                )
              : snapshot.data.docs.length == 0
                  ? Container()
                  : ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        log(snapshot.data.docs.length.toString());
                        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
                            snapshot.data.docs[index]['time'] ?? 1619945235312);
                        String formatedTime = DateFormat.jm().format(date);
                        return InkWell(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (bu) => ChatScreen(
                                          snapshot.data.docs[index]
                                              ['sender_user_id'],
                                          widget.userId,
                                          snapshot.data.docs[index]['name'],
                                          snapshot.data.docs[index]
                                              ['image_url'],
                                        )))
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40)),
                                        border: Border.all(
                                            width: 2,
                                            color:
                                                Theme.of(context).primaryColor),
                                        // shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5)
                                        ]),
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundImage: snapshot.data.docs[index]
                                                  ['image_url'] ==
                                              ''
                                          ? NetworkImage(
                                              'https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png')
                                          : NetworkImage(snapshot
                                              .data.docs[index]['image_url']),
                                    )),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    padding: EdgeInsets.only(left: 20),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              capitalize(snapshot
                                                  .data.docs[index]['name']),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              formatedTime,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black54),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            snapshot.data.docs[index]
                                                    ['last_text'] ??
                                                '',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                    );
        });
  }
}
