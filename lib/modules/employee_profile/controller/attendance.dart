import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pocket_hrms/services/permissions_handler.dart';
import 'package:pocket_hrms/mixins/shared_preferences_mixin.dart';

class AttendanceController extends GetxController with SharedPreferencesMixin {

  final AttendanceFiltersFormKey = GlobalKey<FormState>();
  var attendanceFilters = {}.obs;
  var AttendanceList = [].obs;

  @override
  void onInit() {
    super.onInit();
    getAttendanceList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  refreshView(){
    
  }

  getAttendanceList()
  {
        DateTime now = DateTime.now(); // Get the current date
        String _date = DateFormat('dd').format(now); // Format date
        String month = DateFormat('MMM').format(now); // Format date
        for(var i = int.parse(_date);i > 0; i--)
        {
            AttendanceList.add({"attmonth":month.toString().toUpperCase(), "attDate": "${i<10?"0$i":"$i"}" ,"intime":"09:30", "outtime":"18:45"});
        }
        print("ATtedance List = $AttendanceList");
  }

}