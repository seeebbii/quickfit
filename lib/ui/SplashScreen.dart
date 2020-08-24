import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'LoginScreen.dart';

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class SplashScreen extends StatefulWidget {
  bool loggedIn;

  SplashScreen({Key key, this.loggedIn}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void navigateToHome() {
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }

  void navigateToLogin() {
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#C11010'.toColor(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/logo/quickFitLogo.png',
              height: 150,
              width: MediaQuery.of(context).size.width - 100,
              fit: BoxFit.fill,
            ),
            Container(
              child: Column(
                children: [
                  Divider(
                    height: 5,
                    thickness: 1.2,
                    color: Colors.white,
                    indent: 150,
                    endIndent: 150,
                  ),
                  FlatButton(
                    onPressed: () {
                      if(widget.loggedIn == true){
                        navigateToHome();
                      }else{
                        navigateToLogin();
                      }
//                      navigateToHome();
                    },
                    child: Text(
                      'Get Started',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  Divider(
                    height: 5,
                    thickness: 1.2,
                    color: Colors.white,
                    indent: 150,
                    endIndent: 150,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
