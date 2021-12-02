import 'package:google_ml_kit/google_ml_kit.dart';

class MLKitService {
  // singleton boilerplate
  static final MLKitService _cameraServiceService = MLKitService._internal();

  factory MLKitService() {
    return _cameraServiceService;
  }

  // singleton boilerplate
  MLKitService._internal();

  late FaceDetector _faceDetector;

  FaceDetector get faceDetector => this._faceDetector;

  void initialize() {
    this._faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
      ),
    );
  }

  Future<List<Face>>? getFacesFromImage(InputImage image) async {
    /// proces the image and makes inference 🤖
    List<Face> faces = await this._faceDetector.processImage(image);
    return faces;
  }
}
