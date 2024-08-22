import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/models/menulist.dart';
import 'package:pocket_hrms/util/config.dart';
import 'package:pocket_hrms/mixins/shared_preferences_mixin.dart';

class AppDrawerController extends GetxController with SharedPreferencesMixin {
  @override
  void onInit() {
    super.onInit();
  }

  final List<MenuItem> drawerMenuItems = [
    MenuItem(
      title: "Home".tr,
      icon: Icons.home,
      route: '/greytrix/pockethrms/dashboard/',
    ),
    MenuItem(
      title: "Home".tr,
      icon: Icons.home,
      route: '/greytrix/pockethrms/dashboard/',
    ),
    MenuItem(
      title: "Home".tr,
      icon: Icons.home,
      route: '/greytrix/pockethrms/dashboard/',
    ),
    MenuItem(
        title: "Home".tr,
        icon: Icons.home,
        route: '/greytrix/pockethrms/dashboard/',
        subMenuItems: [
          ChildMenuItem(
              title: 'Attendance Records',
              route: '/attenednace',
              icon: Icons.donut_large,
              tabs: ""),
          ChildMenuItem(
              title: 'Att. Regularisation',
              route: '/attenednace-regularisation',
              icon: Icons.donut_large,
              tabs: ""),
        ]),
  ];

  final Config config = Config();

  void _onItemTapped(MenuItem menuitem) {
    Config().setPageTitle(menuitem.title);
    Get.toNamed(menuitem.route);
  }

  void _onItemTappedSubmenu(ChildMenuItem menuitem) {
    Config().setPageTitle(menuitem.title);
    Get.toNamed(menuitem.route);
  }
}

class DrawerView extends StatelessWidget
    with SharedPreferencesMixin
    implements PreferredSizeWidget {
  final AppDrawerController AppDrawerCtrl = Get.put(AppDrawerController());

  DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Image(
                  image: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8kjNASp-t4VymZrnRo9hIMRSeTcWNarxbJw&s'),
                  alignment: Alignment.topLeft,
                )),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "My companyname pvt ltd.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
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
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ...AppDrawerCtrl.drawerMenuItems.map((menuItem) {
                    if (menuItem.subMenuItems == null ||
                        menuItem.subMenuItems!.isEmpty) {
                      return ListTile(
                        leading: Icon(
                          menuItem.icon,
                          color: Colors.white,
                        ),
                        title: Text(
                          menuItem.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        // subtitle: Text(menuItem.description),
                        onTap: () {
                          Navigator.pop(context); // Close the drawer
                          AppDrawerCtrl._onItemTapped(menuItem);
                        },
                      );
                    } else {
                      return ExpansionTile(
                        leading: Icon(menuItem.icon, color: Colors.white),
                        title: Text(
                          menuItem.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        collapsedIconColor: Colors.white,
                        iconColor: Colors.white,
                        children: menuItem.subMenuItems!.map((subMenuItem) {
                          return ListTile(
                            contentPadding: EdgeInsets.fromLTRB(24, 0, 0, 0),
                            leading: Icon(
                              subMenuItem.icon,
                              color: Colors.white,
                              size: 16,
                            ),
                            title: Text(
                              subMenuItem.title,
                              style: const TextStyle(color: Colors.white),
                            ),
                            // subtitle: Text(subMenuItem.description),
                            onTap: () {
                              Navigator.pop(context);
                              AppDrawerCtrl._onItemTappedSubmenu(subMenuItem);
                            },
                          );
                        }).toList(),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info, color: Colors.black54),
            title: Text(
              'v0.0.1',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
