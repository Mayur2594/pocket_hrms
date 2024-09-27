import 'package:get/get.dart';
import 'binding.dart';
import './view/dashboard.dart';
import './view/profile.dart';
import './view/attendance.dart';
import './view/calendar.dart';

final List<GetPage> appPages = [
  GetPage(
      name: '/greytrix/pockethrms/dashboard/',
      page: () => const DashboardView(),
      binding: DashboardBinding()),
  GetPage(
      name: '/greytrix/pockethrms/profile/',
      page: () => ProfileView(),
      binding: ProfileBinding()),
  GetPage(
      name: '/greytrix/pockethrms/attendance/',
      page: () => AttendanceView(),
      binding: AttendanceBinding()),
  GetPage(
      name: '/greytrix/pockethrms/calendar/',
      page: () => CalendarView(),
      binding: CalendarBinding()),
];
