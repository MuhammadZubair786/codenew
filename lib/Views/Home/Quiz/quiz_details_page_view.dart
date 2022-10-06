// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/cart_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/quiz_controller.dart';
import 'package:lms_flutter_app/Controller/quiz_details_tab_controller.dart';
import 'package:lms_flutter_app/Controller/site_controller.dart';
import 'package:lms_flutter_app/utils/CustomAlertBox.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/SliverAppBarTitleWidget.dart';
import 'package:lms_flutter_app/utils/styles.dart';
import 'package:lms_flutter_app/utils/widgets/StarCounterWidget.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;

// ignore: must_be_immutable
class QuizDetailsPageView extends StatelessWidget {
  final SiteController _stctrl = Get.put(SiteController());
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
 var width =  MediaQuery.of(context).size.width*0.90;

    final QuizController controller = Get.put(QuizController());

    final DashboardController dashboardController =
        Get.put(DashboardController());

    final QuizDetailsTabController _tabx = Get.put(QuizDetailsTabController());

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;

    return Scaffold(
      body: Obx(() {
        if (controller.isQuizLoading.value)
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
                          controller.quizDetails.value
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
                  centerTitle: true,
                  background: Container(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        FadeInImage(
                          image: NetworkImage(
                              '$rootUrl/${controller.quizDetails.value.image}'),
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
                              courseDescriptionTitle(controller.quizDetails
                                      .value.title['${_stctrl.code.value}'] ??
                                  ""),
                              courseDescriptionPublisher(
                                  controller.quizDetails.value.user.name),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        StarCounterWidget(
                                          value: double.parse(controller
                                              .quizDetails.value.review
                                              .toString()),
                                          color: Color(0xffFFCF23),
                                          size: 10,
                                        ),
                                        SizedBox(
                                          height: percentageHeight * 1,
                                        ),
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
                                          color: Color(0xFFfb4611),
                                          size: 14,
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        controller.quizDetails.value.quiz
                                                    .questionTimeType ==
                                                0
                                            ? courseStructure(controller
                                                    .quizDetails
                                                    .value
                                                    .quiz
                                                    .questionTime
                                                    .toString() +
                                                " min/Q")
                                            : courseStructure(controller
                                                    .quizDetails
                                                    .value
                                                    .quiz
                                                    .questionTime
                                                    .toString() +
                                                " Min"),
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
                                          color:Color(0xFFfb4611),
                                          size: 14,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        courseStructure(controller
                                                    .quizDetails.value.level ==
                                                1
                                            ? "ئاستی سەرەتایی"
                                            : controller.quizDetails.value
                                                        .level ==
                                                    2
                                                ? "ئاستی مام ناوەند"
                                                : controller.quizDetails.value
                                                            .level ==
                                                        3
                                                    ? "ئاستی پێشکەوتوو"
                                                    : controller.quizDetails
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
                                          color:Color(0xFFfb4611),
                                          size: 14,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        courseStructure(controller
                                            .quizDetails.value.totalEnrolled
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
                indicatorColor: Color(0xFFfb4611),
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
                    quizDetailsWidget(controller, dashboardController),
                    questionAnswerWidget(controller, dashboardController),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget quizDetailsWidget(
      QuizController controller, DashboardController dashboardController) {
    final CartController cartController = Get.put(CartController());
    Future<String> addToCart(String courseID) async {
      Uri addToCartUrl = Uri.parse(baseUrl + '/add-to-cart/$courseID');
      var token = userToken.read(tokenKey);
      var response = await http.get(
        addToCartUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          '$authHeader': '$isBearer' + '$token',
        },
      );
      if (response.statusCode == 200) {
        var jsonString = jsonDecode(response.body);
        var message = jsonEncode(jsonString['message']);
        showCustomAlertDialog(
            "حاڵەت", message, "تەماشای کارتەکەت بکە");
        cartController.getCartList();
        controller.courseID.value = controller.quizDetails.value.id;
        controller.getQuizDetails();
        Get.back();
        return message;
      } else {
        //show error message
        return "Somthing Wrong";
      }
    }

    return extend.NestedScrollViewInnerScrollPositionKeyWidget(
      const Key('Tab1'),
      Scaffold(
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            Text(
              "رێنمایی" + ": ",
              style: Get.textTheme.subtitle1,
            ),
            Container(
              width: percentageWidth * 100,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: HtmlWidget(
                '''
                ${controller.quizDetails.value.quiz.instruction['${stctrl.code.value}'] ?? "${controller.quizDetails.value.quiz.instruction['en']}"}
                 ''',
                textStyle: Get.textTheme.subtitle2,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "کاتی کویز" + ":",
              style: Get.textTheme.subtitle1,
            ),
            SizedBox(
              height: 10,
            ),
            controller.quizDetails.value.quiz.questionTimeType == 0
                ? Text(
                    "${controller.quizDetails.value.quiz.questionTime} " +
                        "دەقە بۆ هەر پرسیارێک",
                    style: Get.textTheme.subtitle2,
                  )
                : Text(
                    "${controller.quizDetails.value.quiz.questionTime} " +
                        "دەقە",
                    style: Get.textTheme.subtitle2,
                  ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: dashboardController.loggedIn.value
            ? controller.isQuizBought.value
                ? Container()
                : controller.cartAdded.value
                    ? ElevatedButton(
                        child: Text(
                          "تەماشای کارتەکەت بکە",
                          style: Get.textTheme.subtitle2
                              .copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Get.back();
                          dashboardController.changeTabIndex(1);
                        },
                      )
                    : ElevatedButton(
                        child: Text(
                          "لە کویزەکە بەشدار بە",
                          style: Get.textTheme.subtitle2
                              .copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        style: Get.theme.elevatedButtonTheme.style,
                        onPressed: () {
                          dashboardController.loggedIn.value
                              ? addToCart(
                                  controller.quizDetails.value.id.toString())
                              : showCustomAlertDialog(
                                  "داخڵ بوون",
                                  "هێشتا داخلی هەژمار نەبویت",
                                  "تەماشای کارتەکەت بکە",
                                );
                        },
                      )
            : Container(
              width: 350,
              child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                    dashboardController.changeTabIndex(1);
                  },
                  style: ElevatedButton.styleFrom(primary: Color(0xFFfb4611)),
                  child: Text(
                    "هەمووی بەدەست بێنە",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffffffff),
                        height: 1.3,
                        fontFamily: 'AvenirNext'),
                    textAlign: TextAlign.center,
                  ),
                ),
            ),
      ),
    );
  }

  Widget questionAnswerWidget(
      QuizController controller, DashboardController dashboardController) {

    return extend.NestedScrollViewInnerScrollPositionKeyWidget(
      const Key('Tab3'),
      Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.quizDetails.value.comments.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipOval(
                              child: FadeInImage(
                                fit: BoxFit.cover,
                                height: 40,
                                width: 40,
                                image: controller.quizDetails.value
                                        .comments[index].user.image
                                        .contains('public/')
                                    ? NetworkImage(
                                        "$rootUrl/${controller.quizDetails.value.comments[index].user.image}")
                                    : NetworkImage(
                                        controller.quizDetails.value
                                            .comments[index].user.image,
                                      ),
                                placeholder: AssetImage('images/fcimg.png'),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          controller.quizDetails.value
                                              .comments[index].user.name
                                              .toString(),
                                          style: Get.textTheme.subtitle1,
                                        ),
                                        Expanded(child: Container()),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            controller.quizDetails.value
                                                .comments[index].commentDate
                                                .toString(),
                                            style: Get.textTheme.subtitle2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      controller.quizDetails.value
                                          .comments[index].comment
                                          .toString(),
                                      style: Get.textTheme.subtitle2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

}
