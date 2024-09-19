import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/modules/employee_profile/controller/calendar.dart';
import 'package:pocket_hrms/widgets/appbar.dart';
import 'package:pocket_hrms/widgets/appdrawer.dart';
import 'package:pocket_hrms/widgets/bottombar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final CalendarController CalendarCtrl = Get.find();
    return Scaffold(
      appBar: AppBarView(appBarTitle: "Calend"),
      drawer: DrawerView(),
      body: RefreshIndicator(
         onRefresh: () => CalendarCtrl.refreshView(),
          child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Form(
         key: CalendarCtrl.CalendarFormKey,
          child: Obx(() => Column(
            children: [
              TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: CalendarCtrl.focusedDay.value,
            selectedDayPredicate: (day) {
              return isSameDay(CalendarCtrl.selectedDay.value, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              // Call controller method to update state
              CalendarCtrl.onDaySelected(selectedDay, focusedDay);
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          )
            ],
          ),
        ),
        ),
      )          )
          
      ),
       bottomNavigationBar: BottomBarView(tabName: 'dashboard'),
    );
  }

  


}