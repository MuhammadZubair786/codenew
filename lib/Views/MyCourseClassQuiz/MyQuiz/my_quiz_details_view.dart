// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/my_quiz_details_tab_controller.dart';
import 'package:lms_flutter_app/Controller/question_controller.dart';
import 'package:lms_flutter_app/Controller/quiz_controller.dart';
import 'package:lms_flutter_app/Controller/site_controller.dart';
import 'package:lms_flutter_app/Model/Quiz/MyQuizResultsModel.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyQuiz/quiz_result_screen.dart';
import 'package:lms_flutter_app/utils/SliverAppBarTitleWidget.dart';
import 'start_quiz_page.dart';
import 'package:lms_flutter_app/utils/CustomDate.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/styles.dart';
import 'package:lms_flutter_app/utils/widgets/StarCounterWidget.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;

// ignore: must_be_immutable
class MyQuizDetailsPageView extends StatelessWidget {
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
    final QuizController controller = Get.put(QuizController());

    final DashboardController dashboardController =
        Get.put(DashboardController());

    final MyQuizDetailsTabController _tabx =
        Get.put(MyQuizDetailsTabController());

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
                          controller.myQuizDetails.value
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
                              '$rootUrl/${controller.myQuizDetails.value.image}'),
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
                              courseDescriptionTitle(controller.myQuizDetails
                                      .value.title['${_stctrl.code.value}'] ??
                                  ""),
                              courseDescriptionPublisher(
                                  controller.myQuizDetails.value.user.name),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        StarCounterWidget(
                                          value: double.parse(controller
                                              .myQuizDetails.value.review
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
                                          color:Color(0xFFfb4611),
                                          size: 14,
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        controller.myQuizDetails.value.quiz
                                                    .questionTimeType ==
                                                0
                                            ? courseStructure(controller
                                                    .myQuizDetails
                                                    .value
                                                    .quiz
                                                    .questionTime
                                                    .toString() +
                                                " min/Q")
                                            : courseStructure(controller
                                                    .myQuizDetails
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
                                        courseStructure(controller.myQuizDetails
                                                    .value.level ==
                                                1
                                            ? "ئاستی سەرەتایی"
                                            : controller.myQuizDetails.value
                                                        .level ==
                                                    2
                                                ? "ئاستی مام ناوەند"
                                                : controller.myQuizDetails.value
                                                            .level ==
                                                        3
                                                    ? "ئاستی پێشکەوتوو"
                                                    : controller.myQuizDetails
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
                                            .myQuizDetails.value.totalEnrolled
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
                    quizDetailsWidget(controller, dashboardController),
                    resultsWidget(controller, dashboardController),
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
    return extend.NestedScrollViewInnerScrollPositionKeyWidget(
      const Key('Tab1'),
      Scaffold(
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            Text(
              "رێنمایی",
              style: Get.textTheme.subtitle1,
            ),
            Container(
              width: percentageWidth * 100,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: HtmlWidget(
                '''
                ${controller.myQuizDetails.value.quiz.instruction['${stctrl.code.value}'] ?? "${controller.myQuizDetails.value.quiz.instruction['en']}"}
                ''',
                textStyle: Get.textTheme.subtitle2,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "کاتی کویز",
              style: Get.textTheme.subtitle1,
            ),
            SizedBox(
              height: 10,
            ),
            controller.myQuizDetails.value.quiz.questionTimeType == 0
                ? Text(
                    "${controller.myQuizDetails.value.quiz.questionTime} " +
                        "دەقە بۆ هەر پرسیارێک",
                    style: Get.textTheme.subtitle2,
                  )
                : Text(
                    "${controller.myQuizDetails.value.quiz.questionTime} " +
                        "دەقە",
                    style: Get.textTheme.subtitle2,
                  ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: controller
                    .myQuizDetails.value.quiz.multipleAttend ==
                1
            ? ElevatedButton(
                child: Text(
                  "کویزەکە دەست پێ بکە",
                  style: Get.textTheme.subtitle2.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Get.defaultDialog(
                    title: "کویزەکە دەست پێ بکە",
                    backgroundColor: Get.theme.cardColor,
                    titleStyle: Get.textTheme.subtitle1,
                    barrierDismissible: true,
                    content: Column(
                      children: [
                        courseStructure(
                          "دەتەوێت کویزەکە دەست پێ بکەیت؟",
                        ),
                        controller.myQuizDetails.value.quiz.questionTimeType ==
                                0
                            ? courseStructure(
                                "کاتی کویز" +
                                    ": " +
                                    controller
                                        .myQuizDetails.value.quiz.questionTime
                                        .toString() +
                                    " " +
                                    "دەقە بۆ هەر پرسیارێک",
                              )
                            : courseStructure(
                                "کاتی کویز" +
                                    ": " +
                                    controller
                                        .myQuizDetails.value.quiz.questionTime
                                        .toString() +
                                    " " +
                                    "دەقە",
                              ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                width: 100,
                                height: percentageHeight * 5,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "${stctrl.lang["Cancel"]}",
                                  style: Get.textTheme.subtitle1,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Obx(() {
                              return controller.isQuizStarting.value
                                  ? Container(
                                      width: 100,
                                      height: percentageHeight * 5,
                                      alignment: Alignment.center,
                                      child: CupertinoActivityIndicator())
                                  : ElevatedButton(
                                      onPressed: () async {
                                        await controller
                                            .startQuiz()
                                            .then((value) {
                                          if (value) {
                                            Get.back();
                                            Get.to(() => StartQuizPage(
                                                getQuizDetails: controller
                                                    .myQuizDetails.value));
                                          } else {
                                            Get.snackbar(
                                              "هەڵە",
                                              "دەتەوێت کویزەکە دەست پێ بکەیت؟",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.red,
                                              colorText: Colors.black,
                                              borderRadius: 5,
                                              duration: Duration(seconds: 3),
                                            );
                                          }
                                        });
                                      },
                                      child: Text(
                                        "دەست پێ کردن",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xffffffff),
                                            height: 1.3,
                                            fontFamily: 'AvenirNext'),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                            })
                          ],
                        ),
                      ],
                    ),
                    radius: 5,
                  );
                },
              )
            : Container(),
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
                itemCount: controller.myQuizDetails.value.comments.length,
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
                                image: NetworkImage(rootUrl +
                                    '/' +
                                    controller.myQuizDetails.value
                                        .comments[index].user.image),
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
                                          controller.myQuizDetails.value
                                              .comments[index].user.name
                                              .toString(),
                                          style: Get.textTheme.subtitle1,
                                        ),
                                        Expanded(child: Container()),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            controller.myQuizDetails.value
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
                                      controller.myQuizDetails.value
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
              height: 100,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                child: ClipOval(
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                    image: NetworkImage(rootUrl +
                            "/" +
                            controller.dashboardController.profileData.image ??
                        ""),
                    placeholder: AssetImage('images/fcimg.png'),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  width: percentageWidth * 50,
                  constraints: BoxConstraints(maxHeight: percentageWidth * 15),
                  decoration: BoxDecoration(
                    color: Color(0xffF2F6FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.zero,
                  child: TextField(
                    controller: controller.commentController,
                    maxLines: 10,
                    minLines: 1,
                    autofocus: false,
                    showCursor: true,
                    scrollPhysics: AlwaysScrollableScrollPhysics(),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        filled: true,
                        fillColor: Get.theme.canvasColor,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                        hintText: "کۆمێنت بنوسە",
                        hintStyle: Get.textTheme.subtitle1),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  controller.submitComment(controller.myQuizDetails.value.id,
                      controller.commentController.value.text);
                },
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Transform.rotate(
                      angle: math.pi / 4,
                      child: Icon(
                        FontAwesomeIcons.locationArrow,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resultsWidget(
      QuizController controller, DashboardController dashboardController) {
    // return Container();
    return extend.NestedScrollViewInnerScrollPositionKeyWidget(
      const Key('Tab3'),
      Container(
        child: controller.myQuizResult.value.data.length == 0
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Texth1("هیچ ئەنجامێک نەدۆزرایەوە"),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "رێکەوت",
                            style: Get.textTheme.subtitle1
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "نمرە",
                            style: Get.textTheme.subtitle1
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "%",
                            style: Get.textTheme.subtitle1
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "هەلسەنگاندن",
                            style: Get.textTheme.subtitle1
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 15,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.myQuizResult.value.data.length,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(vertical: 4),
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 16,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          final MyQuizResultsData data =
                              controller.myQuizResult.value.data[index];
                          var obtainedMarks = 0;
                          var totalScore = 0;
                          var status = "";
                          var percentage = "";
                          data.result.forEach((element) {
                            if (element.quizTestId == data.id) {
                              obtainedMarks = element.score;
                              totalScore = element.totalScore;
                              if (element.publish == 1) {
                                status = element.status;
                              } else {
                                status = "Pending";
                              }
                              percentage = double.parse(
                                      ((element.score / element.totalScore) *
                                              100)
                                          .toString())
                                  .toStringAsFixed(2);
                            }
                          });
                          return InkWell(
                            onTap: () async {
                              final QuestionController questionController =
                                  Get.put(QuestionController());

                              await questionController
                                  .getQuizResultPreview(data.id);
                              Get.to(() => QuizResultScreen());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${CustomDate().formattedDate(data.startAt)}",
                                    textAlign: TextAlign.start,
                                    style: context.textTheme.subtitle1,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "$obtainedMarks/$totalScore",
                                    style: context.textTheme.subtitle2,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "$percentage %",
                                    style: context.textTheme.subtitle2,
                                  ),
                                ),
                                status == "Pending"
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xfff4f6fe),
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "$status".toUpperCase(),
                                          style: context.textTheme.subtitle2
                                              .copyWith(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      )
                                    : status == "Failed"
                                        ? Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xffFF1414),
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              "$status",
                                              style: context.textTheme.subtitle2
                                                  .copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                                color: Get.theme.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              "$status",
                                              style: context.textTheme.subtitle2
                                                  .copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
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
      ),
    );
  }
}
