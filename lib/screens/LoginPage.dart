import 'package:sca/screens/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sca/screens/Otp.dart';

class LoginPage extends StatefulWidget {
  LoginPage() : super();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNumber = new TextEditingController();
  final RegExp phoneValidate = new RegExp(r"^[6789]\d{9}$");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color(0xFFFF5E03),
          Color(0xFFFF5E06),
          Color(0xFFFF5E10)
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "Welcome",
                        style: TextStyle(color: Colors.white, fontSize: 45),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 90,
                        ),
                        FadeAnimation(
                            1.4,
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(225, 95, 27, .3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: Center(
                                      child: Form(
                                        key: _formKey,
                                        child: TextFormField(
                                          controller: userNumber,
                                          maxLength: 10,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Enter your number';
                                            }
                                            if (!phoneValidate
                                                .hasMatch(value)) {
                                              return 'Please enter correct number';
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          decoration: InputDecoration(
                                              hintText: "Phone number",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 80,
                        ),
                        ConstrainedBox(
                          constraints:
                              BoxConstraints.tightFor(width: 150, height: 45),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                if (phoneValidate.hasMatch(userNumber.text)) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          Otp(userNumber.text)));
                                } else {
                                  // log('pls enter valid phone number');
                                }
                              }
                            },
                            icon: Icon(Icons.arrow_right_alt_rounded),
                            label: Text(
                              'Next',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).primaryColor),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
