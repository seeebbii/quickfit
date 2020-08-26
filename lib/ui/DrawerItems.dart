import 'package:flutter/material.dart';
import 'package:quickfit/model/User.dart';
import 'package:quickfit/ui/AboutUsScreen.dart';
import 'package:quickfit/ui/AutoBodyScreen.dart';
import 'package:quickfit/ui/JoinUsScreen.dart';
import 'package:quickfit/ui/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                    color: Colors.red,
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
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network('http://sania.co.uk/quick_fix/${user.image_url}')),
          ),
          Container(
            color: Colors.grey.shade200,
            child: new ListTile(
              onTap: () {
                Navigator.of(context).pop();
              },
              title: Text(
                'Home',
              ),
              leading: Icon(Icons.home),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            color: Colors.grey.shade200,
            child: new ListTile(
              title: Text(
                'Portfolio',
              ),
              leading: Icon(Icons.business_center),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            color: Colors.grey.shade200,
            child: new ListTile(
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
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            color: Colors.grey.shade200,
            child: new ListTile(
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
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            color: Colors.grey.shade200,
            child: new ListTile(
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
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            color: Colors.grey.shade200,
            child: new ListTile(
              title: Text(
                'Contact Us',
              ),
              leading: Icon(Icons.call),
            ),
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
          Container(
            color: Colors.grey.shade200,
            child: new ListTile(
              onTap: () {
                Navigator.of(context).pop();
                logOutHandler(context);
              },
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              title: Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          )
        ],
      ),
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
}
