import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBarController extends GetxController {
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

List<Map<dynamic, dynamic>> TabList = [
    {
      "title": "Home",
      "icon":  const Icon(Icons.home_outlined),
      "redirectUrl": "/greytrix/pockethrms/dashboard/"
    },
    {
      "title": "Attendance",
      "icon":  const Icon(Icons.fingerprint_outlined),
      "redirectUrl": "/greytrix/pockethrms/dashboard/"
    },
    {
      "title": "",
      "icon":  SizedBox.shrink(),
    },
    {
      "title": "Calender",
      "icon":  const Icon(Icons.event_outlined),
      "redirectUrl": "/greytrix/pockethrms/dashboard/"
    },
    {
      "title": "Profile",
      "icon":  const Icon(Icons.person),
      "redirectUrl": "/greytrix/pockethrms/profile/"
    }
];

  void changeTabIndex(int index) {
    currentIndex.value = index;
    Get.toNamed(TabList[currentIndex.value]["redirectUrl"]);
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
       clipBehavior: Clip.none,
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
      child: Stack(
        clipBehavior: Clip.none,
        children:[
            Obx(() => BottomNavigationBar(
              currentIndex: BottomBarCtrl.currentIndex.value,
              onTap: (index) {
                BottomBarCtrl.changeTabIndex(index);
              },
              type: BottomNavigationBarType.fixed,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              unselectedItemColor: Colors.white54,
              selectedItemColor: Colors.white,
              items: BottomBarCtrl.TabList.asMap().entries.map((item) {
                int index = item.key;
                var tabItem = item.value;
               return BottomNavigationBarItem(
                icon: tabItem['icon'], // Icon from TabList
                label: tabItem['title'], // Label from TabList
              );
          }).toList(),
            )),
      
             Positioned(
          top: -20, // Adjust this value to control how much the button floats
          left: MediaQuery.of(context).size.width / 2 - 30, // Align it in the center
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                   padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom, // Avoid overlap
                                ),
                  height: 500, // Height of BottomSheet
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the bottom sheet
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                        Scaffold(
                          appBar: 
                            AppBar(
                              elevation: 4,
                              title: Text('smHRty'),
                              leading: null,
                              actions: [
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                              flexibleSpace: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFF2F2F2),
                                        Color(0xFFEAEAEA),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                              ),
                              ),
                              body: SingleChildScrollView(
                                
                              ),
                          bottomNavigationBar: BottomAppBar(
                          child: Container(
                            // padding: EdgeInsets.only(
                            //       bottom: MediaQuery.of(context).viewInsets.bottom, // Avoid overlap
                            //     ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField( decoration: InputDecoration(border: OutlineInputBorder()),maxLines: 3,),
                                        flex: 11,
                                        ),
                                      Expanded(
                                        child:  IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {
                                   
                                  },
                                  alignment: Alignment.centerRight,
                                ),
                                        flex: 1,
                                        )
                                    ],
                                  ),
                          ),
                        ),
                        resizeToAvoidBottomInset: true, 
                        ),
                        Positioned(
                          top: -20, // Adjust this value to control how much the button floats
                          left: 10, // Align it in the center
                           child: GestureDetector( 
                              child: Container(
                              width: 60, // Button size
                              height: 60, 
                               decoration: BoxDecoration(
                               gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFF09819),
                                              Color(0xFFEDDE5D),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                              shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), // Shadow
                                    spreadRadius: 2,
                                    blurRadius: 1,
                                  ),
                                ],
                            ),
                          child:  Image.asset('lib/assets/images/smarty_light.png',
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  height: 15,
                                  ) 
                          ),
                      ),
                        ),
                    ],
                  )
                );
              },
            );
            },
            child: Container(
              width: 60, // Button size
              height: 60, 
              decoration: BoxDecoration(
                 gradient: LinearGradient(
                                colors: [
                                  Color(0xFFF09819),
                                  Color(0xFFEDDE5D),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2), // Shadow
                    spreadRadius: 8,
                    blurRadius: 1,
                  ),
                ],
              ),
              child:  Image.asset('lib/assets/images/smarty_light.png',
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      height: 15,
                      ) 
              //   Icons.camera_alt_outlined, // Camera icon
              //   color: Colors.white,
              //   size: 35,
              // ),
            ),
          ),
        ),
        ] 
            
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
