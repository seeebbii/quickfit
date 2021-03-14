import 'dart:convert';

import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickfit/model/User.dart';
import 'package:quickfit/ui/HomePage.dart';
import 'package:quickfit/ui/SignUpScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _validate = false;
  var emailController = new TextEditingController();
  var passwordController = new TextEditingController();

  void loginUser() async{
    // LOADING INDICATOR
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return loading;
      },
    );
    String email, pass;
    email = emailController.text.trim();
    pass = passwordController.text.trim();
    String URL = 'http://sania.co.uk/backupapp/quick_fix/iosClientLogin.php';
    // CREATING JSON OBJECT TO POST OVER LINK
    String jsonObj = jsonEncode(<String, dynamic>{
      'user_email' : email,
      'user_password' : pass,
    });
    // MAKING AN API REQUEST
    http.Response response = await http.post(
      URL,
      headers: <String, String>{'Content-Type' : 'application/json'},
      body: jsonObj,
    );
    Navigator.of(context).pop();
    if(response.statusCode == 200){
      Fluttertoast.showToast(
          msg: "Login successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0);
      saveObjectToPreferences(User.fromJson(json.decode(response.body)));
      await Future.delayed(Duration(seconds: 1), (){
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){
          return HomePage();
        }));
      });
    }else if(response.statusCode == 401){
      print(response.body);
      Fluttertoast.showToast(
          msg: "Invalid Credentials",
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

  void saveObjectToPreferences(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', user.id);
    prefs.setBool('loggedIn', true);
    prefs.setString('name', user.name);
    prefs.setString('email', user.email);
    prefs.setString('phone', user.phone);
    prefs.setString('verified', user.is_phone_verified);
    prefs.setString('image_url', user.image_url);
    prefs.setString('status', user.status);
  }


  void loginValidate() {
    if(emailController.text =='' || passwordController.text==''){
      setState(() {
        _validate = true;
      });

    }else{
      setState(() {
        _validate = false;
      });
      //TODO LOGIN USER
      loginUser();
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
                              )
                          ),
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
                        'Login Form',
                        style: TextStyle(
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      _buildEmailField(),
                      _buildPasswordField(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                              onPressed: loginValidate,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  letterSpacing: 1,
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: (){
                              print('forgot pass pressed');
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 2,
                        indent: 50,
                        endIndent: 50,
                      ),
                      _buildSignUpButton()
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

  Widget _buildEmailField() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 5),
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
            errorText: _validate == false ? null :'Value Can\'t Be Empty',
            labelText: "Email",
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

  Widget _buildPasswordField() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
            errorText: _validate == false ? null :'Value Can\'t Be Empty',
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

  Widget _buildSignUpButton() {
    return GestureDetector(
      onTap: (){
        emailController.clear();
        passwordController.clear();
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){
          return SignUpScreen();
        }));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15.0),
        alignment: Alignment.bottomCenter,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Don\'t have an Account? ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Create one',
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
