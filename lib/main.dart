import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:quickfit/ui/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool loggedIn;
SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(

    // statusBarColor is used to set Status bar color in Android devices.
      statusBarColor: Colors.transparent,

      // To make Status bar icons color white in Android devices.
      statusBarIconBrightness: Brightness.light,

      // statusBarBrightness is used to set Status bar icon color in iOS.
      statusBarBrightness: Brightness.light
    // Here light means dark color Status bar icons.

  ));
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick Fit',
      home: MyApp(),
      themeMode: ThemeMode.light,
      theme: ThemeData(
          primaryColor: Colors.white,
          primaryColorBrightness: Brightness.light,
          brightness: Brightness.light,
          primaryColorDark: Colors.black,
          canvasColor: Colors.white,
          appBarTheme: AppBarTheme(brightness: Brightness.light)),
      darkTheme: ThemeData(
          primaryColor: Colors.black,
          primaryColorBrightness: Brightness.dark,
          primaryColorLight: Colors.black,
          brightness: Brightness.dark,
          primaryColorDark: Colors.black,
          indicatorColor: Colors.white,
          canvasColor: Colors.black,
          // next line is important!
          appBarTheme: AppBarTheme(brightness: Brightness.dark)),
    ),
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
      if (prefs.getBool('loggedIn') == null) {
        loggedIn = false;
      } else {
        loggedIn = prefs.getBool('loggedIn');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      loggedIn: loggedIn,
    );
  }
}
