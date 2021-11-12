import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app1/pages/camera_screen.dart';
import 'package:flutter_app1/pages/verification_screen.dart';
import 'package:flutter_app1/pages/widgets/rounded_button_widget.dart';
import 'package:flutter_app1/pages/widgets/textform_button.dart';
import 'package:flutter_app1/services/ml_kit_service.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../services/facenet.service.dart';

class TakePhoto extends StatefulWidget {
  late final CameraDescription cameraDescription;

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  String selfiePath = '';
  String idPath = '';
  int tries = 0;
  late Size? imageSize;

  late CameraImage selfieImage;
  late Face selfieFace;

  late CameraImage idImage;
  late Face idFace;

  late bool _isButtonDisabled;

  // Services injection
  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();

  @override
  void initState() {
    super.initState();
    this._isButtonDisabled = true;
    _startUp();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  _startUp() async {
    await _faceNetService.loadModel();
    _mlKitService.initialize();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
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
    double deviceWidth = MediaQuery.of(context).size.width;
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 9,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _displayImageAndButton(selfiePath, 'TAKE SELFIE', 1),
                  Spacer(
                    flex: 1,
                  ),
                  _displayImageAndButton(idPath, 'TAKE ID PHOTO', 0),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox.expand(
                  child: FlatButton(
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
                    child: Text(
                      "Skip",
                      style: TextStyle(fontSize: .03 * deviceWidth),
                    ),
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ),
            ),
            Spacer(
              flex: 3,
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox.expand(
                    child: DisabledButton(
                        key: Key('identification'),
                        isDisabled: _isButtonDisabled,
                        child: RaisedButton(
                          child: Text(
                            'Next',
                            style: TextStyle(fontSize: .03 * deviceWidth),
                          ),
                          onPressed: _verifyImages,
                          textColor: Colors.white,
                          color: Colors.blue,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _displayImageAndButton(
      String path, String buttonText, int cameraDescription) {
    return Expanded(
      flex: 6,
      child: Container(
        margin: EdgeInsets.all(12.0),
        child: AspectRatio(
          aspectRatio: 1 / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RoundedButton(
                  text: buttonText,
                  color: 0xFF569EFD,
                  textColor: 0xFFFFFFFF,
                  onClicked: () {
                    openCamera(cameraDescription);
                  }),
              _displayImage(path),
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayImage(String path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
      child: Container(
        alignment: Alignment.center,
        child: AspectRatio(aspectRatio: 2 / 3, child: _displayImageChild(path)),
      ),
    );
  }

  Widget _displayImageChild(String path) {
    if (path == '') {
      return DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        color: Colors.grey,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          child:
              Container(alignment: Alignment.center, child: Icon(Icons.image)),
        ),
      );
    } else {
      return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          child: Container(
              child: Image.file(
            File(path),
            fit: BoxFit.cover,
          )));
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
