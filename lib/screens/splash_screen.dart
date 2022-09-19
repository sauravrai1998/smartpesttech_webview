import 'dart:async';

import 'package:craftrox/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 5500),
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
    print(MediaQuery.of(context).size.height);
    print(MediaQuery.of(context).size.width);
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryBackground,
        body: Container(
            // height: 150,
            // width: 150,
            // color: Color(0xFF595959),
            child:
            Center(child: Image.asset('images/splash.gif',fit: BoxFit.fill,))
        ),
      ),
    );
  }
}
