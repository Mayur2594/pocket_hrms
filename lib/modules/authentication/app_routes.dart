import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'binding.dart';
import './view/signin.dart';

final List<GetPage> appPages = [
  GetPage(name: '/', page: () => const SigninView(), binding: SigninBinding()),
];
