import 'dart:io';

import 'package:flutter/material.dart';

import '../constants.dart';
class ExitAlertDialog extends StatelessWidget {
  const ExitAlertDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Container(
            child: Image.asset(
              'images/logo.png',
              height: 35,
              width: 35,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text('Are you sure?'),
        ],
      ),
      content: Text('Do you want to exit an app'),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'No',
            style: TextStyle(color: primaryColor),
          ),
        ),
        FlatButton(
          onPressed: () => exit(0),
          /*Navigator.of(context).pop(true)*/
          child: Text(
            'Yes',
            style: TextStyle(color: primaryColor),
          ),
        ),
      ],
    );
  }
}