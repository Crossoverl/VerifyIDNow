import 'package:flutter/material.dart';
import 'package:flutter_app1/pages/choose_location.dart';
import 'package:flutter_app1/pages/home.dart';
import 'package:flutter_app1/pages/loading.dart';

main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
      '/location': (context) => ChooseLocation(),
    },
  ));
}
