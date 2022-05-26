import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:freex/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freex/widgets/exit_alert_dialog.dart';
import 'package:freex/widgets/no_internet_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebViewController controller;
  final key = UniqueKey();
  bool isLoading = false;
  doneLoading(String A) async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      isLoading = false;
    });
  }

  startLoading(String A) async {
    String url = await controller.currentUrl();
    setState(() {
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
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
    });

    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
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
    OneSignal.shared.setAppId(oneSignalAppId);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  }

  Future<void> _launch(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(
          url,
        ),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _setloading(false);
        String url = await controller.currentUrl();
        print(url.toString());
        if (url == baseUrl) {
          return showDialog(
            context: context,
            builder: (context) => ExitAlertDialog(),
          );
        } else {
          controller.goBack();
          return false;
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(children: [
            _connectionStatus != 'Failed to get connectivity.'
                ? Stack(children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: WebView(
                        initialUrl: baseUrl,
                        javascriptMode: JavascriptMode.unrestricted,
                        userAgent: Platform.isIOS
                            ? 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_2 like Mac OS X) AppleWebKit/605.1.15' +
                                ' (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1'
                            : 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) ' +
                                'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36',
                        onWebViewCreated: (WebViewController wc) {
                          controller = wc;
                        },
                        key: key,
                        onPageFinished: doneLoading,
                        onPageStarted: startLoading,
                        gestureNavigationEnabled: true,
                        navigationDelegate: (NavigationRequest request) {
                          print(request.url);
                          if (request.url.contains("whatsapp.com") ||
                              request.url.contains("tel:") ||
                              request.url.contains("mailto:") ||
                              request.url.contains("join") ||
                              request.url.contains("play.google.com") ||
                              request.url.contains("www.facebook.com") ||
                              request.url.contains("www.instagram.com") ||
                              request.url.contains("linkedin.com") ||
                              request.url.contains("m.youtube.com") ||
                              request.url.contains("facebook.com") ||
                              request.url.contains("mobile.twitter.com/")) {
                            String url = request.url;
                            print(request.url);
                            _launch(url);
                            return NavigationDecision.prevent;
                          }
                          return NavigationDecision.navigate;
                        },
                      ),
                    ),
                    isLoading
                        ?
                        LoadingWidget()
                        : Container(),
                  ])
                : NoInternetWidget(),
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
