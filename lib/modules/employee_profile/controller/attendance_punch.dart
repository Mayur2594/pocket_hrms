import 'dart:convert';

import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:pocket_hrms/services/permissions_handler.dart';
import 'package:pocket_hrms/services/geolocation_services.dart';

class PunchController extends GetxController {
  late CameraController cameraController;
  late Future<void> initializeControllerFuture;
  late final CameraDescription camera;

  PunchController(this.camera);

  @override
  void onInit() {
    // TODO: implement onIniths
    AppPermissionsHandler().AllowCameraPermission();
    getCurrentLocation();
    cameraController = CameraController(
      camera,
      ResolutionPreset.high,
    );
    initializeControllerFuture = cameraController.initialize();

    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    cameraController.dispose();
    super.dispose();
  }

  refreshView() {
    onInit();
  }

  var LocationDetails = [].obs;
  getCurrentLocation() async {
    var CurrentGPLocation =
        await GeolocationServices().getCurrentGPSLocation(true);
    print(CurrentGPLocation);
    LocationDetails.add(json.decode(CurrentGPLocation.toString()));
    print("--------------------------");
    print(LocationDetails);
  }

  Future<XFile> takePicture() async {
    await initializeControllerFuture;
    return await cameraController.takePicture();
  }
}
