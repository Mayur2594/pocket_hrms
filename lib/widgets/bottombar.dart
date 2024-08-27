import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBarController extends GetxController {
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}

class BottomBarView extends StatelessWidget implements PreferredSizeWidget {
  final BottomBarController BottomBarCtrl = Get.put(BottomBarController());

  final String tabName;
  BottomBarView({
    Key? key,
    required this.tabName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF005C97),
            Color(0xFF363795),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 8, // Blur radius
            offset: Offset(0, 4), // Shadow offset
          ),
        ],
      ),
      child: Obx(() => BottomNavigationBar(
            currentIndex: BottomBarCtrl.currentIndex.value,
            onTap: (index) {
              BottomBarCtrl.changeTabIndex(index);
            },
            type: BottomNavigationBarType.fixed,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            unselectedItemColor: Colors.white54,
            selectedItemColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fingerprint_outlined),
                label: 'Attendance',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event_outlined),
                label: 'Calender',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          )),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
