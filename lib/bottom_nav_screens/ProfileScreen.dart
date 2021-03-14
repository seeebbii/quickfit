import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickfit/model/User.dart';
import 'package:quickfit/ui/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  User user;

  ProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File imageSelected;
  String base64Image;

  var _emailController = new TextEditingController();
  var _nameController = new TextEditingController();
  var _phoneController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.text = widget.user.email;
    _nameController.text = widget.user.name;
    _phoneController.text = widget.user.phone;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/authBG.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            'assets/images/quickFitColored.png',
                            height: 150,
                            width: 200,
                          )),
                      Image.asset('assets/components/darkLine.png',
                          height: 230),
                      Image.asset('assets/components/dimLine.png', height: 240),
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 140),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: widget.user.image_url == 'image name'
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 5, color: Color(0xFFC11010))),
                                      child: imageSelected == null
                                          ? CircleAvatar(
                                              maxRadius: 80,
                                              backgroundColor:
                                              Color(0xFFC11010),
                                              child: Icon(
                                                Icons.person,
                                                size: 100,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Image.file(
                                              imageSelected,
                                              height: 200,
                                              width: 200,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 5, color: Color(0xFFC11010))),
                                      child: imageSelected == null
                                          ? CircleAvatar(
                                              backgroundColor:
                                              Color(0xFFC11010),
                                              maxRadius: 80,
                                              backgroundImage: NetworkImage(
                                                'http://sania.co.uk/backupapp/quick_fix/${widget.user.image_url}',
                                              ))
                                          : Image.file(
                                              imageSelected,
                                              height: 200,
                                              width: 200,
                                              fit: BoxFit.cover,
                                            ),
                                    )),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 25,
                        child: IconButton(
                          color: Color(0xFFC11010),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: Icon(
                            Icons.menu,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // TODO PROFILE HERE
                  _buildEmailWidget(),
                  _buildNameWidget(),
                  _buildPhoneWidget(),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    title: RaisedButton(
                      padding: const EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      onPressed: (){
                        updateMyProfile();
                      },
                      color: Color(0xFFC11010),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(tempImage!=null){
        imageSelected = tempImage;
      }
    });
  }

  updateMyProfile() async {
    String URL = 'http://sania.co.uk/backupapp/quick_fix/updateProfile.php';
    if(imageSelected != null){
      base64Image = base64Encode(imageSelected.readAsBytesSync());
    }else{
      base64Image = 'null';
    }
    final jsonObj = {
      'image': base64Image,
      'name': _nameController.text.toString(),
      'email': _emailController.text.toString(),
      'phone': _phoneController.text.toString(),
      'id': widget.user.id,
    };
    final response = await http.post(
      URL, // change with your API
      body: jsonObj,
    );
    print(response.body);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(25)),
          child: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 250,
                child: Padding(
                  padding:
                  const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Text(
                          'Profile Updated Successfully',
                          style: TextStyle(
                              letterSpacing: 1.2,
                              fontSize: 19,
                              fontWeight:
                              FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'Changes will apply once you login again...',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'I\'ll do it later',
                              style: TextStyle(
                                  color:
                                  Colors.white,
                                  fontSize: 15),
                            ),
                            color: Color(0xFFC11010),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    20)
                            ),
                          ),
                          FlatButton(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'LogOut Now',
                              style: TextStyle(
                                  color:
                                  Colors.white,
                                  fontSize: 15),
                            ),
                            color: Color(0xFFC11010),
                            onPressed: () {
                              Navigator.of(context).pop();
                              logOutHandler(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    20)
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -50,
                child: CircleAvatar(
                  backgroundColor: Color(0xFFC11010),
                  radius: 50,
                  child: Icon(
                    Icons.done_all,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void logOutHandler(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', false);
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }));
  }

  Widget _buildEmailWidget() {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              'Email: ',
              style: TextStyle(
                color: Color(0xFFC11010),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.black, width: 1),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black,
                ),
//                hintStyle: kHintTextStyle
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 2, left: 5, right: 5, bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              'Name: ',
              style: TextStyle(
                color: Color(0xFFC11010),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.black, width: 1),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: _nameController,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: Colors.black,
                ),
//                hintStyle: kHintTextStyle
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 1, left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              'Phone: ',
              style: TextStyle(
                color: Color(0xFFC11010),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.black, width: 1),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.call,
                  color: Colors.black,
                ),
//                hintStyle: kHintTextStyle
              ),
            ),
          ),
        ],
      ),
    );
  }
}
