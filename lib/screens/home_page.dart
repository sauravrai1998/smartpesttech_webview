import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:ededonation/screens/pdf_view_page.dart';
import 'package:ededonation/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ededonation/widgets/exit_alert_dialog.dart';
import 'package:ededonation/widgets/no_internet_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebViewController controller;
  int selectedBottomBarIndex = 0;
  final key = UniqueKey();
  bool isLoading = false;
  bool isPdfOpen = false;
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
      isPdfOpen = false;
    });
  }

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<String> getFileFromUrl(String url) async {
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdfonline.pdf");

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile.path;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

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


  Widget buildAppBar (WebViewController controller) {
    return selectedBottomBarIndex == 3 ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
            onTap: () {
              print('ontap');
              controller.loadUrl(baseUrl3);
            },
            child: Text('Recieved',style: TextStyle(color: primaryColor),)),
        SizedBox(width: 15,),
        GestureDetector(
            onTap: () {
              controller.loadUrl(baseUrl5);
            },
            child: Text('My Donation',style: TextStyle(color: primaryColor))),
      ],
    ) : appBarList[selectedBottomBarIndex];
  }

  List<Widget> appBarList = [
    Text('Home',style: TextStyle(color: primaryColor),),
    Text('Donation',style: TextStyle(color: primaryColor),),
    Text('Fund Raise',style: TextStyle(color: primaryColor),),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
            onTap: () {
            },
            child: Text('Recieved',style: TextStyle(color: primaryColor),)),
        SizedBox(width: 15,),
        Text('My Donation',style: TextStyle(color: primaryColor)),
      ],
    ),
    Text('Account',style: TextStyle(color: primaryColor),),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _setloading(false);
        String url = await controller.currentUrl();
        print(url.toString());
        if ((url == baseUrl && selectedBottomBarIndex == 0) ||
            (url == baseUrl1 && selectedBottomBarIndex == 1) ||
            (url == baseUrl2 && selectedBottomBarIndex == 2) ||
            (url == baseUrl3 && selectedBottomBarIndex == 3) ||
            (url == baseUrl4 && selectedBottomBarIndex == 4)) {
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
          backgroundColor: Colors.white,
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
                        navigationDelegate: (NavigationRequest request) async {
                          print(request.url);
                          setState(() {
                            isPdfOpen = false;
                          });
                          if (request.url.contains("whatsapp.com") ||
                              request.url.contains("tel:") ||
                              request.url.contains("mailto:") ||
                              request.url.contains("geo:") ||
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
                            controller.loadUrl(baseUrl);
                            return NavigationDecision.prevent;
                          } else if (request.url.contains(".pdf")) {
                            var path = await getFileFromUrl(request.url);
                            if (path != null && !isPdfOpen) {
                              print('naviagte');

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PdfViewPage(
                                            path: path,
                                          ))).then((value) => setState(() {
                                    isPdfOpen = true;
                                  }));
                            }
                            return NavigationDecision.prevent;
                          }
                          return NavigationDecision.navigate;
                        },
                      ),
                    ),
                    isLoading ? LoadingWidget() : Container(),
                  ])
                : NoInternetWidget(),
          ]),
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: buildAppBar(controller),
            leading: Builder(
              builder: (context) {
                return IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,), onPressed: () async {
                  String url = await controller.currentUrl();
                  print(url.toString());
                  if ((url == baseUrl && selectedBottomBarIndex == 0) ||
                      (url == baseUrl1 && selectedBottomBarIndex == 1) ||
                      (url == baseUrl2 && selectedBottomBarIndex == 2) ||
                      (url == baseUrl3 && selectedBottomBarIndex == 3) ||
                      (url == baseUrl4 && selectedBottomBarIndex == 4)) {} else {
                    controller.goBack();
                  }
                },);
              }
            ),
            actions: <Widget>[
              if(selectedBottomBarIndex == 4)
              PopupMenuButton<String>(
                icon: Icon(Icons.menu,color: Colors.grey,),
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'About us', 'Contact us', 'How it works', 'Privacy policy'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          bottomNavigationBar: buildBottomNavigationBar(),
        ),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'About us':
        controller.loadUrl('https://ededonation.com/about/');
        break;
      case 'Contact us':
        controller.loadUrl('https://ededonation.com/contact/');
        break;
      case 'How it works':
        controller.loadUrl('https://ededonation.com/how-it-works/');
        break;
      case 'Privacy policy':
        controller.loadUrl('https://ededonation.com/?page_id=3&preview=true');
        break;
    }
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
          currentIndex: selectedBottomBarIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: (int index) {
            setState(() {
              if (selectedBottomBarIndex != index) {
                switch (index) {
                  case 0:
                    controller.loadUrl(baseUrl);
                    break;
                  case 1:
                    controller.loadUrl(baseUrl1);
                    break;
                  case 2:
                    controller.loadUrl(baseUrl2);
                    break;
                  case 3:
                    controller.loadUrl(baseUrl3);
                    break;
                  case 4:
                    controller.loadUrl(baseUrl4);
                    break;
                }
              } else {
                controller.scrollTo(0, 0);
              }
              selectedBottomBarIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.volunteer_activism_outlined),
                label: 'Donation'),
            BottomNavigationBarItem(
                icon: Icon(Icons.add), label: 'Fund Raise'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Notification'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined), label: 'Account'),
          ],
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
