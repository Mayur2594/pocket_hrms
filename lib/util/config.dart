import 'package:get/get.dart';

class Config {
  static final Config _instance = Config._internal();

  factory Config() {
    return _instance;
  }

  Config._internal();

  static const String baseUrl = '';
  var pageTitle = 'Pocket HRMS'.obs;

  void setPageTitle(String title) {
    pageTitle.value = title;
  }
}
