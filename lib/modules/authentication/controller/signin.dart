import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/modules/authentication/model/signin.dart';
import 'package:pocket_hrms/services/localization.dart';

class SigninController extends GetxController {
  var userAuthForm = SigninModel(compnaycode: '', username: '', password: '');
}
