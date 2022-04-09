import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebViewController controller;
  num position = 1;
  final key = UniqueKey();
  var internet = false;
  bool loadBottomNavBar = false;
  List<Map<String, dynamic>> imageUrl;
  List<Map<String, dynamic>> description;
  bool isProduct = false;
  List<Map<String, dynamic>> attributes;
  var filePath;
  bool isLoading = false;


  doneLoading(String A) async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      position = 0;
      isLoading = false;
      controller.scrollBy(0, 40);
    });
  }

  startLoading(String A) {
    // productCheck();
    setState(() {
      position = 1;
      isLoading = true;
    });

  }

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initPlatformState();
    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
    });

    // if (Platform.isAndroid) {
    //   WebView.platform = SurfaceAndroidWebView();
    // }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      controller.reload();
    });
  }

  Future<void> initPlatformState() async {
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId("a16e971c-d691-46e9-bc66-b35e25522818");


// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _setloading(false);
        String url = await controller.currentUrl();
        print(url.toString());
        if (url == "https://flattime.in/") {
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
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
              content: Text('Do you want to exit an App'),
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
            ),
          );
        } else {
          controller.goBack();
          return false;
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(children: [
            _connectionStatus != 'Failed to get connectivity.'
                ? Stack(children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: WebView(
                        initialUrl: 'https://flattime.in/',
                        // javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (WebViewController wc) {
                          controller = wc;
                        },
                        key: key,
                        onPageFinished: doneLoading,
                        onPageStarted: startLoading,
                        gestureNavigationEnabled: true,
                      ),
                    ),
                    isLoading
                        ?
                        Container(
                          color: darkBackground,
                          height: MediaQuery.of(context).size.height,
                            child: Stack(children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      height: 150,
                                      width: 150,
                                      color: darkBackground,
                                      child: Image.asset('images/logo.png',fit: BoxFit.fill,))),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 40),
                                    child: Container(
                                        height: 100,
                                        color: darkBackground,
                                        child: Image.asset('images/title.png',fit: BoxFit.fill,))
                                ),
                              )
                            ])
                        )
                        : Container(),
                  ])
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CupertinoActivityIndicator(animating: true,),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'No internet connection \n Please check your internet settings',
                          style: TextStyle(color: primaryColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
          ]),
        ),
      ),
    );
  }

  void _setloading(bool uploading) {
    setState(() {
      isLoading = uploading;
    });
  }
    Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    print(result.toString());
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        // case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }
}
