import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/modules/employee_profile/controller/attendance.dart';
import 'package:pocket_hrms/widgets/appbar.dart';
import 'package:pocket_hrms/widgets/appdrawer.dart';
import 'package:pocket_hrms/widgets/bottombar.dart';


class AttendanceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final AttendanceController AttendanceCtrl = Get.find();
    return Scaffold(
      appBar: AppBarView(appBarTitle: "Attendance"),
      drawer: DrawerView(),
      body: RefreshIndicator(
         onRefresh: () => AttendanceCtrl.refreshView(),
          child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(4.0),
                child:Obx(() => Column(
                  children: [
                  ...List.generate(AttendanceCtrl.AttendanceList.length, (index) {
                    return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                         ListTile(
                          leading: Column( children: [
                            CircleAvatar(backgroundColor: Colors.blueGrey.shade200, child: Text("${AttendanceCtrl.AttendanceList[index]["attDate"]}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),),),
                           Text(AttendanceCtrl.AttendanceList[index]["attmonth"], style: TextStyle(fontWeight: FontWeight.bold),)
                          ],),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                             Expanded(
      flex: 4, // Adjust flex values to balance text and icon space
      child: Text(
        "In Time: ${AttendanceCtrl.AttendanceList[index]["intime"]}",
        maxLines: 1, // Ensures text stays on one line
        overflow: TextOverflow.ellipsis, // Shows "..." if text is too long
        softWrap: false, // Prevents wrapping
      ),
    ),
    // Expanded for "Out Time"
    Expanded(
      flex: 4, // Adjust flex values to balance text and icon space
      child: Text(
        "Out Time: ${AttendanceCtrl.AttendanceList[index]["outtime"]}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis, // Shows "..." if text is too long
        softWrap: false,
      ),
    ),
    // Icon
    Expanded(
      flex: 1, // Adjust flex to allocate space for the icon
      child: Align(child: Icon(Icons.edit, color: Colors.grey,), alignment: Alignment.centerRight,),
    ),
                            ],),
                          // subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                        ),
                      ],
                    ),
                  );
                  }),
                  ],
               ),
        ),
      )          )
          
      ),
       bottomNavigationBar: BottomBarView(tabName: 'dashboard'),
    );
  }

  


}