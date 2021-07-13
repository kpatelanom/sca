import 'package:flutter/cupertino.dart';

class NotConnected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "No Internet Connection",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
