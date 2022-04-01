import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';
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
                    style: TextStyle(color: Color(0xFFf29d12)),
                  ),
                ),
                FlatButton(
                  onPressed: () => exit(0),
                  /*Navigator.of(context).pop(true)*/
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Color(0xFFf29d12)),
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
                        initialUrl: 'https://flattime.in',
                        javascriptMode: JavascriptMode.unrestricted,
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
                          color: Color(0xFF595959),
                          height: MediaQuery.of(context).size.height,
                            child: Stack(children: [
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
                            ])
                        )
                    // Center(
                    //         child: CircleAvatar(
                    //           backgroundColor: Colors.white,
                    //           child:CupertinoActivityIndicator(animating: true,)
                    //           // CircularProgressIndicator(
                    //           //   valueColor:
                    //           //       AlwaysStoppedAnimation<Color>(Color(0xf2b92b)),
                    //           // ),
                    //         ),
                    //       )
                        : Container(),
                  ])
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CupertinoActivityIndicator(animating: true,),
                        // CircleAvatar(
                        //   backgroundColor: Colors.white,
                        //   child: CircularProgressIndicator(
                        //     valueColor:
                        //         AlwaysStoppedAnimation<Color>(Color(0xf2b92b)),
                        //   ),
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'No internet connection \n Please check your internet settings',
                          style: TextStyle(color: Color(0xFFf29d12)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   color: Colors.transparent,
            //   child: Center(
            //       child: CircleAvatar(
            //     backgroundColor: Colors.white,
            //     child: CupertinoActivityIndicator(animating: true,)
            //     // CircularProgressIndicator(
            //     //   valueColor: AlwaysStoppedAnimation<Color>(Color(0xf2b92b)),
            //     // ),
            //   )),
            // ),
          ]),
        ),
      ),
    );
  }

  // void _popupDialog(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Dialog(
  //           child: Stack(children: [
  //             Container(
  //               height: 220,
  //               child: Column(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(12.0),
  //                     child: Row(
  //                       children: [
  //                         Image.asset(
  //                           'images/logoappbar.png',
  //                           height: 40,
  //                           width: 40,
  //                         ),
  //                         SizedBox(
  //                           width: 10,
  //                         ),
  //                         Text(
  //                           'Share',
  //                           style: TextStyle(
  //                               fontSize: 20, fontWeight: FontWeight.bold),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Positioned(
  //               right: 15,
  //               bottom: 20,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   TextButton(
  //                       onPressed: () async {
  //                         Navigator.pop(context);
  //                         await fetchDescription();
  //                         shareDescription();
  //                       },
  //                       child: Text(
  //                         'SHARE DESCRIPTION',
  //                         style: TextStyle(color: Colors.pink),
  //                       )),
  //                   TextButton(
  //                       onPressed: () async {
  //                         Navigator.pop(context);
  //                         await fetchDescription();
  //                         shareImages();
  //                       },
  //                       child: Text('SHARE BOTH',
  //                           style: TextStyle(color: Colors.pink))),
  //                   TextButton(
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                         shareImages();
  //                       },
  //                       child: Text('SHARE IMAGES',
  //                           style: TextStyle(color: Colors.pink))),
  //                 ],
  //               ),
  //             ),
  //           ]),
  //         );
  //       });
  // }

  // Future<void> shareDescription() async {
  //   _setloading(true);
  //   if (description.isNotEmpty) {
  //     await Share.text('Description', description[0]['title'], 'text/plain');
  //   }
  //   _setloading(false);
  // }

  // Future<void> shareImages() async {
  //   _setloading(true);
  //   if (imageUrl.length == 1) {
  //     var request = await HttpClient()
  //         .getUrl(Uri.parse(imageUrl[0]['attributes']['href']));
  //     var response = await request.close();
  //     Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  //     await Share.file('Share to', '1.jpg', bytes, 'image/jpg',
  //         text: description != null ? description[0]['title'] : '');
  //   } else if (imageUrl.length == 2) {
  //     var request = await HttpClient()
  //         .getUrl(Uri.parse(imageUrl[0]['attributes']['href']));
  //     var response = await request.close();
  //     Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  //     var request1 = await HttpClient()
  //         .getUrl(Uri.parse(imageUrl[1]['attributes']['href']));
  //     var response1 = await request1.close();
  //     Uint8List bytes1 = await consolidateHttpClientResponseBytes(response1);
  //     await Share.files(
  //         'Share to',
  //         {
  //           "1.jpg": bytes,
  //           "2.jpg": bytes1,
  //         },
  //         'image/jpg',
  //         text: description != null ? description[0]['title'] : '');
  //   } else if (imageUrl.length == 3) {
  //     var request = await HttpClient()
  //         .getUrl(Uri.parse(imageUrl[0]['attributes']['href']));
  //     var response = await request.close();
  //     Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  //     var request1 = await HttpClient()
  //         .getUrl(Uri.parse(imageUrl[1]['attributes']['href']));
  //     var response1 = await request1.close();
  //     Uint8List bytes1 = await consolidateHttpClientResponseBytes(response1);
  //     var request2 = await HttpClient()
  //         .getUrl(Uri.parse(imageUrl[2]['attributes']['href']));
  //     var response2 = await request2.close();
  //     Uint8List bytes2 = await consolidateHttpClientResponseBytes(response2);
  //     await Share.files(
  //         'Share to',
  //         {
  //           "1.jpg": bytes,
  //           "2.jpg": bytes1,
  //           "3.jpg": bytes2,
  //         },
  //         'image/jpg',
  //         text: description != null ? description[0]['title'] : '');
  //   } else {
  //     var request = await HttpClient()
  //         .getUrl(Uri.parse(imageUrl[0]['attributes']['href']));
  //     var response = await request.close();
  //     Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  //     var request1 = await HttpClient()
  //         .getUrl(Uri.parse(imageUrl[1]['attributes']['href']));
  //     var response1 = await request1.close();
  //     Uint8List bytes1 = await consolidateHttpClientResponseBytes(response1);
  //     var request2 = await HttpClient()
  //         .getUrl(Uri.parse(imageUrl[2]['attributes']['href']));
  //     var response2 = await request2.close();
  //     Uint8List bytes2 = await consolidateHttpClientResponseBytes(response2);
  //     var request3 = await HttpClient()
  //         .getUrl(Uri.parse(imageUrl[3]['attributes']['href']));
  //     var response3 = await request3.close();
  //     Uint8List bytes3 = await consolidateHttpClientResponseBytes(response3);
  //     await Share.files(
  //         'Share to',
  //         {"1.jpg": bytes, "2.jpg": bytes1, "3.jpg": bytes2, "4.jpg": bytes3},
  //         'image/jpg',
  //         text: description != null ? description[0]['title'] : '');
  //   }
  //   _setloading(false);
  // }

  void _setloading(bool uploading) {
    setState(() {
      isLoading = uploading;
    });
  }

  // Future<void> fetchDescription() async {
  //   _setloading(true);
  //   String url = await controller.currentUrl();
  //   var splittedUrl = url.split('?').toList();
  //   print(splittedUrl);
  //   final webScraper = new WebScraper(splittedUrl[0]);
  //   if (await webScraper.loadWebPage('?${splittedUrl[1]}')) {
  //     description = webScraper
  //         .getElement('div.woocommerce-Tabs-panel > p', ['innerHtml']);
  //     print(description);
  //     setState(() {});
  //   }
  //   _setloading(false);
  // }

  // Future<void> fetchImagesUrl() async {
  //   _setloading(true);
  //   String url = await controller.currentUrl();
  //   var splittedUrl = url.split('?').toList();
  //   print(splittedUrl);
  //   final webScraper = new WebScraper(splittedUrl[0]);
  //   if (await webScraper.loadWebPage('?${splittedUrl[1]}')) {
  //     imageUrl = webScraper
  //         .getElement('div.woocommerce-product-gallery__image > a ', ['href']);
  //     setState(() {});
  //   }
  //   _setloading(false);
  //   // await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
  //   // print(attributes['href']);
  //   // var response = await http.get(attributes['href']);
  //   // print(response.bodyBytes);
  //   // filePath = await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
  //   // var BASE64_IMAGE = filePath;
  //   // final ByteData bytes = await rootBundle.load(BASE64_IMAGE);
  //   // await Share.file('title', 'name', response.bodyBytes, 'mimeType');
  //   // print(bytes);
  // }

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
