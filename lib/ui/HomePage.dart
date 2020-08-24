import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickfit/bottom_nav_screens/ChatScreen.dart';
import 'package:quickfit/bottom_nav_screens/HomeScreen.dart';
import 'package:quickfit/bottom_nav_screens/MapScreen.dart';
import 'package:quickfit/bottom_nav_screens/OffersScreen.dart';
import 'package:quickfit/bottom_nav_screens/ProfileScreen.dart';
import 'package:quickfit/model/User.dart';
import 'package:quickfit/ui/DrawerItems.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  User user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget currentScreen;
  Position _currentPosition;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSavedUser();
    _getCurrentLocation();
    currentScreen = HomeScreen();
    currentTab = 0;
  }
  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  List<String> currenTabTitle = [
    'Home',
    'Maps',
    'Offers',
    'Profiles',
  ];

  int currentTab;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageStorage(
          child: currentScreen,
          bucket: bucket,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.chat),
          onPressed: () {
            setState(() {
              currentScreen = ChatScreen(user: widget.user,);
              currentTab = 4;
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        drawer: DrawerItems(user: widget.user,),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shape: CircularNotchedRectangle(),
          notchMargin: 8,
          child: Container(
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              currentScreen = HomeScreen();
                              currentTab = 0;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.home,
                                color: currentTab == 0 ? Colors.red : Colors.grey,
                              ),
                              Text(
                                'Home',
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              currentScreen = MapScreen();
                              currentTab = 1;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: currentTab == 1 ? Colors.red : Colors.grey,
                              ),
                              Text(
                                'Map',
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),

                    // Right Tab bar icons
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              currentScreen = OffersScreen(user: widget.user, position: _currentPosition,);
                              currentTab = 2;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.local_offer,
                                color: currentTab == 2 ? Colors.red : Colors.grey,
                              ),
                              Text(
                                'Offers',
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              currentScreen = ProfileScreen(user: widget.user);
                              currentTab = 3;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.person,
                                color: currentTab == 3 ? Colors.red : Colors.grey,
                              ),
                              Text(
                                'Person',
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  thickness: 10,
                  height: 10,
                  color: Colors.red,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<User> getSavedUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String id, name, email, phone, image_url, is_phone_verified, status;
    id = prefs.getString('id');
    name = prefs.getString('name');
    email = prefs.getString('email');
    phone = prefs.getString('phone');
    image_url = prefs.getString('image_url');
    is_phone_verified = prefs.getString('verified');
    status = prefs.getString('status');
    User user =
        new User(id, name, email, phone, image_url, is_phone_verified, status);
    setState(() {
      widget.user = user;
    });
  }
}
