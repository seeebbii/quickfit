import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:quickfit/model/BrandModel.dart';
import 'package:quickfit/model/ServiceModel.dart';
import 'package:quickfit/model/User.dart';

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
  BrandModel brand;
  Position position;
  User user;

  ServicesScreen({Key key, this.brand, this.position, this.user})
      : super(key: key);
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<ServiceModel> servicesList = <ServiceModel>[];
  List<ServiceModel> filteredServicesList = <ServiceModel>[];

  Future<List> _future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.brand.brandName);
    _future = readServices();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/serviceBG.png',
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
                          height: 150,
                          width: 200,
                        )),
                    Image.asset('assets/components/darkLine.png', height: 230),
                    Image.asset('assets/components/dimLine.png', height: 240),
                    Positioned(
                      top: 40,
                      left: 25,
                      child: IconButton(
                        color: Color(0xFFC11010),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                // TODO HOME HERE
                Container(
                  margin: const EdgeInsets.only(top: 1),
                  child: Text(
                    'Choose your Service',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(25.0),
                    child: TextField(
                      onChanged: (text) {
                        text = text.toLowerCase();
                        setState(() {
                          filteredServicesList = servicesList.where((service) {
                            var serviceName = service.serviceName.toLowerCase();
                            return serviceName.contains(text);
                          }).toList();
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          hintText: 'Search service...',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                FutureBuilder(
                  future: _future,
                  builder: (BuildContext context, AsyncSnapshot<List> brands) {
                    if (brands.hasData) {
                      return Expanded(
                        child: GridView.builder(
                          cacheExtent: 900,
                          padding: const EdgeInsets.all(5),
                          itemCount: filteredServicesList.length,
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: false,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                // TODO REQUEST FUNCTION
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Stack(
                                        overflow: Overflow.visible,
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Container(
                                            height: 300,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                  Text(
                                                    'Do you want to book an appointment?',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                      'You have selected Brand: ${widget.brand.brandName} and Service: ${filteredServicesList[index].serviceName} ', style: TextStyle(
                                                    fontSize: 15
                                                  ),),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      FlatButton(
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15),
                                                        ),
                                                        color: Color(0xFFC11010),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                      ),
                                                      FlatButton(
                                                        child: Text(
                                                          'Book Now',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        color: Color(0xFFC11010),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        onPressed: () {
                                                          sendMyRequest(
                                                              widget.brand,
                                                              filteredServicesList[
                                                                  index]);
                                                        },
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: -50,
                                            child: CircleAvatar(
                                              backgroundColor: Color(0xFFC11010),
                                              radius: 50,
                                              child: Icon(
                                                Icons.assignment_late,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: new Card(
                                  color: Colors.white.withOpacity(0.7),
                                  child: new GridTile(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl:
                                                'http://sania.co.uk/backupapp/quick_fix/services/${filteredServicesList[index].image_url}',
                                            height: 100,
                                            width: 100,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: Text(
                                              '${filteredServicesList[index].serviceName}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
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
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
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

  Future<List> readServices() async {
    filteredServicesList.clear();
    servicesList.clear();
    String URL = 'http://sania.co.uk/backupapp/quick_fix/services_api.php';
    http.Response response = await http.get(URL);
    List test = json.decode(response.body);
    for (var i = 0; i < test.length; i++) {
      ServiceModel newsPage = ServiceModel(test[i]['id'],
          test[i]['name'].toString().split('.')[0], test[i]['image_url']);
      servicesList.add(newsPage);
    }
    filteredServicesList = servicesList;
    return servicesList;
  }

  void sendMyRequest(BrandModel brand, ServiceModel service) async {
    String URL = 'http://sania.co.uk/backupapp/quick_fix/sendPushNotification.php';
    final jsonObj = {
      'user_id': widget.user.id,
      'qf_name': widget.user.name,
      'qf_email': widget.user.email,
      'qf_phone': widget.user.phone,
      'brandId': brand.id,
      'selected_brand_name': brand.brandName,
      'serviceId': service.id,
      'selected_service_name': service.serviceName,
      'user_lat': widget.position.latitude.toString(),
      'user_long': widget.position.longitude.toString(),
    };
    final response = await http.post(
      URL, // change with your API
      body: jsonObj,
    );
    if(response.body.contains('Yahoo!!! Message sent successfully')){
      // POP THE PREVIOUS DIALOG
      Navigator.of(context).pop();
      // DISPLAY A NEW DIALOG WITH SUCCESS MESSAGE
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(25)),
            child: Stack(
              overflow: Overflow.visible,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 250,
                  child: Padding(
                    padding:
                    const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Text(
                            'THANK YOU',
                            style: TextStyle(
                              letterSpacing: 1.2,
                                fontSize: 19,
                                fontWeight:
                                FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            'You have successfully booked an appointment!',
                            style: TextStyle(
                                fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Okay',
                                style: TextStyle(
                                    color:
                                    Colors.white,
                                    fontSize: 15),
                              ),
                              color: Color(0xFFC11010),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop();
                                Navigator.of(context)
                                    .pop();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      20)
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -50,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFFC11010),
                    radius: 50,
                    child: Icon(
                      Icons.assignment_turned_in,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    }else{
      Fluttertoast.showToast(
          msg: "${response.body}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
