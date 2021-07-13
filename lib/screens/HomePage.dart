import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sca/Service/SharedData.dart';
import 'package:sca/Service/HomePageController.dart';
import 'package:sca/screens/Chat_List.dart';
import 'dart:developer';
import 'package:sca/screens/Search_List.dart';

class MyHomePage extends StatefulWidget {
  final String userId;
  MyHomePage(this.userId) : super();
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final sharedData = Get.put(SharedData());
  final homePageController = Get.put(HomePageController());
  Widget appBarTitle = new Text("Inbox", style: TextStyle(color: Colors.white));
  Icon actionIcon = new Icon(Icons.search);
  var userData;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    sharedData.setUserLogin(widget.userId);
    homePageController.getCurrentUserInfo(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          brightness: Brightness.dark,
          elevation: 8,
          leading: IconButton(
            icon: Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {},
          ),
          title: appBarTitle,
          actions: <Widget>[
            new IconButton(
              icon: actionIcon,
              onPressed: () {
                homePageController.setIsSearchingTrue();
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = new Icon(Icons.close);
                    this.appBarTitle = new TextField(
                      autofocus: true,
                      onChanged: (value) async {
                        await homePageController
                            .searchUSers(value.toLowerCase());
                      },
                      cursorColor: Colors.white,
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon:
                              new Icon(Icons.search, color: Colors.white),
                          hintText: "Search...",
                          hintStyle: new TextStyle(color: Colors.white)),
                    );
                  } else {
                    homePageController.setIsSearchingFalse();
                    this.actionIcon = new Icon(Icons.search);
                    this.appBarTitle = new Text("Inbox",
                        style: TextStyle(color: Colors.white));
                  }
                });
              },
            ),
          ]),
      body: GetBuilder<HomePageController>(builder: (_) {
        return _.isSearching
            ? SearchList(widget.userId)
            : ChatList(widget.userId);
      }),
    ));
  }
}
