import 'dart:convert';
import 'dart:io' as io;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/pages/take_picture.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  String selfiePath = '';
  String idPath = '';
  String verified = '';

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
                      openCamera(1);
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text('Take photo ID')),
                SizedBox(
                  width: 24.0,
                ),
                FlatButton.icon(
                    onPressed: () async {
                      final result = openCamera(0);
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text('Take Selfie')),
              ],
            ),
            SizedBox(height: 4.0),
            Row(
              children: [
                _displayImage(idPath),
                SizedBox(width: 12.0),
                _displayImage(selfiePath),
              ],
            ),
            SizedBox(height: 40.0),
            FlatButton(
              onPressed: () async {
                // selfie encoding
                io.File selfieFile = new io.File(selfiePath.toString());
                List<int> selfieBytes = selfieFile.readAsBytesSync();
                String selfieBase64 = base64Encode(selfieBytes);

                // drivers license encoding
                io.File dlFile = new io.File(idPath.toString());
                List<int> dlBytes = dlFile.readAsBytesSync();
                String dlBase64 = base64Encode(dlBytes);

                // TODO: address is only for emulator
                final url = Uri.parse('http://10.0.2.2:5000/');
                final response = await http.post(url,
                    body:
                        json.encode({'selfie': selfieBase64, 'dl': dlBase64}));
                if (response.statusCode != 200) {
                  setState(() {
                    verified = 'error';
                  });
                } else {
                  final decoded =
                      json.decode(response.body) as Map<String, dynamic>;
                  setState(() {
                    verified = decoded['result'];
                  });
                }
              },
              child: Text("Verify"),
              color: Colors.lightBlueAccent,
            ),
            SizedBox(height: 40.0),
            Text(verified),
          ],
        ),
      )),
    );
  }

  Widget _displayImage(String path) {
    return Container(
      height: 150,
      width: 150,
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
      ),
      child: _displayImageChild(path),
    );
  }

  Widget _displayImageChild(String path) {
    if (path == '') {
      return Icon(Icons.image);
    } else {
      return Image.file(io.File(path));
    }
  }

  Future<void> openCamera(int cameraType) async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // 1: front camera
    // 0: back camera
    // TODO: should pass cameraType when not using an emulator
    final camera = cameras[1];
    // final result = await Navigator.pushNamed(context, '/take_picture');
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(
          camera: camera,
        ),
      ),
    );
    if (cameraType == 0) {
      setState(() {
        selfiePath = result as String;
      });
    } else {
      setState(() {
        idPath = result as String;
      });
    }
  }
}
