import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pocket_hrms/modules/employee_profile/controller/dashboard.dart';
import 'package:pocket_hrms/widgets/appbar.dart';
import 'package:pocket_hrms/widgets/appdrawer.dart';
import 'package:pocket_hrms/widgets/bottombar.dart';

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
              Card.outlined(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Edge-to-edge
                ),
                elevation: 10.0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    child: Obx(
                      () => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            textDirection: TextDirection.ltr,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                  child: CircleAvatar(
                                    radius: 75,
                                    backgroundColor: Colors.black26,
                                    child: ClipOval(
                                      child: Image.network(
                                        DashboardCtrl.profilePic.value,
                                        width:
                                            130, // Match the diameter (2 * radius)
                                        height:
                                            130, // Match the diameter (2 * radius)
                                        fit: BoxFit
                                            .cover, // Ensures the image covers the entire area
                                      ),

                                      // CachedNetworkImage(
                                      //   imageUrl: DashboardCtrl.profilePic.value,
                                      //   placeholder: (context, url) =>
                                      //       const CircularProgressIndicator(),
                                      //   errorWidget: (context, url, error) =>
                                      //       const Icon(Icons.error),
                                      //   width: 150.0,
                                      //   height: 150.0,
                                      //   fit: BoxFit.cover,
                                      // ),
                                    ),
                                    // backgroundImage: NetworkImage(
                                    //     ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 8,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "MAYUR MHATRE",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          "GT0404",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 16),
                                        ),
                                        Text(
                                          "IP - Cloud - SOFTWARE ENGINEER ",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.facebook_rounded,
                                              color: Colors.grey,
                                              size: 28,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                          Divider(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 42,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF005C97),
                                      Color(0xFF363795),
                                    ], // Customize your gradient colors
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      8), // Match the button's border radius
                                ),
                                child: ElevatedButton(
                                  onPressed: () => {DashboardCtrl.goToPunch()},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .transparent, // Make the button background transparent
                                    shadowColor: Colors
                                        .transparent, // Remove the button's shadow if needed
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8), // Match the container's border radius
                                    ),
                                  ),
                                  child: Text(
                                    "Punch-In".tr,
                                    style: TextStyle(color: Colors.white60),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Container(
                                height: 42,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFECE9E6),
                                      Color(0xFFFFFFFF),
                                    ], // Customize your gradient colors
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      8), // Match the button's border radius
                                ),
                                child: ElevatedButton(
                                  onPressed: () => {DashboardCtrl.goToPunch()},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .transparent, // Make the button background transparent
                                    shadowColor: Colors
                                        .transparent, // Remove the button's shadow if needed
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8), // Match the container's border radius
                                    ),
                                  ),
                                  child: Text(
                                    "Punch-Out".tr,
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 42,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF005C97),
                                  Color(0xFF363795),
                                ], // Customize your gradient colors
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(
                                  8), // Match the button's border radius
                            ),
                            child: ElevatedButton(
                              onPressed: null, // Your onPressed logic here
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .transparent, // Make the button background transparent
                                shadowColor: Colors
                                    .transparent, // Remove the button's shadow if needed
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Match the container's border radius
                                ),
                              ),
                              child: Text(
                                "View Manager(s) Details".tr,
                                style: TextStyle(color: Colors.white60),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Card.outlined(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // Edge-to-edge
                  ),
                  elevation: 10.0,
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Container(
                          child: Column(
                        children: [
                          Container(
                            child: Text("Attendance Statistics"),
                          ),
                          Divider(),
                          Container(
                              padding: EdgeInsets.all(4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Tomorrow's Shift".tr + ":",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "GENERAL SHIFT (09:30-18:30)".tr,
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ],
                              )),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    Text("Today's Last Punch".tr,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 18)),
                                    Text("Unswiped",
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    Text("Today's Punch".tr,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 18)),
                                    Text("Unswiped",
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ))))
            ],
          ))),
      bottomNavigationBar: BottomBarView(tabName: 'dashboard'),
    );
  }
}


// Column(
//             children: [
//               Container(
//                   padding: const EdgeInsets.all(8.0), child: Text("Home".tr)),
//               ElevatedButton(
//                   onPressed: () => {DashboardCtrl.goToPunch()},
//                   child: const Text("Punch")),
//               const SizedBox(
//                 height: 10,
//               ),
//               ElevatedButton(
//                   onPressed: () => {DashboardCtrl.allowBackgroundPermission()},
//                   child: const Text("Allow Location Prmission")),
//               const SizedBox(
//                 height: 10,
//               ),
//               ElevatedButton(
//                   onPressed: () => {
//                         DashboardCtrl.startBackgroundService(
//                             'gpsTrackingFromTrip')
//                       },
//                   child: const Text("Start Service for trip")),
//               const SizedBox(
//                 height: 10,
//               ),
//               ElevatedButton(
//                   onPressed: () => {
//                         DashboardCtrl.startBackgroundService(
//                             'gpsTrackingFromGeoTracking')
//                       },
//                   child: const Text("Start Service fro tracking")),
//               const SizedBox(
//                 height: 10,
//               ),
//               ElevatedButton(
//                   onPressed: () => {DashboardCtrl.stopBackgroundService()},
//                   child: const Text("Stop Service"))
//             ],
//           )