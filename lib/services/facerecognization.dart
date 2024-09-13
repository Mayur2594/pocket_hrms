import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as imglib;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class faceRecognizationService {
  final FaceDetector _faceDetector = GoogleMlKit.vision.faceDetector();

  Future<Face> getFacesFromRawImage(File image) async {
    InputImage _firebaseVisionImage = InputImage.fromFile(image);
    List<Face> faces =
        await this._faceDetector.processImage(_firebaseVisionImage);
    return faces.first;
  }

  imglib.Image _cropFaceRaw(imglib.Image image, Face faceDetected) {
    // imglib.Image convertedImage = _convertCameraImage(image);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(image,
        x: x.round(), y: y.round(), width: w.round(), height: h.round());
  }

  Float32List imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    // var buffer = Float32List.view(convertedBytes.buffer);
    return convertedBytes.buffer.asFloat32List();
  }

  List _preProcessRaw(imglib.Image image, Face faceDetected) {
    // crops the face 💇
    imglib.Image croppedImage = _cropFaceRaw(image, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, size: 112);

    // transforms the cropped face to array data
    Float32List imageAsList = imageToByteListFloat32(img);
    return imageAsList;
  }

  late Interpreter interpreter;
  late List predictedData;
  Future loadModel() async {
    if (interpreter == null || interpreter.isDeleted) {
      Delegate delegate;
      try {
        if (Platform.isAndroid) {
          delegate = GpuDelegateV2(
              options: GpuDelegateOptionsV2(
            isPrecisionLossAllowed: false,
            inferencePriority1: 1,
            inferencePriority2: 2,
            inferencePriority3: 3,
          ));
        } else if (Platform.isIOS) {
          delegate = GpuDelegate(
            options: GpuDelegateOptions(
                allowPrecisionLoss: true, enableQuantization: true),
          );
        } else {
          delegate = GpuDelegate(
            options: GpuDelegateOptions(),
          );
        }
        var interpreterOptions = InterpreterOptions()..addDelegate(delegate);

        this.interpreter = await Interpreter.fromAsset('mobilefacenet.tflite',
            options: interpreterOptions);
        print('model loaded successfully');
      } catch (e) {
        print('Failed to load model.');
        print(e);
      }
    }
  }

  Future<List> setCurrentPredictionRaw(
      imglib.Image cameraImage, Face face) async {
    /// crops the face from the image and transforms it to an array of data
    List input = _preProcessRaw(cameraImage, face);

    /// then reshapes input and ouput to model format 🧑‍🔧
    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));

    /// runs and transforms the data 🤖
    interpreter.run(input, output);
    output = output.reshape([192]);

    predictedData = List.from(output);
    return predictedData;
  }

  double euclideanDistance(List e1, List e2) {
    if (e1 == null || e2 == null) throw Exception("Null argument");

    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }

  Future<List<String>> verifyFace(File currentImageFile) async {
    double minDist = 999;
    double currDist = 0.0;
    double threshold = 1.0;

    var face = await getFacesFromRawImage(currentImageFile);
    if (face != null) {
      imglib.Image? image =
          imglib.decodeImage(currentImageFile.readAsBytesSync());
      var predictedData = setCurrentPredictionRaw(image!, face);
      print(predictedData);
      currDist =
          euclideanDistance(predictedData as List, predictedData as List);
      print("--------------------------$currDist");
      return Future.value(['Success', '']);
    } else {
      return Future.value(['Face Not Available', '']);
    }
  }
}
