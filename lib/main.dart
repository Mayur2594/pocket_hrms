import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/app_routes.dart';
import 'package:pocket_hrms/services/localization.dart';
import 'package:pocket_hrms/services/logging.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    loggingError(Object exception, dynamic stack) async {
      await LoggingService().logErrorToFile(exception, stack);
    }

// Set up global error handling for Flutter errors
    FlutterError.onError = (FlutterErrorDetails details) {
      // final String currentRoute = Get.currentRoute;
      loggingError(details.exception, details.stack);
      // Optionally, you can also pass it to the default handler
      FlutterError.presentError(details);
    };

    var locale = await LocalizationService().getSavedLocale();
    runApp(MyApp(locale));
  }, (error, stackTrace) async {
    // final String currentRoute = Get.currentRoute;
    await LoggingService().logErrorToFile(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;

  MyApp(this.initialLocale);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LocalizationService(),
      locale: initialLocale,
      fallbackLocale: initialLocale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor:
              Colors.transparent, // Set to transparent for gradient
          elevation: 5, // Remove shadow if needed
        ),
      ),
      initialRoute: '/greytrix/pockethrms/dashboard/',
      getPages: appPages,
    );
  }
}
