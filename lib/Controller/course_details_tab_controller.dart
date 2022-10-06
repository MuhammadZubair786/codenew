// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';

class CourseDetailsTabController extends GetxController
    with GetTickerProviderStateMixin {
  var myTabs;

  TabController controller;

  @override
  void onInit() {
    super.onInit();
    myTabs = <Tab>[
      Tab(text: "وەسف"),
      Tab(text: "مەنهەج"),
      Tab(text: "پێداچونەوەکان"),
    ];
    controller =
        TabController(vsync: this, length: myTabs.length, initialIndex: 0);
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
