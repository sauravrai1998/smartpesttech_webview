import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFf2b92b),
        body: Stack(children: [
          Align(
              alignment: Alignment.center,
              child: Container(
                  height: 160,
                  width: 160,
                  color: Color(0xFFf2b92b),
                  child: Image.asset('images/logo.png',))),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: CupertinoActivityIndicator(animating: true,)
              // CircleAvatar(
              //   backgroundColor: Colors.white,
              //   child: CircularProgressIndicator(
              //     valueColor:
              //     AlwaysStoppedAnimation<Color>(Colors.pink),
              //   ),
              // ),
            ),
          )
        ]),
      ),
    );
  }
}
