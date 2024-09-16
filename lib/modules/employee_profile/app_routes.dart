import 'package:get/get.dart';
import 'binding.dart';
import './view/dashboard.dart';
import './view/profile.dart';

final List<GetPage> appPages = [
  GetPage(
      name: '/greytrix/pockethrms/dashboard/',
      page: () => const DashboardView(),
      binding: DashboardBinding()),
  GetPage(
      name: '/greytrix/pockethrms/profile/',
      page: () => ProfileView(),
      binding: ProfileBinding()),
];
