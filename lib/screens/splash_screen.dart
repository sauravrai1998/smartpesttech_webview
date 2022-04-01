import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF595959),
        body: Stack(children: [
          Align(
              alignment: Alignment.center,
              child: Container(
                  height: 150,
                  width: 150,
                  color: Color(0xFF595959),
                  child: Image.asset('images/logo.png',fit: BoxFit.fill,))),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Container(
                  height: 100,
                  color: Color(0xFF595959),
                  child: Image.asset('images/title.png',fit: BoxFit.fill,))
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
