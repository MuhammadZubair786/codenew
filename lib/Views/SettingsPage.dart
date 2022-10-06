// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/edit_profile_controller.dart';
import 'package:lms_flutter_app/Views/Home/Course/all_course_view.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';

import '../Model/Settings/Languages.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final EditProfileController editProfileController =
      Get.put(EditProfileController());

  bool active = true;

  @override
  void didChangeDependencies() async {
    stctrl.getAllLanugages().then((value) {
      print(value);
      
      stctrl.languages.value = value.languages;
      stctrl.selectedLanguage.value =
          stctrl.languages.where((p0) => p0.code == stctrl.code.value).first;
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        appBar: AppBarWidget(
          showSearch: false,
          goToSearch: false,
          showFilterBtn: false,
          showBack: false,
        ),
        body: SingleChildScrollView(
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
                    // Text(
                    //   "${stctrl.lang["Settings"]}",
                    //   style: Get.textTheme.subtitle1,
                    // ),
                       Text(
                      "رێکخستنەکان",
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
                          Get.back();
                          // controller.changeTabIndex(0);
                          editProfileController
                              .dashboardController.persistentTabController
                              .jumpToTab(0);
                          Get.to(() => AllCourseView());
                        },
                      ),
                    ),
                  ],
                ),
              ),
              editProfileController.dashboardController.loggedIn.value
                  ? ListTile(
                      onTap: () async {
                        Get.bottomSheet(Obx(() {
                          return Material(
                            child: Container(
                              height: Get.height * 0.4,
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        // "${stctrl.lang["Change Language"]}",
                                        "گۆڕینی زمان",
                                        style: Get.textTheme.subtitle2,
                                        textAlign: TextAlign.center,
                                      )),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton(
                                          elevation: 1,
                                          isExpanded: true,
                                          underline: Container(),
                                          items: stctrl.languages.map((item) {
                                            return DropdownMenuItem<Language>(
                                              value: item,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                    item.native.toString()),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (Language value) {
                                            stctrl.selectedLanguage.value =
                                                value;
                                          },
                                          value: stctrl.selectedLanguage.value,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await stctrl.setLanguage(
                                          langCode: stctrl
                                              .selectedLanguage.value.code);
                                    },
                                    child: Text(
                                      "دڵنیاکردنەوە",
                                      style: Get.textTheme.subtitle2
                                          .copyWith(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }));
                      },
                      leading: Icon(Icons.language),
                      // title: Text("${stctrl.lang["Language"]}"),
                      title: Text("زمان"),
                    )
                  : SizedBox.shrink(),
              ListTile(
                onTap: () async {
                  final _url = privacyPolicyLink;
                  // ignore: deprecated_member_use
                  await canLaunch(_url)
                      // ignore: deprecated_member_use
                      ? await launch(_url)
                      : throw 'Could not launch $_url';
                },
                leading: Icon(Icons.vpn_key_outlined),
                // title: Text("${stctrl.lang["Privacy Policy"]}"),
                title:Text("سیاسەتی پاراستنی نهێنی")
              ),
              ListTile(
                onTap: () async {
                  final _url =
                      Platform.isIOS ? rateAppLinkiOS : rateAppLinkAndroid;
                  // ignore: deprecated_member_use
                  await canLaunch(_url)
                      // ignore: deprecated_member_use
                      ? await launch(_url)
                      : throw 'Could not launch $_url';
                },
                leading: Icon(Icons.star),
                // title: Text("${stctrl.lang["Rate our App"]}"),
                title: Text("ئەپەکەمان هەڵسەنگێنە"),

              ),
              ListTile(
                onTap: () async {
                  final _url = contactUsLink;
                  // ignore: deprecated_member_use
                  await canLaunch(_url)
                      // ignore: deprecated_member_use
                      ? await launch(_url)
                      : throw 'Could not launch $_url';
                },
                leading: Icon(Icons.mail),
                // title: Text("${stctrl.lang['Contact Us']}"),
                title: Text("پەیوەندی"),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
