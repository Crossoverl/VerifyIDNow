import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/services/camera.service.dart';
import 'package:flutter_app1/services/ml_kit_service.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  MLKitService _mlKitService = MLKitService();
  CameraService _cameraService = CameraService();
  late Future<void> _initializeControllerFuture;

  bool cameraInitializated = false;
  bool _detectingFaces = false;
  bool pictureTaked = false;

  // switchs when the user press the camera
  bool _saving = false;
  bool _bottomSheetVisible = false;

  late String imagePath;
  late Size imageSize;
  late Face faceDetected;

  @override
  void initState() {
    super.initState();

    /// starts the camera
    _start();
  }

  /// starts the camera
  _start() async {
    _initializeControllerFuture =
        _cameraService.startService(widget.camera);
    await _initializeControllerFuture;

    setState(() {
      cameraInitializated = true;
    });

  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_cameraService.cameraController);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          try {

            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            Face? faceDetected;

            // Attempt to take a picture and get the file `fileImage`
            // where it was saved.
            XFile fileImage = await _cameraService.cameraController.takePicture();
            final inputImage = InputImage.fromFilePath(fileImage.path);
            List<Face>? faces = await _mlKitService.getFacesFromImage(
                inputImage);

            if (faces != null && faces.isNotEmpty) {
              if (faces.length > 0) {
                faceDetected = faces[0];
              } else {
                faceDetected = null;
              }
            }
            Navigator.pop(context, [fileImage.path, faceDetected]);
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        }
    ,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
