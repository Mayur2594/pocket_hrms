import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as imglib;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:pocket_hrms/mixins/shared_preferences_mixin.dart';

class faceRecognizationService with SharedPreferencesMixin{
  final FaceDetector _faceDetector = GoogleMlKit.vision.faceDetector();

  Future<List?> getFacesFromRawImage(File image) async {
    try{
    InputImage firebaseVisionImage = InputImage.fromFile(image);
    List<Face> faces =
        await this._faceDetector.processImage(firebaseVisionImage);
        if (faces.isNotEmpty) {
            return faces; 
        }
        else
        {
          return [];
        }
      }
      catch(ex)
      {
        return null;
      }
    
  }

  imglib.Image _cropFaceRaw(imglib.Image image, Face faceDetected) {
  double x = faceDetected.boundingBox.left - 10.0;
  double y = faceDetected.boundingBox.top - 10.0;
  double w = faceDetected.boundingBox.width + 10.0;
  double h = faceDetected.boundingBox.height + 10.0;
  return imglib.copyCrop(image, x: x.round(), y: y.round(), width: w.round(), height: h.round());
}


// Extract RGB values from ARGB pixel
int getRed(int pixel) => (pixel >> 16) & 0xFF;
int getGreen(int pixel) => (pixel >> 8) & 0xFF;
int getBlue(int pixel) => (pixel) & 0xFF;

// Convert image to Float32List, normalized and processed
Float32List imageToByteListFloat32(imglib.Image image) {
  var convertedBytes = Float32List(1 * 112 * 112 * 3); // 112x112 image, 3 channels (RGB)
  var buffer = Float32List.view(convertedBytes.buffer);

  int pixelIndex = 0;
  for (int y = 0; y < 112; y++) {
    for (int x = 0; x < 112; x++) {
      final pixel = image.getPixel(x, y);

      // Extract RGB values and normalize (assuming the pixel class has color accessors)
      buffer[pixelIndex++] = (pixel.r / 255.0); // Normalize Red to [0, 1]
      buffer[pixelIndex++] = (pixel.g / 255.0); // Normalize Green to [0, 1]
      buffer[pixelIndex++] = (pixel.b / 255.0); // Normalize Blue to [0, 1]
    }
  }
  return buffer;
}

List _preProcessRaw(imglib.Image image, Face faceDetected) {
  // Crop the face
  imglib.Image croppedImage = _cropFaceRaw(image, faceDetected);
  imglib.Image resizedImage = imglib.copyResizeCropSquare(croppedImage, size: 112); // Resize to 112x112

  // Convert the cropped and resized image to Float32List
  Float32List imageAsList = imageToByteListFloat32(resizedImage);
  return imageAsList;
}

  late Interpreter interpreter;
  late List predictedData;
  

  Future<List> setCurrentPredictionRaw(
      imglib.Image cameraImage, Face face) async{
    /// crops the face from the image and transforms it to an array of data
    try
    {
      List input = _preProcessRaw(cameraImage, face);

        /// then reshapes input and ouput to model format 🧑‍🔧
        input = input.reshape([1, 112, 112, 3]);
        List output = List.generate(1, (index) => List.filled(192, 0));


      Delegate delegate;

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

        interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite',
            options: interpreterOptions);
       
        interpreter.run(input, output);
        output = output.reshape([192]);

        predictedData = List.from(output);
        return predictedData;
    }
    catch(ex)
    {
      print("Exception in setCurrentPredictionRaw: $ex");
      return [];
    }
    
  }

  double euclideanDistance(List e1, List e2) {
    if (e1.isEmpty || e2.isEmpty) throw Exception("Null argument");

    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }

  Future<Map<String, dynamic>> verifyFace(File currentImageFile) async {

    try{
       double minDist = 999;
       double currDist = 0.0;
       double threshold = 1.0;
    var face = await getFacesFromRawImage(currentImageFile);
    if (face != null && face.isNotEmpty) {
      imglib.Image? image =
          imglib.decodeImage(currentImageFile.readAsBytesSync());
      var predictedData = await setCurrentPredictionRaw(image!, face.first);
      var savedfaces = await getValue("faceImages");
      if(savedfaces != null)
      {
            var savedImg = json.decode(savedfaces);
            List<String> keys = savedImg.keys.toList();

            for(var i = 0 ; i < keys.length;i++)
            {
                currDist = euclideanDistance(predictedData as List, savedImg[keys[i]] as List);
                // await saveValue("faceImages", predictedData.toString().trim());
                if(currDist < threshold)
                {
                  return {"status":'success', "matchingRation": '$currDist', "message":"Face Matched successfully...!"};
                }

            }
              return {"status":'failed', "matchingRation": '$currDist', "message":"Face not Matched...!"};
      }
      else
      {
           return {"status":'success', "matchingRation": '$currDist', "message":"Faces not registered...!"};
      }
    } else {
      return {"status":'failed', "matchingRation": '$currDist', "message":"No face available...!"};
    }
    }
    catch(ex)
    {
      print("Exception ins verify face: $ex");
        return {"status":'failed', "matchingRation": '0', "message":"Something went wrong...!"};
    }
   
  }
}
