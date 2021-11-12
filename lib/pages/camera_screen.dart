import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app1/services/camera.service.dart';
import 'package:flutter_app1/services/ml_kit_service.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

// A screen that allows users to take a picture using a given camera.
class CameraScreen extends StatefulWidget {
  const CameraScreen({
    Key? key,
    required this.camera,
    required this.action,
  }) : super(key: key);

  final CameraDescription camera;
  final int action;

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  MLKitService _mlKitService = MLKitService();
  CameraService _cameraService = CameraService();
  late Future<void> _initializeControllerFuture;

  bool cameraInitializated = false;
  bool pictureTaked = false;

  late String imagePath;
  late Size imageSize;
  late Face faceDetected;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    /// starts the camera
    _start();
  }

  /// starts the camera
  _start() async {
    _initializeControllerFuture = _cameraService.startService(widget.camera);
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
      body: Align(
        alignment: Alignment.center,
        child: FutureBuilder<void>(
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
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: _takePicture,
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 4.0)),
        backgroundColor: Colors.blueGrey.withOpacity(0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _takePicture() async {
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      Face? faceDetected;

      // Attempt to take a picture and get the file `fileImage`
      // where it was saved.
      XFile fileImage = await _cameraService.takePicture();
      final inputImage = InputImage.fromFilePath(fileImage.path);
      List<Face>? faces = await _mlKitService.getFacesFromImage(inputImage);

      if (faces != null) {
        if (faces.length > 0) {
          faceDetected = faces[0];
          Navigator.pop(context, [fileImage.path, faceDetected]);
        } else {
          if (widget.action == 1) {
            faceDetected = null;
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('No face detected!'),
                );
              },
            );
          } else {
            faceDetected = null;
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('ID not detected!'),
                );
              },
            );
          }
        }
      }
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }
}
