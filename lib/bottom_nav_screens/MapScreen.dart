import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  static Position _currentPosition;

  static final CameraPosition shopLocation = CameraPosition(
    target: LatLng(
        25.117347, 55.2193613),
    zoom: 11.205678939819336,
  );

  static final CameraPosition toTheShop = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(
          25.117347, 55.2193613),
      tilt: 59.440717697143555,
      zoom: 15.977951049804688);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  static final MarkerId id = MarkerId('Shop');
  Marker shopMarker = Marker(
      markerId: id,
      position: LatLng(
          25.117347, 55.2193613),
      infoWindow:
          InfoWindow(title: 'Quick Fit', snippet: 'Quick Fit Auto Center'),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: shopLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {
            markers[id] = shopMarker;
          });
        },
        markers: Set<Marker>.of(markers.values),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: goToShop,
          label: Text('To the shop!'),
          icon: Icon(Icons.home),
        ),
      ),
    );
  }

//  static void _launchMapsUrl(LatLng originPlace, LatLng destinationPlace) async {
//    final url = 'https://www.google.com/maps/dir/${originPlace.latitude},${originPlace.longitude}/${destinationPlace.latitude},${destinationPlace.longitude}/';
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
//  }

  Future<void> goToShop() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(toTheShop));
  }
}
