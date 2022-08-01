
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mensagemdacruz/screens/home_page.dart';
import 'package:mensagemdacruz/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ad_manager.dart';

void main() {
  runApp(MyApp());
  // WidgetsFlutterBinding.ensureInitialized();
  // Future initFuture = MobileAds.instance.initialize();
  // final adState = AdManager(initialization: initFuture);
  // runApp(
  //   Provider.value(
  //     value: adState,
  //     builder: (context,child)=>MyApp(),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Flat Time');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
      color: Color(0xFF0D0D0E),
    );
  }
}
