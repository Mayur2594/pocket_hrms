import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pocket_hrms/services/geolocation_services.dart';
import 'package:pocket_hrms/mixins/shared_preferences_mixin.dart';

class BackgroundService with SharedPreferencesMixin {
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'my_foreground', // id
    'Location', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  configureLocalNotificationSetting() async {
    try {
      if (Platform.isIOS || Platform.isAndroid) {
        await flutterLocalNotificationsPlugin.initialize(
          const InitializationSettings(
            iOS: DarwinInitializationSettings(),
            android:
                AndroidInitializationSettings('@drawable/final_pocket_logo'),
          ),
        );
      }

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    } catch (ex) {
      print("Exception in configureLocalNotificationSetting:\n $ex");
    }
  }

  final service = FlutterBackgroundService();
  late bool serviceEnabled;
  configureBackgroundService(String taskName) async {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        autoStartOnBoot: false,
        isForegroundMode: true,
        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'Location',
        initialNotificationContent: 'Pocket HRMS Background Service Running',
        foregroundServiceNotificationId: 2,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
      ),
    );
  }

  startBackgroundService() {
    service.startService();
  }

  getBackgroundTasks() async {
    var tasksList = await getValue("BACKGROUNDSERVICES");
    if (tasksList != null) {
      var bgTaskList = List<String>.from(json.decode(tasksList.toString()));
      return bgTaskList;
    }
    return [];
  }

  @pragma('vm:entry-point')
  static onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
      service.on('setAutoStartOnBootMode').listen((event) {
        service.setAutoStartOnBootMode(false);
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    var tasksList = await BackgroundService().getBackgroundTasks();
    for (var i = 0; i < tasksList.length; i++) {
      BackgroundService().prepareFunctionForExecution(service, tasksList[i]);
    }
  }

  stopBackgroundService() {
    service.invoke('stopService');
  }

  prepareFunctionForExecution(var serviceInstance, String taskName) {
    try {
      BackgroundService().executeFunction(taskName,
          [serviceInstance, BackgroundService().taskIntervals[taskName]]);
    } catch (ex) {
      print("Exception in prepareFunctionForExecution: $ex");
    }
  }

// Function which calls dynamicly from background service as per users instructions
// --------------------------------------------------------------------------------

  Map<String, int> taskIntervals = {
    'gpsTrackingFromTrip': 10, // Run every 1 minute
    'gpsTrackingFromGeoTracking': 15, // Run every 15 minutes
  };

  var functionsList = {
    'gpsTrackingFromTrip': (List<dynamic> args) async =>
        await gpsTrackingFromTrip(args[0], args[1]),
    'gpsTrackingFromGeoTracking': (List<dynamic> args) async =>
        await gpsTrackingFromGeoTracking(args[0], args[1]),
  };

  static gpsTrackingFromTrip(var serviceInstace, int timeInterval) async {
    try {
      Timer.periodic(Duration(seconds: timeInterval), (timer) async {
        if (serviceInstace is AndroidServiceInstance) {
          serviceInstace.setForegroundNotificationInfo(
            title: "Tracking From Trip",
            content:
                "Update ${DateTime.now().toIso8601String()}\n Location: ${await BackgroundService.getCurrentGeoloaction(false)}",
          );
        }
        serviceInstace.invoke(
          'update',
          {
            "current_date":
                "${DateTime.now().toIso8601String()}\n Current Location: ${await BackgroundService.getCurrentGeoloaction(false)}",
          },
        );
      });
    } catch (ex) {
      print("Exception in gpsTrackingFromTrip: $ex");
    }
  }

  static gpsTrackingFromGeoTracking(
      var serviceInstace, int timeInterval) async {
    try {
      Timer.periodic(Duration(seconds: timeInterval), (timer) async {
        if (serviceInstace is AndroidServiceInstance) {
          serviceInstace.setForegroundNotificationInfo(
            title: "Tracking From Geo Track",
            content:
                "Update ${DateTime.now().toIso8601String()}\n Location: ${await BackgroundService.getCurrentGeoloaction(true)}",
          );
        }
        serviceInstace.invoke(
          'update',
          {
            "current_date":
                "${DateTime.now().toIso8601String()}\n Current Location: ${await BackgroundService.getCurrentGeoloaction(true)}",
          },
        );
      });
    } catch (ex) {
      print("Exception in gpsTrackingFromGeoTracking: $ex");
    }
  }

  static getCurrentGeoloaction(bool isAddressRequired) async {
    return await GeolocationServices().getCurrentGPSLocation(isAddressRequired);
  }

  dynamic executeFunction(String functionName, List<dynamic> args) async {
    try {
      if (functionsList.containsKey(functionName)) {
        return await functionsList[functionName]!(args);
      } else {
        throw Exception('Function $functionName not found');
      }
    } catch (ex) {
      print("Exception in executeFunction: $ex");
    }
  }

// Function which calls dynamicly from background service as per users instructions
// --------------------------------------------------------------------------------
}
