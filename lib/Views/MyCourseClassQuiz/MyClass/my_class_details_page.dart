// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lms_flutter_app/Controller/site_controller.dart';
import 'package:lms_flutter_app/Model/Class/BbbMeeting.dart';
import 'package:lms_flutter_app/Model/Class/JitsiMeeting.dart';
import 'package:lms_flutter_app/Model/Class/ZoomMeeting.dart';
import 'package:lms_flutter_app/utils/SliverAppBarTitleWidget.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';

import 'package:lms_flutter_app/Controller/class_controller.dart';
import 'package:lms_flutter_app/Controller/class_details_tab_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Service/RemoteService.dart';
import 'LiveClassProviders/BigBlueButtonClass.dart';
import 'LiveClassProviders/JitsiMeetClass.dart';
import 'package:lms_flutter_app/utils/CustomAlertBox.dart';
import 'package:lms_flutter_app/utils/CustomDate.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/styles.dart';
import 'package:lms_flutter_app/utils/widgets/StarCounterWidget.dart';
import 'LiveClassProviders/ZoomClass.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;

// ignore: must_be_immutable
class MyClassDetailsPage extends StatelessWidget {
  final SiteController _stctrl = Get.put(SiteController());
  final DashboardController dashboardController =
      Get.put(DashboardController());
  GetStorage userToken = GetStorage();

  String tokenKey = "token";

  double width;

  double percentageWidth;

  double height;

  double percentageHeight;

  bool isReview = false;

  bool isSignIn = true;

  bool playing = false;

