// formWidget.add(new TextFormField(
//   decoration: InputDecoration(hintText: 'Age', labelText: 'Enter Age'),
//   keyboardType: TextInputType.number,
//   validator: (value) {
//     if (value.isEmpty)
//       return 'Enter age';
//     else
//       return null;
//   },
//   onSaved: (value) {
//     setState(() {
//       _age = int.tryParse(value);
//     });
//   },
// ));

// formWidget.add(new DropdownButton(
//   hint: new Text('Select Gender'),
//   items: genderList,
//   value: _selectedGender,
//   onChanged: (value) {
//     setState(() {
//       _selectedGender = value;
//     });
//   },
//   isExpanded: true,
// ));

// formWidget.add(
//   new TextFormField(
//       key: _passKey,
//       obscureText: true,
//       decoration: InputDecoration(
//           hintText: 'Password', labelText: 'Enter Password'),
//       validator: (value) {
//         if (value.isEmpty)
//           return 'Please Enter password';
//         else if (value.length < 8)
//           return 'Password should be more than 8 characters';
//         else
//           return null;
//       }),
// );

// formWidget.add(
//   new TextFormField(
//       obscureText: true,
//       decoration: InputDecoration(
//           hintText: 'Confirm Password',
//           labelText: 'Enter Confirm Password'),
//       validator: (confirmPassword) {
//         if (confirmPassword.isEmpty) return 'Enter confirm password';
//         var password = _passKey.currentState.value;
//         if (confirmPassword.compareTo(password) != 0)
//           return 'Password mismatch';
//         else
//           return null;
//       },
//       onSaved: (value) {
//         setState(() {
//           _password = value;
//         });
//       }),
// );

// formWidget.add(CheckboxListTile(
//   value: _termsChecked,
//   onChanged: (value) {
//     setState(() {
//       _termsChecked = value;
//     });
//   },
//   subtitle: !_termsChecked
//       ? Text(
//           'Required',
//           style: TextStyle(color: Colors.red, fontSize: 12.0),
//         )
//       : null,
//   title: new Text(
//     'I agree to the terms and condition',
//   ),
//   controlAffinity: ListTileControlAffinity.leading,
// ));

// TextEditingController userName = TextEditingController();
// TextEditingController firstName = TextEditingController();
// TextEditingController lastName = TextEditingController();

// void _onCameraIconPressed() {
//   log("Camera icon clicked");
// }

// @override
// Widget build(BuildContext context) {

// return Scaffold(
//   resizeToAvoidBottomInset: false,
//   appBar: AppBar(
//     title: Text("User Info"),
//   ),
//   body: Column(
//     children: <Widget>[
//       Container(
//         padding: EdgeInsets.only(top: 30),
//         child: InkWell(
//           onTap: () {
//             log('click on image');
//           },
//           child: CircleAvatar(
//             radius: 65,
//             backgroundImage: AssetImage('assets/images/ironman.jpg'),
//             child: Container(
//               margin: EdgeInsets.symmetric(vertical: 40),
//               padding: EdgeInsets.symmetric(vertical: 40),
//               child: IconButton(
//                 icon: Icon(Icons.camera_alt_rounded),
//                 iconSize: 40,
//                 color: Colors.white,
//                 onPressed: () {},
//               ),
//             ),
//           ),
//         ),
//       ),
//       Expanded(
//         child: Container(
//             height: MediaQuery.of(context).size.height * 0.65,
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//             child: Column(children: <Widget>[
//               SizedBox(height: 25),
//               TextFormField(
//                 controller: userName,
//                 decoration: InputDecoration(
//                     labelText: "Enter username", hintText: '@username'),
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Please enter some text';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 25),
//               TextFormField(
//                 controller: firstName,
//                 decoration: InputDecoration(
//                     labelText: "Enter first name", hintText: 'jhon'),
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'pls enter your fist name';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 25),
//               TextFormField(
//                 controller: lastName,
//                 decoration: InputDecoration(
//                     labelText: "Enter last name", hintText: 'doe'),
//               ),
//             ])),
//       ),
//     ],
//   ),
//   floatingActionButton: FloatingActionButton.extended(
//       onPressed: () {
//         AddUser(userName.text, firstName.text, widget.userNumber,
//             lastName.text, null);
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => MyHomePage()));

//         // AddUser(null, null, userNumber.text, null, null);
//       },
//       label: const Text('Next'),
//       icon: const Icon(Icons.arrow_right_alt_rounded),
//       backgroundColor: Theme.of(context).primaryColor),
// );
//}
