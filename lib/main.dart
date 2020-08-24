import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:quickfit/ui/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool loggedIn;
SharedPreferences prefs;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick Fit',
      home: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if(prefs.getBool('loggedIn') == null){
        loggedIn = false;
      }else{
        loggedIn = prefs.getBool('loggedIn');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(loggedIn: loggedIn,);
  }
}

