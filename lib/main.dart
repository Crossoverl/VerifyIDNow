import 'package:flutter/material.dart';
import 'package:flutter_app1/pages/appointment_info.dart';
import 'package:flutter_app1/pages/home.dart';
import 'package:flutter_app1/pages/loading.dart';
import 'package:flutter_app1/pages/take_photo_screen.dart';

main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/loading': (context) => Loading(),
      '/info': (context) => Info(),
      '/take_photo': (context) => TakePhoto(),
    },
  ));
}
