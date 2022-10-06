// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';

class InstructorData extends StatefulWidget {
  const InstructorData({Key key}) : super(key: key);

  @override
  State<InstructorData> createState() => _InstructorDataState();
}

class _InstructorDataState extends State<InstructorData> {
  GetStorage userToken = GetStorage();

  String tokenKey = "token";

  double width;

  double percentageWidth;

  double height;

  double percentageHeight;

  bool isReview = false;

  bool isSignIn = true;

  bool playing = false;

  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    print(controller.courseDetails.value.user.name);
  }

  @override
  Widget build(BuildContext context) {}
}
