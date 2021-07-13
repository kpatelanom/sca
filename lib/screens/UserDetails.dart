import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sca/Service/CheckUserUsername.dart';
import 'package:sca/Service/Firebase.dart';
import 'package:sca/screens/HomePage.dart';
import 'package:sca/model/User_model.dart';

class UserDetails extends StatefulWidget {
  final String userNumber;
  UserDetails(this.userNumber) : super();
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  FireBaseService fbService = FireBaseService();
  final _formKey = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();

  String _username = '';
  String _name = '';
  String _selectedGender = 'Male';
  String _bio = '';
  String _imageUrl = '';
  String usernameExist;

  PickedFile imageFile;
  final picker = ImagePicker();
  getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      imageFile = pickedFile;
    });
    Navigator.pop(context);
    _uploadImageToFireStorage(imageFile);
  }

  _uploadImageToFireStorage(PickedFile pickedImage) async {
    if (pickedImage == null) return;
    final Reference reference =
        fbService.storage.ref().child('Images/${DateTime.now()}.png');
    EasyLoading.show(status: 'loading...');
    await reference.putFile(File(pickedImage.path));
    _imageUrl = await reference.getDownloadURL();
    EasyLoading.dismiss();
  }

  List<DropdownMenuItem<int>> genderList = [];

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 8,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Sign Up",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
            key: _formKey,
            child: new ListView(
              children: getFormWidget(),
            )),
      ),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = [];

    formWidget.add(
      Center(
        child: Stack(
          children: <Widget>[
            new CircleAvatar(
              radius: 70,
              backgroundImage: imageFile == null
                  ? AssetImage('assets/images/ironman.jpg')
                  : _imageUrl == ''
                      ? AssetImage('assets/images/ironman.jpg')
                      : NetworkImage(_imageUrl),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 40),
                padding: EdgeInsets.symmetric(vertical: 40),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 45,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      isDismissible: true,
                      context: context,
                      builder: ((builder) => bottomSheet()));
                },
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );

    formWidget.add(new SizedBox(
      height: 30,
    ));

    formWidget.add(new TextFormField(
      decoration:
          InputDecoration(labelText: 'Enter Username', hintText: '@username'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        RegExp uvalid = new RegExp(
            r'^(?=.{6,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$');
        if (usernameExist != null) {
          return "Username exist";
        }
        if (uvalid.hasMatch(value)) {
          return null;
        } else {
          return "username not valid";
        }
      },
      onChanged: (value) {
        if (value.length > 5) {
          CheckUserUsername(value)
              .checkUsername()
              .then((value) => {usernameExist = value});
        }
      },
      onSaved: (value) {
        setState(() {
          _username = value;
        });
      },
    ));

    formWidget.add(new TextFormField(
      decoration:
          InputDecoration(labelText: 'Enter Name', hintText: 'jhon smith'),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a name';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _name = value;
        });
      },
    ));

    formWidget.add(new Column(
      children: <Widget>[
        RadioListTile<String>(
          title: const Text('Male'),
          value: 'Male',
          activeColor: Theme.of(context).primaryColor,
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Female'),
          value: 'Female',
          activeColor: Theme.of(context).primaryColor,
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Other'),
          value: 'Other',
          activeColor: Theme.of(context).primaryColor,
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
        ),
      ],
    ));

    formWidget.add(new TextFormField(
      decoration: InputDecoration(
          labelText: 'Write about your self', hintText: 'Bio(Optional)'),
      keyboardType: TextInputType.multiline,
      onSaved: (value) {
        setState(() {
          _bio = value;
        });
      },
    ));

    void onPressedSubmit() {
      if (_formKey.currentState.validate() && usernameExist == null) {
        _formKey.currentState.save();
        UserModel userModel = UserModel(
            _username,
            _name,
            widget.userNumber,
            _selectedGender,
            _imageUrl,
            _bio,
            true,
            DateTime.now().millisecondsSinceEpoch);
        var data = userModel.toJson();
        fbService.users
            .add(data)
            .then((value) => {
                  showToast("Signup successfully", 1),
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(value.id)),
                    (Route<dynamic> route) => false,
                  ),
                })
            .onError((error, stackTrace) => {
                  showToast("Something went wrong", 0),
                });
      }
    }

    formWidget.add(new SizedBox(
      height: 20,
    ));

    formWidget.add(new ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 150, height: 45),
      child: ElevatedButton(
        onPressed: onPressedSubmit,
        child: Text(
          'Submit',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)))),
      ),
    ));

    return formWidget;
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile picture",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera),
                  label: Text("Camera")),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              TextButton.icon(
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image),
                  label: Text("Gallery")),
            ],
          )
        ],
      ),
    );
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
