import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickfit/model/OffersModel.dart';
import 'package:http/http.dart' as http;
import 'package:quickfit/model/User.dart';

class OffersScreen extends StatefulWidget {
  User user;
  Position position;

  OffersScreen({Key key, this.user, this.position}) : super(key: key);

  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  List<OffersModel> offersList = <OffersModel>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    readOffers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/offersBG.png',
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
                    Image.asset('assets/components/darkLine.png', height: 240),
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
                // TODO OFFERS HERE
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    'Select Offers',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 25),
                  ),
                ),
                FutureBuilder(
                  future: readOffers(),
                  builder: (BuildContext context, AsyncSnapshot<List> offers) {
                    if (offers.hasData) {
                      return Expanded(
                        child: ListView.builder(
                          cacheExtent: 900,
                          padding: const EdgeInsets.all(5),
                          itemCount: offersList.length,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 5, color: Colors.red)),
                                        child: CircleAvatar(
                                            backgroundColor:
                                            Colors.redAccent.shade100,
                                            maxRadius: 50,
                                            backgroundImage: NetworkImage(
                                              'http://sania.co.uk/quick_fix/${offersList[index]
                                                  .image_url}',
                                            )),
                                      )
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          '${offersList[index].name}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Brands: ${offersList[index]
                                              .offer_brand}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Service: ${offersList[index]
                                              .offer_service}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Detail: ${offersList[index]
                                              .details}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        FlatButton(
                                          color: Colors.red,
                                          onPressed: () {
                                            sendMyRequest(offersList[index]);
                                          },
                                          child: Text(
                                            'Get Offer',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
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

  Future<List> readOffers() async {
    offersList.clear();
    String URL =
        'http://sania.co.uk/quick_fix/getOffers.php?status_code=${widget.user
        .status}';
    http.Response response = await http.get(URL);
    List test = json.decode(response.body);
    for (var i = 0; i < test.length; i++) {
      OffersModel offer = OffersModel(
          test[i]['id'],
          test[i]['name'],
          test[i]['validity_time'],
          test[i]['offer_brand'],
          test[i]['offer_service'],
          test[i]['details'],
          test[i]['image_url']);
      offersList.add(offer);
    }
    return offersList;
  }

  void sendMyRequest(OffersModel offers) async {
    String URL = 'http://sania.co.uk/quick_fix/sendPushNotification.php';
    final jsonObj = {
      'user_id': widget.user.id,
      'qf_name': widget.user.name,
      'qf_email': widget.user.email,
      'qf_phone': widget.user.phone,
      'brandId': '1',
      'selected_brand_name': offers.offer_brand,
      'serviceId': '1',
      'selected_service_name': offers.offer_service,
      'user_lat': widget.position.latitude.toString(),
      'user_long': widget.position.longitude.toString(),
    };
    final response = await http.post(
      URL, // change with your API
      body: jsonObj,
    );
    if (response.body.contains('Yahoo!!! Message sent successfully')) {
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
                              color: Colors.red,
                              onPressed: () {
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
                    backgroundColor: Colors.red,
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
