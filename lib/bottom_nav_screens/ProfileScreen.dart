import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickfit/model/User.dart';

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
                            height: 200,
                            width: 200,
                          )),
                      Image.asset('assets/components/darkLine.png',
                          height: 240),
                      Image.asset('assets/components/dimLine.png', height: 250),
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 150),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: widget.user.image_url == 'image name'
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 5, color: Colors.red)),
                                      child: imageSelected == null
                                          ? CircleAvatar(
                                              maxRadius: 80,
                                              backgroundColor:
                                                  Colors.redAccent.shade100,
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
                                              width: 5, color: Colors.red)),
                                      child: imageSelected == null
                                          ? CircleAvatar(
                                              backgroundColor:
                                                  Colors.redAccent.shade100,
                                              maxRadius: 80,
                                              backgroundImage: NetworkImage(
                                                'http://sania.co.uk/quick_fix/${widget.user.image_url}',
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
                          color: Colors.red,
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
                    height: 18,
                  ),
                  ListTile(
                    title: RaisedButton(
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: (){
                        updateMyProfile();
                      },
                      color: Colors.red,
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
    String URL = 'http://sania.co.uk/quick_fix/updateProfile.php';
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
  }

  Widget _buildEmailWidget() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              'Email: ',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            height: 60.0,
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
      margin: const EdgeInsets.only(top: 2, left: 10, right: 10, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              'Name: ',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            height: 60.0,
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
      margin: const EdgeInsets.only(top: 2, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              'Phone: ',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            height: 60.0,
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
