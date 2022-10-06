// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';

class MyQuizDetailsTabController extends GetxController
    with GetTickerProviderStateMixin {
  var myTabs;

  TabController controller;

  @override
  void onInit() {
    super.onInit();
    myTabs = <Tab>[
      Tab(text: "رێنمایی"),
      Tab(text: "ئەنجام"),
      Tab(text: "پرسیار/وەڵام"),
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
