import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/services/permissions_handler.dart';
import 'package:pocket_hrms/mixins/shared_preferences_mixin.dart';

class ProfileController extends GetxController with SharedPreferencesMixin {

  final profileFormKey = GlobalKey<FormState>();
  var formData = {}.obs;
  

var options = <Map<dynamic, dynamic>>[
    {"label": "Reading", "value": false},
    {"label": "Traveling", "value": false},
    {"label": "Cooking", "value": false},
    {"label": "Swimming", "value": false},
  ].obs;

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

  refreshView(){
    
  }

}