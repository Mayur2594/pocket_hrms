import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/modules/employee_profile/controller/dashboard.dart';
import 'package:pocket_hrms/widgets/appbar.dart';
import 'package:pocket_hrms/widgets/appdrawer.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController DashboardCtrl = Get.find();
    return Scaffold(
        appBar: AppBarView(),
        drawer: DrawerView(),
        body: RefreshIndicator(
            onRefresh: () => DashboardCtrl.refreshView(),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(8.0), child: Text("Home".tr)),
                ElevatedButton(
                    onPressed: () => {DashboardCtrl.goToPunch()},
                    child: const Text("Punch")),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () =>
                        {DashboardCtrl.allowBackgroundPermission()},
                    child: const Text("Allow Location Prmission")),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () => {
                          DashboardCtrl.startBackgroundService(
                              'gpsTrackingFromTrip')
                        },
                    child: const Text("Start Service for trip")),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () => {
                          DashboardCtrl.startBackgroundService(
                              'gpsTrackingFromGeoTracking')
                        },
                    child: const Text("Start Service fro tracking")),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () => {DashboardCtrl.stopBackgroundService()},
                    child: const Text("Stop Service"))
              ],
            ))));
  }
}
