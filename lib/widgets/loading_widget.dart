import 'package:flutter/material.dart';

import '../constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black.withOpacity(0.15),
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          Align(
              alignment: Alignment.center,
              child: Container(
                  height: 150,
                  width: 150,
                  color: darkBackground,
                  child: Image.asset('images/logo.png',fit: BoxFit.fill,))),
        ])
    );
  }
}