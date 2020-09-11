import 'dart:convert';

import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickfit/ui/LoginScreen.dart';
import 'package:http/http.dart' as http;


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _validate = false;
  var emailController = new TextEditingController();
  var nameController = new TextEditingController();
  var phoneController = new TextEditingController();
  var passwordController = new TextEditingController();
  var rePasswordController = new TextEditingController();


  void registerUser()async{
    if(passwordController.text.trim() == rePasswordController.text.trim()){
      // Check if they are greater than 6 in length
      if(passwordController.text.length >= 6){
        // TODO APPROVED
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return loading;
          },
        );
        String email, pass, name, phone;
        email = emailController.text.trim();
        pass = passwordController.text.trim();
        phone = phoneController.text.toString().trim();
        name = nameController.text.trim();
        String URL = 'http://sania.co.uk/quick_fix/iosClientSignUp.php?name=$name&email=$email&phone=$phone&password=$pass';
        // MAKING AN API REQUEST
        http.Response response = await http.get(URL);
        Navigator.of(context).pop();
        if(response.body.contains('Your Account created successfully')){
          Fluttertoast.showToast(
              msg: "Your Account created successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.of(context).pop();
        }else if(response.body.contains('Email already exists')){
          Fluttertoast.showToast(
              msg: "Email already exists",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);
        }else if(response.body.contains('Phone number already exists')){
          Fluttertoast.showToast(
              msg: "Phone number already exists",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }else{
        // TOAST
        Fluttertoast.showToast(
            msg: "Password must be greater than 6.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }else{
      // TOAST
      Fluttertoast.showToast(
          msg: "Your password does not match!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  AlertDialog loading = AlertDialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    content: Container(
      height: 100,
      width: 50,
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15.0)),
      child: AwesomeLoader(
          loaderType: AwesomeLoader.AwesomeLoader4,
          color: Color(0xFFC11010)
      ),
    ),
  );

  void registerValidate() {
    if(emailController.text == '' || passwordController.text=='' || phoneController.text=='' || rePasswordController.text=='' || nameController.text == ''){
      setState(() {
        _validate = true;
      });
    }else{
      setState(() {
        _validate = false;
      });
      //TODO REGISTER USER
      registerUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
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
                          Image.asset('assets/components/dimLine.png',
                              height: 250),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Signup Form',
                        style: TextStyle(
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      _buildEmailField(),
                      _buildFullName(),
                      _buildPhoneNumber(),
                      _buildPasswordField(),
                      _buildRePassword(),
                      Container(
                        width: 150,
                        padding: EdgeInsets.symmetric(vertical: 25.0),
                        child: RaisedButton(
                          elevation: 6.0,
                          padding: EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Color(0xFFC11010),
                          onPressed: registerValidate,
                          child: Text(
                            'Register',
                            style: TextStyle(
                              letterSpacing: 1,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 2,
                        indent: 50,
                        endIndent: 50,
                      ),
                      _buildSignInButton()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 3),
      margin: const EdgeInsets.only(top: 15),
      child: Theme(
        data: new ThemeData(
          primaryColor: Color(0xFFC11010),
          primaryColorDark: Colors.red,
        ),
        child: new TextField(
          controller: nameController,
          cursorColor: Color(0xFFC11010),
          decoration: new InputDecoration(
            prefixIcon: Icon(Icons.person),
            errorText: _validate == false ? null : 'Value Can\'t Be Empty',
            labelText: "Full Name",
            focusColor: Color(0xFFC11010),
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(color: Color(0xFFC11010)),
            ),
            //fillColor: Colors.green
          ),
          style: new TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumber() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 3),
      margin: const EdgeInsets.only(top: 15),
      child: Theme(
        data: new ThemeData(
          primaryColor: Color(0xFFC11010),
          primaryColorDark: Colors.red,
        ),
        child: new TextField(
          keyboardType: TextInputType.phone,
          controller: phoneController,
          cursorColor: Color(0xFFC11010),
          decoration: new InputDecoration(
            prefixIcon: Icon(Icons.contacts),
            errorText: _validate == false ? null : 'Value Can\'t Be Empty',
            labelText: "Phone Number",
            focusColor: Color(0xFFC11010),
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(color: Color(0xFFC11010)),
            ),
            //fillColor: Colors.green
          ),
          style: new TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }

  Widget _buildRePassword() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 3),
      child: Theme(
        data: new ThemeData(
          primaryColor: Color(0xFFC11010),
          primaryColorDark: Colors.red,
        ),
        child: new TextField(
          obscureText: true,
          controller: rePasswordController,
          cursorColor: Color(0xFFC11010),
          decoration: new InputDecoration(
            errorText: _validate == false ? null : 'Value Can\'t Be Empty',
            labelText: "Confirm Password",
            focusColor: Color(0xFFC11010),
            prefixIcon: Icon(Icons.lock),
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(color: Color(0xFFC11010)),
            ),
            //fillColor: Colors.green
          ),
          style: new TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 3),
      margin: const EdgeInsets.only(top: 15),
      child: Theme(
        data: new ThemeData(
          primaryColor: Color(0xFFC11010),
          primaryColorDark: Colors.red,
        ),
        child: new TextField(
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          cursorColor: Color(0xFFC11010),
          decoration: new InputDecoration(
            prefixIcon: Icon(Icons.email),
            errorText: _validate == false ? null : 'Value Can\'t Be Empty',
            labelText: "Email",
            focusColor: Color(0xFFC11010),
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(color:Color(0xFFC11010)),
            ),
            //fillColor: Colors.green
          ),
          style: new TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Theme(
        data: new ThemeData(
          primaryColor: Color(0xFFC11010),
          primaryColorDark: Colors.red,
        ),
        child: new TextField(
          obscureText: true,
          controller: passwordController,
          cursorColor: Color(0xFFC11010),
          decoration: new InputDecoration(
            prefixIcon: Icon(Icons.lock),
            errorText: _validate == false ? null : 'Value Can\'t Be Empty',
            labelText: "Password",
            focusColor: Color(0xFFC11010),
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(color: Color(0xFFC11010)),
            ),
            //fillColor: Colors.green
          ),
          style: new TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15.0),
        alignment: Alignment.bottomCenter,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Already have an Account? ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Sign in',
                style: TextStyle(
                  color: Color(0xFFC11010),
                  decoration: TextDecoration.underline,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
