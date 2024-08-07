import 'package:get/get.dart';
import 'package:pocket_hrms/modules/authentication/index.dart'
    as authentication;
import 'package:pocket_hrms/modules/employee_profile/index.dart'
    as employee_profile;
import 'package:pocket_hrms/modules/expense/index.dart' as expense;
import 'package:pocket_hrms/modules/help_desk/index.dart' as help_desk;
import 'package:pocket_hrms/modules/hire/index.dart' as hire;
import 'package:pocket_hrms/modules/leave/index.dart' as leave;
import 'package:pocket_hrms/modules/project_management/index.dart'
    as project_management;
import 'package:pocket_hrms/modules/timesheet/index.dart' as timesheet;
import 'package:pocket_hrms/modules/training/index.dart' as training;
import 'package:pocket_hrms/modules/travel/index.dart' as travel;

final List<GetPage> appPages = [...authentication.appPages];
