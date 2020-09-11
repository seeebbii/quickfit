import 'package:flutter/material.dart';

class JoinUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/joinBG.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            SingleChildScrollView(
              child: Column(
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
                  // TODO ABOUT US HERE
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Join Us: ',
                    style: TextStyle(
                        color: Color(0xFFC11010),
                        fontWeight: FontWeight.w500,
                        fontSize: 25),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 8, left: 15),
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.topLeft,
                      child: RaisedButton(
                          elevation: 15,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 60),
                          color: Colors.white.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(
                                  color: Colors.black.withOpacity(0.5),
                                  width: 2)),
                          onPressed: () {},
                          child: Text('Continue All Brands',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400)))),
                  Container(
                      margin: const EdgeInsets.only(top: 2, right: 15),
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.topRight,
                      child: RaisedButton(
                          elevation: 15,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 60),
                          color: Colors.white.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: Color(0xFFC11010), width: 2)),
                          onPressed: () {},
                          child: Text(
                            'Follow to Quicfitautos.com',
                            style: TextStyle(
                                color: Color(0xFFC11010), fontWeight: FontWeight.w400),
                          ))),
                  Container(
                      margin: const EdgeInsets.only(top: 2, left: 15),
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.topLeft,
                      child: RaisedButton(
                          elevation: 15,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 60),
                          color: Colors.white.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: Colors.redAccent, width: 2)),
                          onPressed: () {},
                          child: Text(
                            'Follow on Instagram',
                            style: TextStyle(
                                color: Colors.redAccent, fontWeight: FontWeight.w400),
                          ))),
                  Container(
                      margin: const EdgeInsets.only(top: 2, right: 15),
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.topRight,
                      child: RaisedButton(
                          elevation: 15,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 60),
                          color: Colors.white.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: Colors.lightBlue.shade400, width: 2)),
                          onPressed: () {},
                          child: Text(
                            'Follow on Twitter',
                            style: TextStyle(
                                color: Colors.lightBlue.shade400, fontWeight: FontWeight.w400),
                          ))),
                  Container(
                      margin: const EdgeInsets.only(top: 2, left: 15),
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.topLeft,
                      child: RaisedButton(
                          elevation: 15,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 60),
                          color: Colors.white.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: Colors.blue, width: 2)),
                          onPressed: () {},
                          child: Text(
                            'Follow on Facebook',
                            style: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.w400),
                          ))),
                  Container(
                      margin: const EdgeInsets.only(top: 2, right: 15),
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.topRight,
                      child: RaisedButton(
                          elevation: 15,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 60),
                          color: Colors.white.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: Colors.red, width: 2)),
                          onPressed: () {},
                          child: Text(
                            'Follow on Youtube',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w400),
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
