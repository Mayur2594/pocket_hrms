import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/services/localization.dart';
import 'package:pocket_hrms/util/config.dart';

// ignore: must_be_immutable
class AppBarView extends StatelessWidget implements PreferredSizeWidget {
  final Config config = Config();

  var selectedLang = 'English';
  var languagesSet = [
    'English',
    'हिन्दी',
    'मराठी',
    'தமிழ்', // tamil
    'తెలుగు', // telugu
    'বাংলা', // bangla
    'ಕನ್ನಡ' // Kannada
  ];

  void changeLanguage(String newLanguage) {
    selectedLang = newLanguage;
    print(newLanguage);
    LocalizationService().changeLocale(newLanguage);
  }

  AppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Obx(() => Text(
              config.pageTitle.value.tr.toString().toUpperCase(),
              style: const TextStyle(color: Colors.white),
            )),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 81, 255),
                Color.fromARGB(255, 48, 34, 255),
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
            onSelected: (String result) {
              // Handle the selected value
              print('Selected: $result');
            },
            itemBuilder: (BuildContext context) =>
                languagesSet.map((String item) {
              return PopupMenuItem<String>(
                onTap: () => {changeLanguage(item)},
                child: Row(
                  children: [
                    const SizedBox(width: 8),
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
