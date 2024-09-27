import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/services/background_service.dart';
import 'package:pocket_hrms/services/permissions_handler.dart';
import 'package:pocket_hrms/mixins/shared_preferences_mixin.dart';
import 'package:pocket_hrms/modules/employee_profile/view/punching_camera.dart';

class DashboardController extends GetxController with SharedPreferencesMixin {
  @override
  void onInit() {
    // TODO: implement onIniths
    AppPermissionsHandler().AllowBasicPermissions();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  refreshView() {
    onInit();
  }

  var profilePic =
      "https://images.pexels.com/photos/697509/pexels-photo-697509.jpeg".obs;

  Future<void> goToPunch() async {
    await AppPermissionsHandler().AllowCameraPermission();

    Future.delayed(const Duration(seconds: 2));
    final cameras = await availableCameras();
    // final firstCamera = cameras.first;
    final firstCamera = cameras[1];

    Get.to(PunchCameraView(camera: firstCamera));
  }

  Future<void> allowBackgroundPermission() async {
    AppPermissionsHandler().AllowLocationAlwaysPermission();
  }

  Future<void> startBackgroundService(String taskName) async {
    try {
      var backgroundServices = await getValue("BACKGROUNDSERVICES");
      if (backgroundServices != null) {
        List<String> bgTasksList =
            List<String>.from(json.decode(backgroundServices.toString()));

        if (!bgTasksList.contains(taskName)) {
          bgTasksList.add(taskName);
        }
        saveValue("BACKGROUNDSERVICES", json.encode(bgTasksList));
      } else {
        List<String> bgTasksList = [];
        bgTasksList.add(taskName);
        saveValue("BACKGROUNDSERVICES", json.encode(bgTasksList));
      }
      BackgroundService().configureLocalNotificationSetting();

      // ignore: unrelated_type_equality_checks
      // print("-------------------- battery optimise : ${await checkBatteryOptimizationStatus()}");
      // if (await checkBatteryOptimizationStatus() == false)
      {
        AppPermissionsHandler().checkAndIgnoreBatteryOptimization();
      }
      {
        BackgroundService().configureBackgroundService(taskName);
        BackgroundService().startBackgroundService();
      }
    } catch (ex) {}
  }

  Future<void> stopBackgroundService() async {
    BackgroundService().stopBackgroundService();
  }
}
