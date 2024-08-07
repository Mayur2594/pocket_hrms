import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/modules/authentication/controller/signin.dart';
import 'package:pocket_hrms/services/localization.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    final SigninController signinCtrl = Get.find();
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => Center(
            child: Row(
              children: [Text("Home".tr)],
            ),
          ),
        ));
  }
}
