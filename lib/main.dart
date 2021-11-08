import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/pages/appointment_info.dart';
import 'package:flutter_app1/pages/home.dart';
import 'package:flutter_app1/pages/loading.dart';
import 'package:flutter_app1/pages/take_photo_screen.dart';

main() {
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
        '/loading': (context) => Loading(),
        '/info': (context) => Info(),
        '/take_photo': (context) => TakePhoto(),
      },
    ),
  ));
}
