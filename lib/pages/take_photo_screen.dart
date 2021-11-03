import 'dart:io' as io;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/pages/camera_screen.dart';
import 'package:flutter_app1/pages/verification_screen.dart';
import 'package:flutter_app1/services/ml_kit_service.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../services/facenet.service.dart';

class TakePhoto extends StatefulWidget {
  late final CameraDescription cameraDescription;

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  Map data = {};
  String selfiePath = '';
  String idPath = '';
  String verified = '';
  int tries = 0;
  late String imagePath;
  late Size? imageSize;

  late CameraImage selfieImage;
  late Face selfieFace;

  late CameraImage idImage;
  late Face idFace;

  bool cameraInitializated = false;
  bool pictureTaked = false;

  late bool _isButtonDisabled;

  // Services injection
  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();

  @override
  void initState() {
    super.initState();
    this._isButtonDisabled = true;
    _startUp();
  }

  _startUp() async {
    await _faceNetService.loadModel();
    _mlKitService.initialize();
  }

  _verifyImages() {
    final response = _faceNetService.predict();

    //TODO: remove, currently for testing
    setState(() {
      verified = response;
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Verification(
          result: response,
          tries: 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take photos'),
        backgroundColor: Colors.lightBlue,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
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
              onPressed: (_isButtonDisabled)? null : ()
              {
                _verifyImages();
                setState(() {
                  tries = tries + 1;
                });
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Verification(
                      result: verified,
                      tries: tries,
                    ),
                  ),
                );
              },
              child: Text("Verify"),
              color: _isButtonDisabled ? Colors.grey : Colors.lightBlueAccent,
            ),
            SizedBox(height: 40.0),
            Text(verified),
            FlatButton(
              onPressed: () {
                setState(() {
                    tries = tries + 1;
                });
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Verification(
                      result: verified,
                      tries: tries,
                    ),
                  ),
                );
              },
              child: Text("Skip"),
              color: Colors.lightBlueAccent,
            ),
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

  Future<void> openCamera(int cameraDescription) async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // 1: front camera
    // 0: back camera
    final camera = cameras[cameraDescription];
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          camera: camera,
        ),
      ),
    );

    if (result[0] == null) {
      print('could not get image path');
      return;
    }

    if (result[1] == null) {
      print('could not detect face');
      return;
    }

    // selfie returned
    if (cameraDescription == 1) {
      setState(() {
        selfiePath = result[0];
        selfieFace = result[1];
        _faceNetService.setSelfieData(selfiePath, selfieFace);
        if (idPath.isNotEmpty) {
          this._isButtonDisabled = false;
        }
      });
    }

    // id photo returned
    else {
      setState(() {
        idPath = result[0];
        idFace = result[1];
        _faceNetService.setidData(idPath, idFace);
        if (selfiePath.isNotEmpty) {
          this._isButtonDisabled = false;
        }
      });
    }
  }
}
