import 'dart:io' as io;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/pages/camera_screen.dart';
import 'package:flutter_app1/pages/verification_screen.dart';
import 'package:flutter_app1/pages/widgets/rounded_button_widget.dart';
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

    setState(() {
      tries = tries + 1;
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Verification(
          result: response,
          tries: tries,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Identification'),
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
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(4.0),
                  child: RoundedButton(
                      text: 'TAKE SELFIE',
                      color: 0xFF569EFD,
                      textColor: 0xFFFFFFFF,
                      onClicked: () {
                        openCamera(1);
                      }),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Container(
                  margin: EdgeInsets.all(4.0),
                  child: RoundedButton(
                      text: 'TAKE ID PHOTO',
                      color: 0xFF569EFD,
                      textColor: 0xFFFFFFFF,
                      onClicked: () {
                        openCamera(0);
                      }),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _displayImage(selfiePath),
                SizedBox(width: 12.0),
                _displayImage(idPath),
              ],
            ),
            SizedBox(height: 40.0),
            FlatButton(
              onPressed: (_isButtonDisabled)
                  ? null
                  : () {
                      _verifyImages();
                    },
              child: Text("Verify"),
              color: _isButtonDisabled ? Colors.grey : Colors.lightBlueAccent,
            ),
            SizedBox(height: 40.0),
            FlatButton(
              onPressed: () {
                setState(() {
                  tries = tries + 1;
                });
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Verification(
                      result: "false",
                      tries: tries,
                    ),
                  ),
                );
              },
              child: Text("Skip"),
              color: Colors.lightBlueAccent,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  color: Colors.lightBlueAccent,
                  disabledColor: Colors.grey[400],
                  onPressed: _isButtonDisabled ? null : _verifyImages,
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
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
          action: cameraDescription,
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
