import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                HomePage()
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF595959),
        body: Stack(
            children: [
              Container(
                color: Colors.white,
                // decoration: new BoxDecoration(
                //     gradient: new LinearGradient(
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,
                //       colors: [
                //         Color(0xFF487DAF),
                //         Color.fromARGB(255, 63, 103, 147),
                //         Color.fromARGB(255, 49, 82, 115),
                //         Color.fromARGB(255, 45, 76, 107)
                //       ],
                //     )),
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        height: 150,
                        width: 150,
                        // color: Color(0xFF595959),
                        child: Image.asset('images/splash.png',fit: BoxFit.fill,))),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom: 40),
              //     child: Container(
              //         height: 100,
              //         color: Color(0xFF595959),
              //         child: Image.asset('images/title.png',fit: BoxFit.fill,))
              //     // CircleAvatar(
              //     //   backgroundColor: Colors.white,
              //     //   child: CircularProgressIndicator(
              //     //     valueColor:
              //     //     AlwaysStoppedAnimation<Color>(Colors.pink),
              //     //   ),
              //     // ),
              //   ),
              // )
            ]),
      ),
    );
  }
}