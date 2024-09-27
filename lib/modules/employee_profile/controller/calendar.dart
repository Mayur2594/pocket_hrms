import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/services/permissions_handler.dart';
import 'package:pocket_hrms/mixins/shared_preferences_mixin.dart';

class CalendarController extends GetxController with SharedPreferencesMixin {

  final CalendarFormKey = GlobalKey<FormState>();
  var formData = {}.obs;

    var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;
  Map<DateTime, List<String>> events = {
    DateTime(2024, 9, 17): ['Event 1', 'Event 2'],
    DateTime(2024, 9, 18): ['Event 3'],
  };



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


  List<String> getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void onDaySelected(DateTime newSelectedDay, DateTime newFocusedDay) {
    selectedDay.value = newSelectedDay;
    focusedDay.value = newFocusedDay;
  }

}