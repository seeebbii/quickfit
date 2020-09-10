import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickfit/bottom_nav_screens/ServicesScreen.dart';
import 'package:quickfit/model/BrandModel.dart';
import 'package:quickfit/model/User.dart';
import 'package:quickfit/ui/DrawerItems.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {



  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user;
  List<BrandModel> brandsList = <BrandModel>[];
  List<BrandModel> filteredBrandList = <BrandModel>[];
  Position _currentPosition;
  ScrollController _controller;
  Future<List> _future;
  @override
  void initState() {
    // TODO: implement initState
    _controller = ScrollController(initialScrollOffset: 28.00145346829629);
    super.initState();
    getSavedUser();
    _getCurrentLocation();
    _future = readBrands();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/homeBG.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            Column(
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
                // TODO HOME HERE
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    'Choose your Brand',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 18
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(25.0),
                    child: TextField(
                      onChanged: (text){
                        text = text.toLowerCase();
                        setState(() {
                          filteredBrandList = brandsList.where((brand){
                            var brandName = brand.brandName.toLowerCase();
                            return brandName.contains(text);
                          }).toList();
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          hintText: 'Search brand...',
                          prefixIcon:Icon(Icons.search),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                FutureBuilder(
                  future: _future,
                  builder: (BuildContext context, AsyncSnapshot<List> brands){
                    if(brands.hasData){
                      return Expanded(
                        child: GridView.builder(
                          controller: _controller,
                          cacheExtent: 900,
                          padding: const EdgeInsets.all(5),
                          itemCount: filteredBrandList.length,
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: false,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: (){
                                Navigator.of(context).push(new MaterialPageRoute(builder: (context){
                                  return ServicesScreen(brand: filteredBrandList[index], position: _currentPosition, user: user,);
                                }));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: new Card(
                                  color: Colors.white.withOpacity(0.7),
                                  child: new GridTile(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: 'http://sania.co.uk/quick_fix/brands/${filteredBrandList[index].image_url}', height: 50, width: 100,
                                            placeholder: (context, url) => CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),
                                          Text(
                                            '${filteredBrandList[index].brandName}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }else{
                      return Center(child: CircularProgressIndicator(),);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<List> readBrands() async {
    filteredBrandList.clear();
    brandsList.clear();
    String URL = 'http://sania.co.uk/quick_fix/brands_api.php';
    http.Response response = await http.get(URL);
    List test = json.decode(response.body);
    for (var i = 0; i < test.length; i++) {
      BrandModel newsPage = BrandModel(test[i]['id'],test[i]['name'].toString().split('.')[0], test[i]['image_url']);
      brandsList.add(newsPage);
    }
    filteredBrandList = brandsList;
    return brandsList;
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
    User getUser =
    new User(id, name, email, phone, image_url, is_phone_verified, status);
    setState(() {
      user = getUser;
    });
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
}
