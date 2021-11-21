import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/pages/appointment_info.dart';
import 'package:flutter_app1/pages/home.dart';
import 'package:flutter_app1/pages/loading.dart';
import 'package:flutter_app1/pages/splash.dart';
import 'package:flutter_app1/pages/take_photo_screen.dart';

main() {
  runApp(MaterialApp(
    initialRoute: '/splash',
    routes: {
      '/splash': (context) => SplashScreen(),
      '/home': (context) => Home(),
      '/loading': (context) => Loading(),
      '/info': (context) => Info(),
      '/take_photo': (context) => TakePhoto(),
    },
  ));
}
