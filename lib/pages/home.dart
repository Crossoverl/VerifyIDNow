import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_app1/pages/take_picture.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:camera/camera.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map data = {};
  String selfiePath = '';
  String idPath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    FlatButton.icon(
                        onPressed: () async {
                          // Ensure that plugin services are initialized so that `availableCameras()`
                          // can be called
                          WidgetsFlutterBinding.ensureInitialized();

                          // Obtain a list of the available cameras on the device.
                          final cameras = await availableCameras();

                          // Get the back camera from the list of available cameras.
                          final backCamera = cameras[0];
                          // final result = await Navigator.pushNamed(context, '/take_picture');
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TakePictureScreen(
                                // Pass the automatically generated path to
                                // the DisplayPictureScreen widget.
                                camera: backCamera,
                              ),
                            ),
                          );
                          setState(() {
                            idPath = result as String;
                          });
                        },
                        icon: Icon(Icons.camera_alt),
                        label: Text('Take photo ID')),
                    SizedBox(width: 24.0,),
                    FlatButton.icon(
                        onPressed: () async {
                          // Ensure that plugin services are initialized so that `availableCameras()`
                          // can be called
                          WidgetsFlutterBinding.ensureInitialized();

                          // Obtain a list of the available cameras on the device.
                          final cameras = await availableCameras();

                          // Get the front camera from the list of available cameras.
                          final frontCamera = cameras[1];
                          // final result = await Navigator.pushNamed(context, '/take_picture');
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TakePictureScreen(
                                // Pass the automatically generated path to
                                // the DisplayPictureScreen widget.
                                camera: frontCamera,
                              ),
                            ),
                          );
                          setState(() {
                            selfiePath = result as String;
                          });
                        },
                        icon: Icon(Icons.camera_alt),
                        label: Text('Take Selfie')),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    _displayIDImage(),
                    SizedBox(width: 12.0),
                    _displaySelfieImage(),
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }

  Widget _displaySelfieImage() {
    if (selfiePath == '') {
      return Container(
        height: 150,
        width: 150,
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
        ),
        child: Icon(Icons.image),
      );
    } else {
      return Container(
        height: 150,
        width: 150,
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
        ),
        child: Image.file(io.File(selfiePath))
      );
    }
  }

  _displayIDImage() {
    if (idPath == '') {
      return Container(
        height: 150,
        width: 150,
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
        ),
        child: Icon(Icons.image),
      );
    } else {
      return Container(
          height: 150,
          width: 150,
          margin: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
          ),
          child: Image.file(io.File(idPath))
      );
    }
  }
}
