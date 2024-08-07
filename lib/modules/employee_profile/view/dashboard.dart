import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/modules/employee_profile/controller/dashboard.dart';
import 'package:pocket_hrms/widgets/appbar.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController DashboardCtrl = Get.find();
    return Scaffold(
        appBar: AppBarView(),
        // drawer: const DrawerView(),
        body: RefreshIndicator(
            onRefresh: () => DashboardCtrl.refreshView(),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(8.0), child: Text("Home".tr))
              ],
            ))));
  }
}
