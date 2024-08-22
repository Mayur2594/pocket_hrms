import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class LoggingService {
  Future<String> createDirectory(directoryName) async {
    final dir = Directory(
        '${((Platform.isAndroid) ? await getExternalStorageDirectory() : await getApplicationSupportDirectory())!.path}/$directoryName');

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await dir.exists())) {
      return dir.path;
    } else {
      dir.create();
      return dir.path;
    }
  }

  Future<void> logErrorToFile(Object error, StackTrace stackTrace) async {
    try {
      // Get the directory to store the log file
      final folder = await createDirectory('logs');
      final path = '$folder/error_logs.txt';

      // Open the file in append mode
      final file = File(path).openWrite(mode: FileMode.append);

      // Write the error details
      final now = DateTime.now();
      file.write('[$now] \n');
      file.write('Error: ${error}\n');
      file.write('StackTrace: ${stackTrace}\n\n');

      // Close the file
      await file.close();
    } catch (e) {
      // If logging fails, print to console as a fallback
      print('Failed to log error: $e');
    }
  }
}
