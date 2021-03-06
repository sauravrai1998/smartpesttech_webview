import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(
              'images/logo.png',
              // height: 35,
              // width: 35,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          CupertinoActivityIndicator(animating: true,),
          SizedBox(
            height: 10,
          ),
          Text(
            'No internet connection \n Please check your internet settings',
            style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}