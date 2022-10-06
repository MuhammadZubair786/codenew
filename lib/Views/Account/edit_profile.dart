// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/edit_profile_controller.dart';
import 'package:lms_flutter_app/Views/Home/Course/all_course_view.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';
import 'package:loader_overlay/loader_overlay.dart';

// ignore: must_be_immutable
class EditProfile extends GetView<EditProfileController> {
  // ignore: non_constant_identifier_names
  double icon_size = 16.0;

  // ignore: non_constant_identifier_names
  double hint_font_size = 14.0;

  static GetStorage userToken = GetStorage();
  String tokenKey = "token";
  final EditProfileController editProfileController =
      Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(
          showSearch: false,
          goToSearch: false,
          showFilterBtn: false,
          showBack: false,
        ),
        body: LoaderOverlay(
          child: Obx(() {
            if (editProfileController.isLoading.value) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: InkWell(
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 50,
                            ),
                          ),
                          Text(
                            "دەسکاری پرۆفایل",
                            style: Get.textTheme.subtitle1,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            child: InkWell(
                              child: Icon(
                                Icons.search,
                                size: 20,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                editProfileController
                                    .dashboardController.persistentTabController
                                    .jumpToTab(0);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AllCourseView()));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                          child: FadeInImage(
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        image: editProfileController.selectedImagePath.value ==
                                ""
                            ? editProfileController.userImage.value == null
                                ? NetworkImage(
                                    "$rootUrl/public/demo/user/admin.jpg")
                                : editProfileController.userImage.value
                                        .contains('public/')
                                    ? NetworkImage(
                                        "$rootUrl/${editProfileController.userImage.value}")
                                    : NetworkImage(
                                        "${editProfileController.userImage.value}")
                            : FileImage(File(
                                editProfileController.selectedImagePath.value)),
                        placeholder: AssetImage('images/fcimg.png'),
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 111,
                        height: 32,
                        decoration: BoxDecoration(
                            color: Color(0xff303B58),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "وێنە هەڵبژێرە",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      onTap: () {
                        if (isDemo) {
                          CustomSnackBar().snackBarWarning("Disabled for demo");
                        } else {
                          editProfileController.getImage();
                        }
                      },
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 20, top: 30, right: 20),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "زانیاری سەرەتایی",
                          style: Get.textTheme.subtitle1,
                        )),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: TextField(
                        controller: editProfileController.ctFirstName,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, top: 3, bottom: 3, right: 15),
                          filled: true,
                          fillColor: Get.theme.canvasColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          hintText: "ناوی سیانی",
                          hintStyle: TextStyle(
                              color: Color(0xff8E99B7),
                              fontSize: hint_font_size),
                          suffixIcon: Icon(
                            Icons.person,
                            size: icon_size,
                            color: Color.fromRGBO(142, 153, 183, 0.5),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: TextField(
                        controller: editProfileController.ctEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, top: 3, bottom: 3, right: 15),
                          filled: true,
                          fillColor: Get.theme.canvasColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          hintText: "${stctrl.lang['Email']}",
                          hintStyle: TextStyle(
                              color: Color(0xff8E99B7),
                              fontSize: hint_font_size),
                          suffixIcon: Icon(
                            Icons.email,
                            size: icon_size,
                            color: Color.fromRGBO(142, 153, 183, 0.5),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: TextField(
                        controller: editProfileController.ctPhone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, top: 3, bottom: 3, right: 15),
                          filled: true,
                          fillColor: Get.theme.canvasColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          hintText: "ژمارەی تەلەفون",
                          hintStyle: TextStyle(
                              color: Color(0xff8E99B7),
                              fontSize: hint_font_size),
                          suffixIcon: Icon(
                            Icons.call,
                            size: icon_size,
                            color: Color.fromRGBO(142, 153, 183, 0.5),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: TextField(
                        controller: editProfileController.ctAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, top: 3, bottom: 3, right: 15),
                          filled: true,
                          fillColor: Get.theme.canvasColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          hintText: "ناونیشان",
                          hintStyle: TextStyle(
                              color: Color(0xff8E99B7),
                              fontSize: hint_font_size),
                          suffixIcon: Icon(
                            Icons.location_on_rounded,
                            size: icon_size,
                            color: Color.fromRGBO(142, 153, 183, 0.5),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: TextField(
                        controller: editProfileController.ctCountry,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, top: 3, bottom: 3, right: 15),
                          filled: true,
                          fillColor: Get.theme.canvasColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          hintText: "وڵات",
                          hintStyle: TextStyle(
                              color: Color(0xff8E99B7),
                              fontSize: hint_font_size),
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_down,
                            size: icon_size,
                            color: Color.fromRGBO(142, 153, 183, 0.5),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: TextField(
                        controller: editProfileController.ctCity,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, top: 3, bottom: 3, right: 15),
                          filled: true,
                          fillColor: Get.theme.canvasColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          hintText: "شار",
                          hintStyle: TextStyle(
                              color: Color(0xff8E99B7),
                              fontSize: hint_font_size),
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_down,
                            size: icon_size,
                            color: Color.fromRGBO(142, 153, 183, 0.5),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: TextField(
                        controller: editProfileController.ctZipCode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, top: 3, bottom: 3, right: 15),
                          filled: true,
                          fillColor: Get.theme.canvasColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          hintText: "زیب کۆد",
                          hintStyle: TextStyle(
                              color: Color(0xff8E99B7),
                              fontSize: hint_font_size),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 30, bottom: 20),
                        height: 46,
                        width: 185,
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "نوێکردنەوەی زانیاری",
                        ),
                      ),
                      onTap: () {
                        if (isDemo) {
                          CustomSnackBar().snackBarWarning("Disabled for demo");
                        } else {
                          editProfileController.updateProfile(context);
                        }
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 40),
                        child: Text(
                          "گەڕانەوە",
                          style: TextStyle(color: Color(0xff8E99B7)),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
