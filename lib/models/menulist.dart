import 'package:flutter/material.dart';

class ChildMenuItem {
  final String title;
  final IconData icon;
  final String route;
  final String tabs;

  ChildMenuItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.tabs,
  });
}

class MenuItem {
  final String title;
  final IconData icon;
  final String route;
  final List<ChildMenuItem>? subMenuItems; // Add this line

  MenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.subMenuItems, // Add this line
  });
}