  @override
  Widget build(BuildContext context) {
    final ClassController controller = Get.put(ClassController());

    final DashboardController dashboardController =
        Get.put(DashboardController());

    final ClassDetailsTabController _tabx =
        Get.put(ClassDetailsTabController());

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;

    return Scaffold(
      body: Obx(() {
        if (controller.isClassLoading.value)
          return Center(
            child: CupertinoActivityIndicator(),
          );
        return extend.NestedScrollView(
          // floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 280.0,
                automaticallyImplyLeading: false,
                titleSpacing: 20,
                title: SliverAppBarTitleWidget(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.classDetails.value
                                  .title['${_stctrl.code.value}'] ??
                              "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Get.textTheme.subtitle1,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        FadeInImage(
                          image: NetworkImage(
                              '$rootUrl/${controller.classDetails.value.image}'),
                          placeholder: AssetImage('images/fcimg.png'),
                          fit: BoxFit.cover,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 26),
                          color: Colors.black.withOpacity(0.7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_back_outlined,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "گەڕانەوە",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              courseDescriptionTitle(controller.classDetails
                                      .value.title['${_stctrl.code.value}'] ??
                                  ""),
                              courseDescriptionPublisher(
                                  controller.classDetails.value.user.name),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        StarCounterWidget(
                                          value: double.parse(controller
                                              .classDetails.value.review
                                              .toString()),
                                          color: Color(0xffFFCF23),
                                          size: 10,
                                        ),
                                        SizedBox(
                                          height: percentageHeight * 1,
                                        ),
                                        courseDescriptionPublisher('(' +
                                            controller.classDetails.value.review
                                                .toString() +
                                            ') ' +
                                            "لەسەر بنەمای" +
                                            ' ' +
                                            controller.classDetails.value
                                                .reviews.length
                                                .toString() +
                                            ' ' +
                                            "پێداچونەوە"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: percentageHeight * 1.5,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Get.theme.cardColor,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          color: Get.theme.primaryColor,
                                          size: 14,
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        courseStructure(CustomDate()
                                                .durationToString(int.parse(
                                                    controller
                                                        .classDetails
                                                        .value
                                                        .dataClass
                                                        .duration
                                                        .toString())) +
                                            ' Hr(s)'),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Get.theme.cardColor,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.insert_chart_sharp,
                                          color: Get.theme.primaryColor,
                                          size: 14,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        courseStructure(controller
                                                    .classDetails.value.level ==
                                                1
                                            ? "ئاستی سەرەتایی"
                                            : controller.classDetails.value
                                                        .level ==
                                                    2
                                                ? "ئاستی مام ناوەند"
                                                : controller.classDetails.value
                                                            .level ==
                                                        3
                                                    ? "ئاستی پێشکەوتوو"
                                                    : controller.classDetails
                                                                .value.level ==
                                                            4
                                                        ? "ئاستی پرۆ"
                                                        : ""),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Get.theme.cardColor,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.person_add_alt_1,
                                          color: Get.theme.primaryColor,
                                          size: 14,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        courseStructure(controller
                                            .classDetails.value.totalEnrolled
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          pinnedHeaderSliverHeightBuilder: () {
            return pinnedHeaderHeight;
          },
          body: Column(
            children: <Widget>[
              TabBar(
                labelColor: Colors.white,
                tabs: _tabx.myTabs,
                unselectedLabelColor: AppStyles.unSelectedTabTextColor,
                controller: _tabx.controller,
                indicator: Get.theme.tabBarTheme.indicator,
                automaticIndicatorColorAdjustment: true,
                isScrollable: false,
                labelStyle: Get.textTheme.subtitle2,
                unselectedLabelStyle: Get.textTheme.subtitle2,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabx.controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    scheduleWidget(controller, dashboardController),
                    instructorWidget(controller, dashboardController),
                    reviewWidget(controller, dashboardController),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget scheduleWidget(
      ClassController controller, DashboardController dashboardController) {
    return extend.NestedScrollViewInnerScrollPositionKeyWidget(
      const Key('Tab1'),
      Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: controller.classDetails.value.dataClass.host == 'Zoom'
              ? ListView.separated(
                  itemCount: controller
                      .classDetails.value.dataClass.zoomMeetings.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 5,
                    );
                  },
                  itemBuilder: (context, zoomIndex) {
                    ZoomMeeting zoomMeeting = controller
                        .classDetails.value.dataClass.zoomMeetings[zoomIndex];
                    bool showPlayBtn = false;
                    bool showLiveBtn = false;
                    int now = DateTime.now().millisecondsSinceEpoch;
                    if (now > zoomMeeting.startTime.millisecondsSinceEpoch &&
                        now < zoomMeeting.endTime.millisecondsSinceEpoch) {
                      showPlayBtn = true;
                      showLiveBtn = true;
                    } else if (now >
                        zoomMeeting.endTime.millisecondsSinceEpoch) {
                      showPlayBtn = false;
                      showLiveBtn = false;
                    } else if (now <
                        zoomMeeting.startTime.millisecondsSinceEpoch) {
                      showPlayBtn = true;
                      showLiveBtn = false;
                    }
                    return GestureDetector(
                      onTap: () async {
                        if (showLiveBtn) {
                          final _url = RemoteServices.getJoinMeetingUrlApp(
                              mid: zoomMeeting.meetingId);

                         // ignore: deprecated_member_use
                         if (await canLaunch(_url)) {
                            // ignore: deprecated_member_use
                            await launch(_url);
                          } else {
                            Get.to(() => ZoomLaunchMeeting(
                                  meetingUrl:
                                      RemoteServices.getJoinMeetingUrlWeb(
                                          mid: zoomMeeting.meetingId),
                                  meetingName: zoomMeeting.topic,
                                ));
                          }
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            color: showPlayBtn
                                ? showLiveBtn
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.blue.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                cartTotal("رۆژی دەستپێکردن"),
                                courseStructure(
                                  CustomDate().formattedDate(controller
                                      .classDetails
                                      .value
                                      .dataClass
                                      .zoomMeetings[zoomIndex]
                                      .startTime),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                cartTotal("کات (دەستپێکردن - کۆتایی)"),
                                courseStructure(
                                  '${CustomDate().formattedHourOnly(controller.classDetails.value.dataClass.zoomMeetings[zoomIndex].startTime)} - ${CustomDate().formattedHourOnly(controller.classDetails.value.dataClass.zoomMeetings[zoomIndex].endTime)}',
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                cartTotal("ماوە"),
                                courseStructure(
                                  CustomDate().durationToString(int.parse(
                                          controller
                                              .classDetails
                                              .value
                                              .dataClass
                                              .zoomMeetings[zoomIndex]
                                              .meetingDuration)) +
                                      ' Hr(s)',
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            showPlayBtn
                                ? showLiveBtn
                                    ? Icon(FontAwesomeIcons.solidPlayCircle)
                                    : Icon(FontAwesomeIcons.solidPauseCircle)
                                : Icon(FontAwesomeIcons.solidStopCircle),
                          ],
                        ),
                      ),
                    );
                  })
              : controller.classDetails.value.dataClass.host == 'Jitsi'
                  ? ListView.builder(
                      itemCount: controller
                          .classDetails.value.dataClass.jitsiMeetings.length,
                      itemBuilder: (context, jitsiIndex) {
                        JitsiMeeting jitsiMeeting = controller.classDetails
                            .value.dataClass.jitsiMeetings[jitsiIndex];

                        bool showPlayBtn = false;
                        bool showLiveBtn = false;
                        DateTime startDate =
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(jitsiMeeting.datetime) * 1000);
                        DateTime endDate = DateTime.fromMillisecondsSinceEpoch(
                            (int.parse(jitsiMeeting.datetime) +
                                    (jitsiMeeting.duration * 60)) *
                                1000);
                        int now = DateTime.now().millisecondsSinceEpoch;
                        if (now > startDate.millisecondsSinceEpoch &&
                            now < endDate.millisecondsSinceEpoch) {
                          showPlayBtn = true;
                          showLiveBtn = true;
                        } else if (now > endDate.millisecondsSinceEpoch) {
                          showPlayBtn = false;
                          showLiveBtn = false;
                        } else if (now < startDate.millisecondsSinceEpoch) {
                          showPlayBtn = true;
                          showLiveBtn = false;
                        }
                        return GestureDetector(
                          onTap: () {
                            if (showLiveBtn) {
                              Get.to(() => JitsiMeetClass(
                                    meetingId: jitsiMeeting.meetingId,
                                    meetingSubject: jitsiMeeting.topic,
                                    userEmail:
                                        dashboardController.profileData.email,
                                    userName:
                                        dashboardController.profileData.name,
                                  ));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: showPlayBtn
                                    ? showLiveBtn
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.blue.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    cartTotal("رۆژی دەستپێکردن"),
                                    courseStructure(
                                      CustomDate().formattedDate(startDate),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    cartTotal(
                                        "کات (دەستپێکردن - کۆتایی)"),
                                    courseStructure(
                                      '${CustomDate().formattedHourOnly(startDate)} - ${CustomDate().formattedHourOnly(endDate)}',
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    cartTotal("ماوە"),
                                    courseStructure(
                                      CustomDate().durationToString(controller
                                              .classDetails
                                              .value
                                              .dataClass
                                              .jitsiMeetings[jitsiIndex]
                                              .duration) +
                                          ' Hr(s)',
                                    ),
                                  ],
                                ),
                                Expanded(child: Container()),
                                showPlayBtn
                                    ? showLiveBtn
                                        ? Icon(FontAwesomeIcons.solidPlayCircle)
                                        : Icon(
                                            FontAwesomeIcons.solidPauseCircle)
                                    : Icon(FontAwesomeIcons.solidStopCircle),
                              ],
                            ),
                          ),
                        );
                      })
                  : controller.classDetails.value.dataClass.host == 'BBB'
                      ? ListView.builder(
                          itemCount: controller
                              .classDetails.value.dataClass.bbbMeetings.length,
                          itemBuilder: (context, bbbIndex) {
                            BbbMeeting bbbMeeting = controller.classDetails
                                .value.dataClass.bbbMeetings[bbbIndex];

                            bool showPlayBtn = false;
                            bool showLiveBtn = false;
                            DateTime startDate =
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(bbbMeeting.datetime) * 1000);
                            DateTime endDate =
                                DateTime.fromMillisecondsSinceEpoch(
                                    (int.parse(bbbMeeting.datetime) +
                                            (bbbMeeting.duration * 60)) *
                                        1000);
                            int now = DateTime.now().millisecondsSinceEpoch;
                            if (now > startDate.millisecondsSinceEpoch &&
                                now < endDate.millisecondsSinceEpoch) {
                              showPlayBtn = true;
                              showLiveBtn = true;
                            } else if (now > endDate.millisecondsSinceEpoch) {
                              showPlayBtn = false;
                              showLiveBtn = false;
                            } else if (now < startDate.millisecondsSinceEpoch) {
                              showPlayBtn = true;
                              showLiveBtn = false;
                            }

                            return GestureDetector(
                              onTap: () async {
                                if (showLiveBtn) {
                                  String token = await userToken.read(tokenKey);

                                  Uri topCatUrl = Uri.parse(baseUrl +
                                      '/get-bbb-start-url/${bbbMeeting.meetingId}/${dashboardController.profileData.name}');

                                  var response = await http.get(
                                    topCatUrl,
                                    headers: {
                                      'Content-Type': 'application/json',
                                      'Accept': 'application/json',
                                      '$authHeader': '$isBearer' + '$token',
                                    },
                                  );
                                  if (response.statusCode == 200) {
                                    var jsonString = jsonDecode(response.body);


                                    if (jsonString['status'] == 'running') {

                                      final _url = jsonString['url'];
                                      Get.to(() => BigBlueButtonTest(
                                            meetingUrl: _url,
                                            meetingName: bbbMeeting.topic,
                                          ));
                                    } else {
                                      Get.snackbar(
                                        "چاوەرێ بکە",
                                        "The Live Class haven\'t started yet",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.deepOrange,
                                        colorText: Colors.white,
                                      );
                                    }
                                  } else {
                                    Get.snackbar(
                                      "هەڵە",
                                      "ناتوانرێت لایڤەکە دەستپێبکرێت",
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: showPlayBtn
                                        ? showLiveBtn
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.blue.withOpacity(0.2)
                                        : Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        cartTotal(
                                            "رۆژی دەستپێکردن"),
                                        courseStructure(
                                          CustomDate().formattedDate(startDate),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        cartTotal(
                                            "کات (دەستپێکردن - کۆتایی)"),
                                        courseStructure(
                                          '${CustomDate().formattedHourOnly(startDate)} - ${CustomDate().formattedHourOnly(endDate)}',
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        cartTotal("ماوە"),
                                        courseStructure(
                                          CustomDate().durationToString(
                                                  controller
                                                      .classDetails
                                                      .value
                                                      .dataClass
                                                      .bbbMeetings[bbbIndex]
                                                      .duration) +
                                              ' Hr(s)',
                                        ),
                                      ],
                                    ),
                                    Expanded(child: Container()),
                                    showPlayBtn
                                        ? showLiveBtn
                                            ? Icon(FontAwesomeIcons
                                                .solidPlayCircle)
                                            : Icon(FontAwesomeIcons
                                                .solidPauseCircle)
                                        : Icon(
                                            FontAwesomeIcons.solidStopCircle),
                                  ],
                                ),
                              ),
                            );
                          })
                      : Container(),
        ),
      ),
    );
  }

  Widget instructorWidget(
      ClassController controller, DashboardController dashboardController) {
    return extend.NestedScrollViewInnerScrollPositionKeyWidget(
      const Key('Tab1'),
      Scaffold(
        body: Container(
          width: percentageWidth * 100,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundColor: Color(0xFFD7598F),
                backgroundImage: controller.classDetails.value.user.avatar
                        .contains('public/')
                    ? NetworkImage(
                        rootUrl +
                            '/' +
                            controller.classDetails.value.user.avatar,
                      )
                    : NetworkImage(
                        controller.classDetails.value.user.avatar,
                      ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    cartTotal(
                        '${controller.classDetails.value.user.firstName} ${controller.classDetails.value.user.lastName}'),
                    courseStructure(
                      controller.classDetails.value.user.headline,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    StarCounterWidget(
                      value: controller.classDetails.value.user.totalRating
                          .toDouble(),
                      color: Color(0xffFFCF23),
                      size: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    courseStructure(
                      controller.classDetails.value.user.shortDetails,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget reviewWidget(
      ClassController controller, DashboardController dashboardController) {
    return extend.NestedScrollViewInnerScrollPositionKeyWidget(
        const Key('Tab4'),
        ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            SizedBox(height: 10),
            GestureDetector(
              child: Container(
                width: percentageWidth * 100,
                height: percentageHeight * 6,
                padding: EdgeInsets.fromLTRB(20, 0, 30, 0),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Get.theme.cardColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cartTotal("کۆرسەکە هەلسەنگێنە"),
                    Icon(
                      Icons.add,
                      color: Get.theme.primaryColor,
                      size: 15,
                    )
                  ],
                ),
              ),
              onTap: () {
                var myRating = 5.0;
                controller.reviewText.clear();
                userToken.read(tokenKey) != null
                    ? Get.bottomSheet(SingleChildScrollView(
                        child: Container(
                          width: percentageWidth * 100,
                          height: percentageHeight * 54.68,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
                              decoration: BoxDecoration(
                                color: Get.theme.cardColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(30),
                                    topRight: const Radius.circular(30)),
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Container(
                                        width: percentageWidth * 18.66,
                                        height: percentageHeight * 1,
                                        decoration: BoxDecoration(
                                            color: Color(0xffE5E5E5),
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(4.5)),
                                        // color: Color(0xffE5E5E5),
                                      ),
                                      onTap: () {
                                        Get.back();
                                      },
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Center(
                                      child: Text(
                                        "کۆرسەکە هەلسەنگێنە",
                                        style: Get.textTheme.subtitle1
                                            .copyWith(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Center(
                                      child: Text(
                                        "لایڤەکە هەلسەنگێنە",
                                        style: Get.textTheme.subtitle2,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: RatingBar.builder(
                                        itemSize: 30,
                                        initialRating: myRating,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          myRating = rating;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: percentageWidth * 100,
                                      height: percentageHeight * 12.19,
                                      decoration: BoxDecoration(
                                        color: Get.theme.cardColor,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              height: percentageHeight * 6.19,
                                              width: percentageWidth * 12,
                                              child: ClipOval(
                                                child: FadeInImage(
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                  width: 40,
                                                  image: dashboardController
                                                          .profileData.image
                                                          .contains('public/')
                                                      ? NetworkImage(rootUrl +
                                                              "/" +
                                                              dashboardController
                                                                  .profileData
                                                                  .image ??
                                                          "")
                                                      : NetworkImage(
                                                          dashboardController
                                                                  .profileData
                                                                  .image ??
                                                              ""),
                                                  placeholder: AssetImage(
                                                      'images/fcimg.png'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: percentageWidth * 2,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: percentageHeight * 12.19,
                                              width: percentageWidth * 75.22,
                                              decoration: BoxDecoration(
                                                color: Color(0xffF2F6FF),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: TextField(
                                                maxLines: 6,
                                                controller:
                                                    controller.reviewText,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                    left: 10,
                                                    top: 10,
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      Get.theme.canvasColor,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                        color: Color.fromRGBO(
                                                            142, 153, 183, 0.4),
                                                        width: 1.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                        color: Color.fromRGBO(
                                                            142, 153, 183, 0.4),
                                                        width: 1.0),
                                                  ),
                                                  hintText:
                                                      "پێداچونەوەی تۆ",
                                                  hintStyle:
                                                      Get.textTheme.subtitle2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.submitCourseReview(
                                            controller.classDetails.value.id,
                                            controller.reviewText.value.text,
                                            myRating);
                                      },
                                      child: Container(
                                        width: percentageWidth * 50,
                                        height: percentageHeight * 5,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Get.theme.primaryColor,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          "پێداچونەوەکەت بنێرە",
                                          style: Get.textTheme.subtitle2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ])),
                        ),
                      ))
                    : showLoginAlertDialog(
                        "داخڵ بوون",
                        "هێشتا داخلی هەژمار نەبویت",
                        "داخڵ بوون");
                Container();
              },
            ),
            controller.classDetails.value.reviews.length == 0
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(
                      "هیچ پێداچونەوەیەک نەدۆزرایەوە",
                      style: Get.textTheme.subtitle2,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.classDetails.value.reviews.length,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: percentageWidth * 100,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Get.theme.cardColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Color(0xFFD7598F),
                                  backgroundImage: controller.classDetails.value
                                          .reviews[index].userImage
                                          .contains('public/')
                                      ? NetworkImage(
                                          rootUrl +
                                              '/' +
                                              controller.classDetails.value
                                                  .reviews[index].userImage,
                                        )
                                      : NetworkImage(
                                          controller.classDetails.value
                                              .reviews[index].userImage,
                                        ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            cartTotal(controller.classDetails
                                                .value.reviews[index].userName),
                                            Expanded(
                                              child: Container(),
                                            ),
                                            StarCounterWidget(
                                              value: controller.classDetails
                                                  .value.reviews[index].star
                                                  .toDouble(),
                                              color: Color(0xffFFCF23),
                                              size: 10,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 0),
                                          child: courseStructure(controller
                                              .classDetails
                                              .value
                                              .reviews[index]
                                              .comment),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    })
          ],
        ));
  }
}
