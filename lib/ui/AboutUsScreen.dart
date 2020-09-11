import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
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
                    'About Us: ',
                    style: TextStyle(
                      color:Color(0xFFC11010),
                      fontWeight: FontWeight.w500,
                      fontSize: 25
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    child: Text(
                      'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsumLorem ipsum Lorem ipsum Lorem ipsum Lorem ipsumLorem ipsumLorem ipsum',
                      style: TextStyle(
                        fontSize: 25
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Image.asset('assets/components/tools.png',height: 150,),
                      Image.asset('assets/components/aboutUsShade.png', width: 250),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
