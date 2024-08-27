import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionsHandler {
  AllowBasicPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.notification,
      Permission.microphone,
      Permission.manageExternalStorage
    ].request();

    if (statuses[Permission.location]!.isGranted &&
        statuses[Permission.notification]!.isGranted) {
    } else {
      if (statuses[Permission.location]!.isPermanentlyDenied ||
          statuses[Permission.notification]!.isPermanentlyDenied) {
        // If any permission is permanently denied, open app settings
        print(
            "One or more permissions are permanently denied. Opening settings...");
        openAppSettings();
      }
    }
  }

  AllowNotificationPermission() async {
    await Permission.notification.isGranted.then((value) {
      if (!value) {
        Permission.notification.request();
      }
    });
  }

  AllowLocationAlwaysPermission() async {
    try {
      var status = await Permission.locationAlways.status;
      if (!status.isGranted) {
        await Permission.locationAlways.request();
      }
    } catch (ex) {
      print(ex);
    }
  }

  checkAndIgnoreBatteryOptimization() async {
    try {
      var status = await Permission.ignoreBatteryOptimizations.status;
      if (!status.isGranted) {
        await Permission.ignoreBatteryOptimizations.request();
      }
    } catch (ex) {
      print(ex);
    }
  }

  AllowLocationPermission() async {
    try {
      var status = await Permission.location.status;
      if (!status.isGranted) {
        await Permission.location.request();
      }
    } catch (ex) {
      print(ex);
    }
  }

  AllowDirectoryPermission() async {
    try {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        await Permission.manageExternalStorage.request();
      }
    } catch (ex) {
      print(ex);
    }
  }

  AllowCameraPermission() async {
    try {
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        await Permission.camera.request();
      }
    } catch (ex) {
      print(ex);
    }
  }

  void requestIgnoreBatteryOptimizations() {
    if (Platform.isAndroid) {
      // ignore: prefer_const_constructors
      final intent = AndroidIntent(
        action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
      );
      intent.launch();
    }
  }
}
