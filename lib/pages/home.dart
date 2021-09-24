import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map data = {};
  String imagePath = '';

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
                        onPressed: () {
                          Navigator.pushNamed(context, '/location');
                        },
                        icon: Icon(Icons.edit_location),
                        label: Text('Edit Location')),
                    SizedBox(width: 24.0,),
                    FlatButton.icon(
                        onPressed: () async {
                          final result = await Navigator.pushNamed(context, '/take_picture');
                          setState(() {
                            imagePath = result as String;
                          });
                        },
                        icon: Icon(Icons.camera),
                        label: Text('Take Selfie')),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    _displayImage(),
                    SizedBox(width: 12.0),
                    // _displayImage(),
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }

  Widget _displayImage() {
    if (imagePath == '') {
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
        child: Image.file(io.File(imagePath))
      );
    }
  }
}