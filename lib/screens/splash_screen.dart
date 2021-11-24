import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFe3e5e9),
        body: Stack(children: [
          Align(
              alignment: Alignment.center,
              child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Color(0xFFe3e5e9),
                  child: Image.asset('images/logo.png',fit: BoxFit.fill,))),
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
