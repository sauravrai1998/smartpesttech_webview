
import 'package:flattime/screens/home_page.dart';
import 'package:flattime/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Flat Time');
    //   FutureBuilder(
    //   future: Future.delayed(Duration(seconds: 3)),
    //   builder: (context, AsyncSnapshot snapshot) {
    //     // Show splash screen while waiting for app resources to load:
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           color: Color(0xFF0D0D0E),
    //           home: Splash());
    //     } else {
    //       // Loading is done, return the app:
    //       return MyHomePage(title: 'Flat Time');
    //     }
    //   },
    // );
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
