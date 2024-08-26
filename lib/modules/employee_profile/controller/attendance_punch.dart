import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:pocket_hrms/services/permissions_handler.dart';
import 'package:pocket_hrms/services/geolocation_services.dart';

class PunchController extends GetxController with SingleGetTickerProviderMixin {
  late CameraController cameraController;
  late Future<void> initializeControllerFuture;
  late final CameraDescription camera;

  PunchController(this.camera);

  @override
  void onInit() {
    // TODO: implement onIniths
    AppPermissionsHandler().AllowCameraPermission();
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

  desposeController(context) {
    cameraController.dispose();
    Navigator.pop(context);
  }

  refreshView() {
    getCurrentLocation();
  }

  var LocationDetails = {}.obs;
  getCurrentLocation() async {
    var CurrentGPLocation =
        await GeolocationServices().getCurrentGPSLocation(true, false);
    LocationDetails.value = json.decode(CurrentGPLocation.toString());
  }

  Future<XFile> takePicture() async {
    await initializeControllerFuture;
    return await cameraController.takePicture();
  }

  late AnimationController animationController;
  var isProcesing = false.obs;
  void simulateProcess() async {
    isProcesing.value = true;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    // Simulate a process with a delay

    await Future.delayed(const Duration(seconds: 2));
    isProcesing.value = false;
    if (isProcesing.value == false) animationController.stop();
  }
}
