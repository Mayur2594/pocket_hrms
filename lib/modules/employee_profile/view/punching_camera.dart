// ignore_for_file: invalid_use_of_protected_member

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pocket_hrms/modules/employee_profile/controller/attendance_punch.dart';
import 'package:pocket_hrms/widgets/googlemap.dart';
import 'package:pocket_hrms/widgets/shimmers.dart';

class PunchCameraView extends StatelessWidget {
  final CameraDescription camera;

  const PunchCameraView({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    final PunchController PunchCtrl = Get.put(PunchController(camera));
    PunchCtrl.refreshView();
    return WillPopScope(
        onWillPop: () => PunchCtrl.desposeController(context),
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Attendance Punch".tr.toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  PunchCtrl.desposeController(context);
                },
              ),
              elevation: 12,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF005C97),
                      Color(0xFF363795),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
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
                                  return CameraPreview(
                                      PunchCtrl.cameraController);
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                        ),
                        Positioned.fill(
                          top: MediaQuery.of(context).size.height * 0.5,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              4.0, 1.0, 4.0, 1.0),
                                          child: StreamBuilder(
                                              stream: Stream.periodic(
                                                  Duration(seconds: 1)),
                                              builder: (context, snapshot) {
                                                return Text(
                                                  DateFormat('hh:mm:ss a')
                                                      .format(DateTime.now()),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24,
                                                    color: Colors.blueGrey,
                                                  ),
                                                );
                                              }),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              4.0, 1.0, 4.0, 1.0),
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
                                              {PunchCtrl.preparePunch(context)},
                                          child: Text(
                                            "PUNCH".tr,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900),
                                          )),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Container(
                                  padding:
                                      EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex:
                                            PunchCtrl.LocationDetails.isNotEmpty
                                                ? 8
                                                : 12,
                                        child: Container(
                                          child: PunchCtrl
                                                  .LocationDetails.isNotEmpty
                                              ? Text(
                                                  "Address: ${PunchCtrl.LocationDetails.value['address']}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )
                                              : SingleLineShimmer(),
                                        ),
                                      ),
                                      Expanded(
                                        flex:
                                            PunchCtrl.LocationDetails.isNotEmpty
                                                ? 4
                                                : 0,
                                        child: PunchCtrl
                                                .LocationDetails.isNotEmpty
                                            ? Container(
                                                child: MaterialButton(
                                                onPressed: () {
                                                  PunchCtrl.simulateProcess();
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    PunchCtrl.isProcesing
                                                                .value ==
                                                            true
                                                        ? AnimatedBuilder(
                                                            builder: (context,
                                                                child) {
                                                              return Transform
                                                                  .rotate(
                                                                angle: PunchCtrl
                                                                        .animationController
                                                                        .value *
                                                                    2.0 *
                                                                    3.14159, // Rotate continuously
                                                                child: child,
                                                              );
                                                            },
                                                            animation: PunchCtrl
                                                                .animationController,
                                                            child: const Icon(
                                                              Icons.refresh,
                                                              color: Colors
                                                                  .redAccent,
                                                            ),
                                                          )
                                                        : const Icon(
                                                            Icons.refresh,
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                    Text(
                                                      "Reset Location",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.redAccent),
                                                    )
                                                  ],
                                                ),
                                              ))
                                            : SizedBox(
                                                width: 0,
                                              ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: PunchCtrl.LocationDetails
                                              .value['latitude'] !=
                                          null
                                      ? MarkersAndRadiusGmapView(
                                          markers: PunchCtrl.markers,
                                          circles: PunchCtrl.circles,
                                          initialPosition: LatLng(
                                              PunchCtrl.LocationDetails
                                                  .value['latitude'],
                                              PunchCtrl.LocationDetails
                                                  .value['longitude']),
                                        )
                                      : SingleBoxShimmer(),
                                  height: 160,
                                  padding:
                                      EdgeInsets.fromLTRB(4.0, 6.0, 6.0, 4.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )))));
  }
}
