import 'package:get/get.dart';
import './view/signin.dart';
import './controller/signin.dart';

class SigninBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SigninController>(() => SigninController());
  }
}
