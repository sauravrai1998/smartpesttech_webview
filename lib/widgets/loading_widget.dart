import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black.withOpacity(0.15),
        // height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          Align(
              alignment: Alignment.center,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.white,
                    ),
                    child: CupertinoActivityIndicator(animating: true,),),
              )),
        ])
    );
  }
}