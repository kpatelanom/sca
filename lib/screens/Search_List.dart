import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sca/model/Search_user_modal.dart';
import 'package:sca/Service/HomePageController.dart';

import 'dart:developer';

import 'package:sca/screens/Chat_Screen.dart';

class SearchList extends StatefulWidget {
  final String userid;
  SearchList(this.userid);
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  final homePageController = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(builder: (_) {
      // log('line 19' + _.searchData[0]['image_url'].toString());
      return _.searchData == []
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: _.searchData.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async {
                    //  Message(DateTime.now().toString(), null, false)
                    int check = await _.addingFriend(
                        widget.userid,
                        _.searchData[index]['number'],
                        _.searchData[index]['name'],
                        _.searchData[index]['image_url'] == ''
                            ? 'https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png'
                            : _.searchData[index]['image_url']);
                    log("Sender id >>>" + _.senderUSerId);
                    if (check != -1 && _.senderUSerId != '') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (bu) => ChatScreen(
                                  _.senderUSerId,
                                  widget.userid,
                                  _.searchData[index]['name'],
                                  _.searchData[index]['image_url'])));
                    }
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                border: Border.all(
                                    width: 2,
                                    color: Theme.of(context).primaryColor),
                                // shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5)
                                ]),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(_.searchData[index]
                                          ['image_url'] ==
                                      ''
                                  ? 'https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png'
                                  : _.searchData[index]['image_url']),
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            padding: EdgeInsets.only(left: 20),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      _.searchData[index]['name'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                );
              });
    });
  }
}
