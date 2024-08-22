import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/services/localization.dart';
import 'package:pocket_hrms/util/config.dart';
import 'package:pocket_hrms/mixins/shared_preferences_mixin.dart';

class AppBarController extends GetxController with SharedPreferencesMixin {
  var selectedLang = ''.obs;

  getsavedLanguage() async {
    selectedLang.value = (await getValue('LANGUAGE')) ?? 'English';
  }

  @override
  void onInit() {
    getsavedLanguage();
    super.onInit();
  }

  final Config config = Config();

  var languagesSet = [
    'English',
    'हिन्दी',
    'मराठी',
    'தமிழ்', // tamil
    'తెలుగు', // telugu
    'বাংলা', // bangla
    'ಕನ್ನಡ' // Kannada
  ];

  Future<void> changeLanguage(String newLanguage) async {
    LocalizationService().changeLocale(newLanguage);
    getsavedLanguage();
  }
}

// ignore: must_be_immutable
class AppBarView extends StatelessWidget
    with SharedPreferencesMixin
    implements PreferredSizeWidget {
  final AppBarController AppBarCtrl = Get.put(AppBarController());

  AppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Obx(() => Text(
              AppBarCtrl.config.pageTitle.value.tr.toString().toUpperCase(),
              style: const TextStyle(color: Colors.white),
            )),
        iconTheme: const IconThemeData(color: Colors.white),
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
        actions: <Widget>[
          PopupMenuButton<String>(
            icon:
                const Icon(Icons.translate), // The icon that triggers the menu
            onSelected: (String result) {},
            itemBuilder: (BuildContext context) =>
                AppBarCtrl.languagesSet.map((String item) {
              return PopupMenuItem<String>(
                onTap: () => {AppBarCtrl.changeLanguage(item)},
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    // ignore: unrelated_type_equality_checks
                    (item == AppBarCtrl.selectedLang.value)
                        ? const Icon(
                            Icons.check,
                            color: Colors.black,
                          )
                        : const SizedBox(width: 0),
                    const SizedBox(width: 4),
                    Text(item),
                  ],
                ),
              );
            }).toList(),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
