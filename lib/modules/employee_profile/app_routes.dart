import 'package:get/get.dart';
import 'binding.dart';
import './view/dashboard.dart';

final List<GetPage> appPages = [
  GetPage(
      name: '/greytrix/pockethrms/dashboard/',
      page: () => const DashboardView(),
      binding: DashboardBinding()),
];
