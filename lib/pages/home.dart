import 'dart:convert';
import 'dart:io' as io;

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/pages/take_picture.dart';
import 'package:flutter_app1/services/camera.service.dart';
import 'package:flutter_app1/services/ml_kit_service.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:http/http.dart' as http;
import '../services/facenet.service.dart';

class Home extends StatefulWidget {
  late final CameraDescription cameraDescription;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  String selfiePath = '';
  String idPath = '';
  String verified = '';
  late String imagePath;
  late Size? imageSize;

  late CameraImage selfieImage;
  late Face selfieFace;

  late CameraImage idImage;
  late Face idFace;

  late Future _initializeControllerFuture;

  bool cameraInitializated = false;
  bool pictureTaked = false;

  // switchs when the user press the camera
  bool _saving = false;
  bool _bottomSheetVisible = false;

  // Services injection
  CameraService _cameraService = CameraService();
  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();

  @override
  void initState() {
    super.initState();
  }

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
                    label: Text('Take Selfie')),
                SizedBox(
                  width: 24.0,
                ),
                FlatButton.icon(
                    onPressed: () async {
                      openCamera(0);
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text('Take photo ID')),
              ],
            ),
            SizedBox(height: 4.0),
            Row(
              children: [
                _displayImage(selfiePath),
                SizedBox(width: 12.0),
                _displayImage(idPath),
              ],
            ),
            SizedBox(height: 40.0),
            FlatButton(
              onPressed: () async {
                final response = _faceNetService.predict();
                  setState(() {
                  verified = response;
                });
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
    final camera = cameras[cameraType];
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(
          camera: camera,
        ),
      ),
    );

    if (result[0] == null) {
      print('could not get image');
      return;
    }

    // selfie returned
    if (cameraType == 1) {
      setState(() {
        selfieImage = result[0];
        selfieFace = result[1];
        selfiePath = result[2];
        _faceNetService.setCurrentPrediction(
            selfieImage, selfieFace);
      });
    } else {
      setState(() {
        idImage = result[0];
        idFace = result[1];
        idPath = result[2];
        _faceNetService.setidData(
            idImage, idFace);
      });
    }
  }
}
