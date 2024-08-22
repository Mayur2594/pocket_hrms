import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pocket_hrms/modules/employee_profile/controller/attendance_punch.dart';
import 'package:pocket_hrms/widgets/appbar.dart';
import 'package:pocket_hrms/widgets/appdrawer.dart';

class PunchCameraView extends StatelessWidget {
  final CameraDescription camera;

  const PunchCameraView({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    final PunchController PunchCtrl = Get.put(PunchController(camera));
    return Scaffold(
        appBar: AppBarView(),
        drawer: DrawerView(),
        body: RefreshIndicator(
            onRefresh: () => PunchCtrl.refreshView(),
            child: Obx(() => Stack(
                  alignment: FractionalOffset.center,
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        padding: const EdgeInsets.all(0.0),
                        child: FutureBuilder<void>(
                          future: PunchCtrl.initializeControllerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return CameraPreview(PunchCtrl.cameraController);
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ),
                    Positioned.fill(
                      top: 500,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(220, 236, 233, 230),
                              Color.fromARGB(220, 255, 255, 255),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        DateFormat('hh:mm:s a')
                                            .format(DateTime.now()),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(4.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        DateFormat('EEE, d MMM, yyyy')
                                            .format(DateTime.now()),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Colors.black26,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  child: MaterialButton(
                                      padding: const EdgeInsets.all(14),
                                      color: Colors.green[400],
                                      elevation: 6,
                                      onPressed: () =>
                                          {PunchCtrl.takePicture()},
                                      child: Text(
                                        "PUNCH".tr,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900),
                                      )),
                                ),
                                Container(
                                    padding: const EdgeInsets.all(0.0),
                                    alignment: Alignment.center,
                                    child: MaterialButton(
                                      onPressed: null,
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.refresh,
                                            color: Colors.redAccent,
                                            size: 30,
                                          ),
                                          Text(
                                            "Reset Location",
                                            style: TextStyle(
                                                color: Colors.redAccent),
                                          )
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                            Divider(),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "Address: ${PunchCtrl.LocationDetails.length > 0 ? PunchCtrl.LocationDetails[0]['address'] : "Fetching Address"}",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))));
  }
}
