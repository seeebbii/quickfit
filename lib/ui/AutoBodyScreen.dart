import 'package:flutter/material.dart';

class AutoBodyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/autoBodyBG.png',
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
                          color: Colors.red,
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
                    'Auto Body Shop: ',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 25
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
