import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceNetService {
  // singleton boilerplate
  static final FaceNetService _faceNetService = FaceNetService._internal();

  factory FaceNetService() {
    return _faceNetService;
  }

  // singleton boilerplate
  FaceNetService._internal();

  late Interpreter _interpreter;

  double threshold = 1.0;

  late List _selfData; //use as selfie data
  List get predictedData => this._selfData;

  late List _idData; //use as selfie data
  List get idData => this._idData;

  Future loadModel() async {
    late Delegate delegate;
    try {
      if (Platform.isAndroid) {
        delegate = GpuDelegateV2(
            options: GpuDelegateOptionsV2(
          false,
          TfLiteGpuInferenceUsage.fastSingleAnswer,
          TfLiteGpuInferencePriority.minLatency,
          TfLiteGpuInferencePriority.auto,
          TfLiteGpuInferencePriority.auto,
        ));
      } else if (Platform.isIOS) {
        delegate = GpuDelegate(
          options: GpuDelegateOptions(true, TFLGpuDelegateWaitType.active),
        );
      }
      var interpreterOptions = InterpreterOptions()..addDelegate(delegate);

      this._interpreter = await Interpreter.fromAsset('mobilefacenet.tflite',
          options: interpreterOptions);
      print('model loaded successfully');
    } catch (e) {
      print('Failed to load model.');
      print(e);
    }
  }

  setSelfieData(String imagePath, Face? face) async {
    if (face == null) {
      print('failed to process image');
      return;
    }

    /// crops the face from the image and transforms it to an array of data
    List? input = await _preProcess(imagePath, face);

    if (input == null) {
      print('failed to process image');
      return;
    }

    /// then reshapes input and ouput to model format 🧑‍🔧
    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));

    /// runs and transforms the data 🤖
    this._interpreter.run(input, output);
    output = output.reshape([192]);

    this._selfData = List.from(output);
  }

  setidData(String imagePath, Face? face) async {
    if (face == null) {
      print('failed to process image');
      return;
    }

    /// crops the face from the image and transforms it to an array of data
    List? input = await _preProcess(imagePath, face);

    if (input == null) {
      print('failed to process image');
      return;
    }

    /// then reshapes input and ouput to model format 🧑‍🔧
    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));

    /// runs and transforms the data 🤖
    this._interpreter.run(input, output);
    output = output.reshape([192]);

    this._idData = List.from(output);
  }

  /// takes the predicted data previously saved and do inference
  String predict() {
    double distance = _euclideanDistance(this._idData, this._selfData);
    if (distance <= threshold) {
      return "true";
    }
    return "false";
  }

  /// _preProess: crops the image to be more easy
  /// to detect and transforms it to model input.
  /// [imagePath]: image path
  /// [face]: face detected from imagePath
  Future<List?> _preProcess(String imagePath, Face faceDetected) async {
    // crops the face 💇
    imglib.Image? croppedImage = await _cropFace(imagePath, faceDetected);

    if (croppedImage == null) {
      return null;
    }

    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);

    // transforms the cropped face to array data
    Float32List imageAsList = imageToByteListFloat32(img);
    return imageAsList;
  }

  /// crops the face from the image 💇
  /// [cameraImage]: current image
  /// [face]: face detected
  Future<imglib.Image?> _cropFace(String imagePath, Face faceDetected) async {
    // imglib.Image? convertedImage = _convertCameraImage(image);
    final bytes = await File(imagePath).readAsBytes();
    final imglib.Image? convertedImage = imglib.decodeImage(bytes);

    if (convertedImage == null) {
      return null;
    }

    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(
        convertedImage, x.round(), y.round(), w.round(), h.round());
  }

  Float32List imageToByteListFloat32(imglib.Image image) {
    /// input size = 112
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);

        /// mean: 128
        /// std: 128
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  /// Adds the power of the difference between each point
  /// then computes the sqrt of the result 📐
  double _euclideanDistance(List e1, List e2) {
    if (e1 == null || e2 == null) throw Exception("Null argument");

    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }
}
