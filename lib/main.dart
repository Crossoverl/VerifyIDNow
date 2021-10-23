import 'package:flutter/material.dart';
import 'package:flutter_app1/pages/appointment_info.dart';
import 'package:flutter_app1/pages/choose_location.dart';
import 'package:flutter_app1/pages/home.dart';
import 'package:flutter_app1/pages/take_photo_screen.dart';
import 'package:flutter_app1/pages/loading.dart';

main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/': (context) => Loading(),
      '/info': (context) => Info(),
      '/home': (context) => Home(),
      '/take_photo': (context) => TakePhoto(),
      '/location': (context) => ChooseLocation(),
    },
  ));
}
