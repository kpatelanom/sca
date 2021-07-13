import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sca/Service/CheckUserNumber.dart';
import 'package:sca/Service/Firebase.dart';
import 'package:sca/Service/SharedData.dart';
import 'package:sca/screens/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sca/screens/UserDetails.dart';

class Otp extends StatefulWidget {
  final String userNumber;
  Otp(this.userNumber) : super();
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  FireBaseService fbService = FireBaseService();
  SharedData sharedData = SharedData();
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  String userid = '';
  var currentText;

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.dark,
          elevation: 8,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Otp Verification',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Container(
                padding: EdgeInsets.only(top: 30),
                alignment: AlignmentDirectional.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Enter the code sent to',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                    ),
                    Text('+91' + widget.userNumber,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400))
                  ],
                )),
            SizedBox(
              height: 70,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 80),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: PinPut(
                  fieldsCount: 6,
                  onSubmit: (String pin) async {
                    try {
                      await fbService.auth
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: _verificationCode, smsCode: pin))
                          .then((value) async {
                        if (value.user.uid != '')
                          await sharedData.setUid(value.user.uid);
                        if (value.user != null) {
                          SnackBar(content: Text('user login'));
                          checkCurrentUSer();
                        }
                      });
                    } catch (e) {
                      showToast('something went wrong', 0);
                    }
                  },
                  eachFieldHeight: 45,
                  eachFieldWidth: 40,
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  submittedFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  selectedFieldDecoration: _pinPutDecoration,
                  followingFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  _verifyPhone() async {
    await fbService.auth.verifyPhoneNumber(
        phoneNumber: '+91${widget.userNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          EasyLoading.show(status: 'Waiting');
          await fbService.auth
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              checkCurrentUSer();
            } else {
              showToast("Failed login", 0);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          SnackBar(content: Text(e.message));
        },
        codeSent: (String verificationID, int resendCode) {
          log("OTP send to your mobile number");
          setState(() {
            _verificationCode = verificationID;
            showToast("OTP sent to your mobile number", 1);
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }

  void checkCurrentUSer() async {
    final User user = fbService.auth.currentUser;
    if (user != null) {
      String userId = await CheckUserNumber().getUserId(widget.userNumber);
      EasyLoading.dismiss();
      if (userId == null || userId == '') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UserDetails(widget.userNumber)));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MyHomePage(userId)));
      }
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserDetails(widget.userNumber)));
    }
  }

  showToast(String msg, int code) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: code == 1 ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
