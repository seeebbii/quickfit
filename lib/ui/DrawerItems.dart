import 'package:flutter/material.dart';
import 'package:quickfit/model/User.dart';
import 'package:quickfit/ui/AboutUsScreen.dart';
import 'package:quickfit/ui/AutoBodyScreen.dart';
import 'package:quickfit/ui/JoinUsScreen.dart';
import 'package:quickfit/ui/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerItems extends StatelessWidget {
  User user;

  DrawerItems({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            accountName: Text(user.name,
                style: TextStyle(
                    color: Color(0xFFC11010),
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            accountEmail: Text(
              user.email,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            currentAccountPicture: user.image_url == 'image name'
                ? CircleAvatar(
                    backgroundColor: Color(0xFFC11010),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network('http://sania.co.uk/quick_fix/${user.image_url}')),
          ),
          SizedBox(
            height: 8,
          ),
          new ListTile(
            onTap: (){
              const url = 'https://instagram.com/quickfitautocenter';
              _launchURL(url);
            },
            title: Text(
              'Portfolio',
            ),
            leading: Image.asset('assets/logo/insta.png', height: 25,),
          ),
          SizedBox(
            height: 8,
          ),
          new ListTile(
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(builder: (_){
              return AboutUsScreen();
            }));
            },
            title: Text(
              'About Us',
            ),
            leading: Icon(Icons.supervised_user_circle),
          ),
          SizedBox(
            height: 8,
          ),
          new ListTile(
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(builder: (_){
                return AutoBodyScreen();
              }));
            },
            title: Text(
              'Auto Body Shop',
            ),
            leading: Icon(Icons.local_car_wash),
          ),
          SizedBox(
            height: 8,
          ),
          new ListTile(
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(builder: (_){
                return JoinUsScreen();
              }));
            },
            title: Text(
              'Join Us',
            ),
            leading: Icon(Icons.person_add),
          ),
          SizedBox(
            height: 8,
          ),
          new ListTile(
            title: Text(
              'Contact Us',
            ),
            leading: Icon(Icons.call),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 15,
            thickness: 2,
            indent: 50,
            endIndent: 50,
          ),
          new ListTile(
            onTap: () {
              Navigator.of(context).pop();
              logOutHandler(context);
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Color(0xFFC11010),
            ),
            title: Text(
              'Log Out',
              style: TextStyle(color: Color(0xFFC11010)),
            ),
          )
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void logOutHandler(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', false);
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }));
  }
}
