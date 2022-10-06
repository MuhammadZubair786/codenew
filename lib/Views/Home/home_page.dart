// Flutter imports:
// ignore_for_file: missing_return

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

// Package imports:

import 'package:get/get.dart';
import 'package:lms_flutter_app/Controller/myCourse_controller.dart';
import 'package:lms_flutter_app/Views/Home/Instructor.dart';
import 'package:lms_flutter_app/Views/Home/Instructor/Instructor.dart';
import 'package:lms_flutter_app/Views/Home/Slider_Webview.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyCourses/my_course_details_view.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyQuiz/my_quiz_details_view.dart';
import 'package:lms_flutter_app/main.dart';
import 'package:lms_flutter_app/utils/DefaultLoadingWidget.dart';
import 'package:lms_flutter_app/utils/widgets/LoadingSkeletonItemWidget.dart';
import 'package:lms_flutter_app/utils/widgets/SingleCardItemWidget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_skeleton/loading_skeleton.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scaled_list/scaled_list.dart';
import 'package:html/parser.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/class_controller.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';
import 'package:lms_flutter_app/Controller/quiz_controller.dart';
import 'package:lms_flutter_app/Views/Home/Class/all_class_view.dart';
import 'package:lms_flutter_app/Views/Home/Class/class_details_page.dart';
import 'package:lms_flutter_app/Views/Home/Course/all_course_view.dart';
import 'package:lms_flutter_app/Views/Home/Course/course_category_page.dart';
import 'package:lms_flutter_app/Views/Home/Course/course_details_page.dart';
import 'package:lms_flutter_app/Views/Home/Quiz/AllQuizzesView.dart';
import 'package:lms_flutter_app/Views/Home/Quiz/quiz_details_page_view.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends GetView<HomeController> {
  Color selectColor(int position) {
    Color c;
    if (position % 4 == 0) c = Color(0xff569AFF);
    if (position % 4 == 1) c = Color(0xff6D55FF);
    if (position % 4 == 2) c = Color(0xffD764FF);
    if (position % 4 == 3) c = Color(0xffFF9800);
    return c;
  }

  final List<Color> kMixedColors = [
    Color(0xff71A5D7),
    Color(0xff72CCD4),
    Color(0xffFBAB57),
    Color(0xffF8B993),
    Color(0xff962D17),
    Color(0xffc657fb),
    // Color(0xfffb8457),
  ];

  Future<void> refresh() async {
    controller.onInit();
    await controller.getCourseDetails();
  
  }

  @override
  Widget build(BuildContext context) {

     String _parseHtmlString(String htmlString) {
    if (htmlString != null) {
      final document = parse(htmlString);
      final String parsedString =
          parse(document.body.text).documentElement.text;
      if (parsedString.length > 30) {
        return parsedString;
      } else {
        return parsedString;
      }
    } else {
      return "";
    }
  }


    double width;
    // double percentageWidth;
    double height;
    double percentageHeight;
    width = MediaQuery.of(context).size.width;
    // percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: defaultLoadingWidget,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBarWidget(
            showSearch: true,
            goToSearch: true,
            showBack: false,
            showFilterBtn: true,
          ),
          body: Container(
            color: Get.theme.cardColor,
            child: RefreshIndicator(
              onRefresh: refresh,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  // SizedBox(
                  //   height: 15,
                  // ),

                  // Slider Section

                  Container(
                    child: Obx(
                      () {
                        if (controller.isLoading.value) {
                          return Text("");
                        } else {
                          return Container(
                            color: Get.theme.cardColor,
                            height: 190,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                aspectRatio: 1.0,
                                enlargeCenterPage: true,
                                height: 300,
                                viewportFraction: 1,
                              ),
                              items:
                                  controller.SliderImg.map((item) => Container(
                                        height: 190,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        // padding: EdgeInsets.all(9),
                                        child: Center(
                                            child: GestureDetector(
                                          onTap: () async {
                                            // print("Ök");
                                            // print(item["btn_link1"].length);
                                            // print(item["title"]);
                                            if (item["btn_link1"].length != 0) {
                                              //   var url =
                                              //       item["btn_link1"].toString();

                                              // var coursename = controller.GetCourse1

                                              var link_break = item["btn_link1"]
                                                  .toString()
                                                  .split("/");
                                              print(link_break);
                                              print(link_break.last);
                                              var data;

                                              var chnglnk = link_break.last[0]
                                                      .toUpperCase() +
                                                  link_break.last
                                                      .substring(1)
                                                      .toLowerCase();
                                              print(chnglnk);
                                              print("new");

                                              for (var i = 0;
                                                  i <
                                                      controller
                                                          .GetCourse1.length;
                                                  i++) {
                                                // if(controller.GetCourse1[i]["title"]["en"]==item["btn_link1"]){
                                                //   print(controller.GetCourse1[i]["title"]["en"]);
                                                //   var userid = controller.GetCourse1[i]
                                                //             ["user_id"];

                                                //       await Get.to(() =>
                                                //           InstructorData1(
                                                //               "item", controller.GetCourse1[i]))
                                                // }

                                                // Conditon On Tite

                                              //  print(controller.GetCourse1[i]["reveiw"]);
                                                if (controller.GetCourse1[i]
                                                            ["title"]["ar"]
                                                        .toString() ==
                                                    item["title"]) {
                                                      print("+++++");
                                                       print(controller.GetCourse1[i]
                                                            ["title"]);
                                                print(item["title"]);
                                               
                                                  await Get.to(() =>
                                                      InstructorData1(
                                                          "item",
                                                          controller
                                                              .GetCourse1[i]));
                                                               break;
                                                }
                                              }

                                              //   // Navigator.of(context).push(
                                              //   //     MaterialPageRoute(
                                              //   //         builder: (_) =>
                                              //   //             SliderWebView(url,
                                              //   //                 item["title"])
                                              //   //                 )
                                              //   //                 );
                                            }
                                            // print(controller.courseDetails.value.image);
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(14.0),
                                            child:
                                                // Text(item["image"].toString())
                                                Image.network(
                                              '$rootUrl/${item["image"]}',
                                              width: width * 0.98,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        )),
                                      )).toList(),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  // Container(
                  //   color: Color(0XFFEEECEC),
                  //   height: 190,
                  //   child:

                  //   CarouselSlider(
                  //     options: CarouselOptions(
                  //       autoPlay: true,
                  //   aspectRatio: 1.0,
                  //   enlargeCenterPage: true,
                  //   height: 300,
                  //   viewportFraction: 1,
                  //     ),
                  //     items: controller.SliderImg
                  //         .map((item) => Container(
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10)
                  //           ),
                  //           padding: EdgeInsets.all(4),
                  //               child: Center(
                  //                   child: ClipRRect(
                  //                       borderRadius: BorderRadius.circular(14.0),
                  //                     child:
                  //                     // Text(item["image"].toString())
                  //                     Image.network(
                  //                       '$rootUrl/${item["image"]}'
                  //                       ,
                  //                          width: width*0.98),
                  //                   )),
                  //             ))
                  //         .toList(),
                  //   ),
                  // ),

                  // SizedBox(
                  //   height: 14,
                  // ),

                  /// TOP CATEGORIES
                  Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        bottom: 14.72,
                        right: 20,
                      ),
                      child: Texth1("بەشە سەرەکییەکان")),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                        Get.locale == Locale('ar') ? 0 : 20,
                        0,
                        Get.locale == Locale('ar') ? 20 : 0,
                        0,
                      ),
                      child: Obx(() {
                        if (controller.isLoading.value)
                          return Container(
                            height: 80,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: 4,
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 12,
                                  );
                                },
                                itemBuilder:
                                    (BuildContext context, int indexCat) {
                                  return LoadingSkeleton(
                                    height: 80,
                                    width: 140,
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 8,
                                          ),
                                          LoadingSkeleton(
                                            height: percentageHeight * 1,
                                            width: 140,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          LoadingSkeleton(
                                            height: percentageHeight * 0.5,
                                            width: 60,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          );
                        else {
                          return Container(
                         
                            height: 150,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.topCatList.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 15,
                                  );
                                },
                                itemBuilder:
                                    (BuildContext context, int indexCat) {
                                  // print(controller.topCatList[indexCat].image);
                                  return GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        
                                        color: Get.theme.cardColor,
                                    border:    Get.theme.brightness==Brightness.dark ?   Border.all(
                                          width: 0.1,
                                           color: Get.theme.brightness==Brightness.dark? Color.fromARGB(255, 46, 46, 46) : Colors.black ,
                                        )
                                        // borderRadius: BorderRadius.circular(5.0)
                                      
                                      :Border.all(
                                          width: 0,
                                           color:  Colors.white ,
                                        ),),
                                      height: 250,
                                      width: MediaQuery.of(context).size.width *
                                          0.28,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(top: 20),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.30,
                                              child: Image.network(
                                                "$rootUrl/${controller.topCatList[indexCat].image}",
                                              )),
                                          Container(
                                            child: CatTitle(controller
                                                        .topCatList[indexCat]
                                                        .name[
                                                    '${stctrl.code.value}'] ??
                                                "${controller.topCatList[indexCat].name['en']}"),
                                          ),
                                          Container(
                                            child: CatSubTitle(controller
                                                    .topCatList[indexCat]
                                                    .courseCount
                                                    .toString() +
                                                ' ' +
                                                "کۆرسەکان"),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Get.to(() => CourseCategoryPage(
                                          controller.topCatList[indexCat].name[
                                                  '${stctrl.code.value}'] ??
                                              "${controller.topCatList[indexCat].name['en']}",
                                          indexCat));
                                    },
                                  );
                                }),
                          );
                        }
                      })),

                  // SizedBox(
                  //   height: 5,
                  // ),

                  /// FEATURED COURSES
                  Container(
                      margin: EdgeInsets.only(
                        left: Get.locale == Locale('ar') ? 12 : 20,
                        bottom: 14.72,
                        top: 5,
                        right: Get.locale == Locale('ar') ? 20 : 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Texth1("کۆرسە تایبەتەکان"),
                          Expanded(
                            child: Container(),
                          ),
                          GestureDetector(
                            child: sellAllText(),
                            onTap: () {
                              Get.to(() => AllCourseView());
                            },
                          )
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        Get.locale == Locale('ar') ? 0 : 10,
                        0,
                        Get.locale == Locale('ar') ? 10 : 0,
                        0),
                    child: Obx(() {
                      if (controller.isLoading.value)
                        return LoadingSkeletonItemWidget();
                      else {
                        return Container(
                          height: 200,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.popularCourseList.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 18,
                                );
                              },
                              padding: EdgeInsets.fromLTRB(
                                  Get.locale == Locale('ar') ? 0 : 5,
                                  0,
                                  Get.locale == Locale('ar') ? 5 : 0,
                                  0),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                // print(
                                //     '$rootUrl/${controller.popularCourseList[0].thumbnail}');
                                return SingleItemCardWidget(
                                  showPricing: true,
                                  image:
                                      "$rootUrl/${controller.popularCourseList[index].thumbnail}",
                                  title: controller.popularCourseList[index]
                                          .title['${stctrl.code.value}'] ??
                                      "${controller.popularCourseList[index].title['en']}",
                                  subTitle: controller
                                      .popularCourseList[index].user.name,
                                  price:
                                      controller.popularCourseList[index].price,
                                  discountPrice: controller
                                      .popularCourseList[index].discountPrice,
                                  onTap: () async {
                                    context.loaderOverlay.show();
                                    controller.selectedLessonID.value = 0;
                                    controller.courseID.value =
                                        controller.popularCourseList[index].id;
                                    await controller.getCourseDetails();

                                    if (controller.isCourseBought.value) {
                                      final MyCourseController
                                          myCoursesController =
                                          Get.put(MyCourseController());

                                      myCoursesController.courseID.value =
                                          controller
                                              .popularCourseList[index].id;
                                      myCoursesController
                                          .selectedLessonID.value = 0;
                                      myCoursesController
                                          .myCourseDetailsTabController
                                          .controller
                                          .index = 0;

                                      await myCoursesController
                                          .getCourseDetails();
                                      Get.to(() => MyCourseDetailsView());
                                      context.loaderOverlay.hide();
                                    } else {
                                      Get.to(() => CourseDetailsPage());
                                      context.loaderOverlay.hide();
                                    }
                                  },
                                );
                              }),
                        );
                      }
                    }),
                  ),

                  // Instructor Section

                  // Container(
                  //   child: Obx(() {
                  //     if (controller.isLoading.value) {
                  //       return Text("");
                  //     } else {
                  //       return Container(
                  //           color: Colors.white,
                  //           height: 40,
                  //           child: CarouselSlider(
                  //               options: CarouselOptions(
                  //                 autoPlay: true,
                  //                 aspectRatio: 1.0,
                  //                 enlargeCenterPage: true,
                  //                 height: 40,
                  //                 viewportFraction: 1,
                  //               ),
                  //               items: controller.InstructorData.map((item) =>
                  //                   Text(
                  //                     item["name"],
                  //                     style: TextStyle(
                  //                         fontSize: 30,
                  //                         fontWeight: FontWeight.bold,
                  //                         color:
                  //                             Color.fromARGB(255, 39, 38, 38),
                  //                         fontFamily: "DynaPuff"),
                  //                   )).toList()));
                  //     }
                  //   }),
                  // ),

                  Container(
                      margin: EdgeInsets.only(
                        left: Get.locale == Locale('ar') ? 12 : 20,
                        bottom: 14.72,
                        top: 30,
                        right: Get.locale == Locale('ar') ? 20 : 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Texth2("مامۆستا"),
                          Expanded(
                            child: Container(),
                          ),
                          // GestureDetector(
                          //   child: sellAllText(),
                          //   onTap: () {
                          //     Get.to(() => AllCourseView());
                          //   },
                          // )
                        ],
                      )),
                  Container(
                    child: Obx(
                      () {
                        if (controller.isLoading.value) {
                          return Text("");
                        } else {
                          return Container(
                            color:Get.theme.cardColor,
                            height: 280,
                            child: CarouselSlider(
                                options: CarouselOptions(
                                  autoPlay: true,
                                  aspectRatio: 1.0,
                                  enlargeCenterPage: true,
                                  height: 500,
                                  viewportFraction: 1,
                                ),
                                items:
                                    controller.InstructorData.map(
                                        (item) => GestureDetector(
                                              onTap: () async {
                                                // print("ok");
                                                // print(item["id"]);
                                                var data;

                                                // print(controller.GetCourse1.length);
                                                for (var i = 0;
                                                    i <
                                                        controller
                                                            .GetCourse1.length;
                                                    i++) {
                                                  print(controller.GetCourse1[i]
                                                      ["user_id"]);
                                                  print(item["id"]);
                                                  //         ["user_id"])
                                                  if (controller.GetCourse1[i]
                                                          ["user_id"] ==
                                                      item["id"]) {
                                                    // print(controller.GetCourse1[i]);
                                                    data = controller
                                                        .GetCourse1[i];
                                                    // print(controller.GetCourse1[i]["lessons"]);

                                                    await Get.to(() =>
                                                        InstructorData1(
                                                            item, data));
                                                  }
                                                }
                                              },
                                              child: Container(
                                                color: Get.theme.cardColor,
                                                height: 400,
                                                child: SizedBox(
                                                  height: 30,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  30.0)),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.95,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    bottom: 10,
                                                                    right: 5,
                                                                    left: 5),
                                                            decoration:
                                                                new BoxDecoration(
                                                                  color: Get.theme.cardColor,
                                                                  border: Border.all(
                                                                    width: 0.03,
                                                                    color: Get.theme.brightness ==Brightness.dark ? Colors.white: Colors.black
                                                                  )
                                                              // boxShadow: [
                                                              //   new BoxShadow(
                                                              //     color: Get.the,
                                                              //     blurRadius:
                                                              //         20.0,
                                                              //   ),
                                                              // ],
                                                            ),
                                                            constraints: BoxConstraints(
    maxHeight: double.infinity,
),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child: Card(
                                                                elevation: 20,
                                                                color: Get.theme.cardColor,
                                                                child: Column(
                                                                  children: [
                                                                    
                                                                    SizedBox(
                                                                      height: 9,
                                                                    ),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                            Container(
                                                                          height:
                                                                              214,
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(0.0),
                                                                            child: Image.network('https://aca.teratarget.com/le/${item["image"]}',
                                                                                fit: BoxFit.fitHeight,
                                                                                width: MediaQuery.of(context).size.width * 0.40),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.50,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Container(
                                                                            margin:
                                                                                EdgeInsets.only(left: 0),
                                                                                padding: EdgeInsets.only(left: 10,right:10),
                                                                            child:
                                                                                Text(
                                                                              item["name"],
                                                                              style: Get.textTheme.subtitle1.copyWith(
                                                                                fontSize: 17,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontStyle: FontStyle.normal,
                                                                                fontFamily: "DynaPuff",
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 5,),
                                                                              Container(
                                                                                  constraints: BoxConstraints(
                                                                                    maxHeight: double.infinity,
                                                                                  ),
                                                                                  width: MediaQuery.of(context).size.width * 0.65,
                                                                                  margin: EdgeInsets.all(5),
                                                                                  padding: EdgeInsets.all(2),
                                                                                  child: Text(
                                                                         _parseHtmlString(item['about'])           ,
                                                                                    style: TextStyle(
                                                                                      color: Get.theme.brightness == Brightness.dark ? Colors.white: Color.fromARGB(255, 39, 38, 38), 
                                                                                      fontFamily: "Rabar_B",
                                                                                       fontSize: 16),
                                                                                  )
                                                                                  // Column(
                                                                                  //   mainAxisSize: MainAxisSize.min,
                                                                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  //   children: <Widget>[
                                                                                  //     Column(
                                                                                  //       crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  //       mainAxisSize: MainAxisSize.max,
                                                                                  //       mainAxisAlignment: MainAxisAlignment.end,
                                                                                  //       children: [
                                                                                  //         SizedBox(
                                                                                  //           height: MediaQuery.of(context).size.height * 0.2,
                                                                                  //           child: Column(
                                                                                  //             crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  //             mainAxisSize: MainAxisSize.max,
                                                                                  //             mainAxisAlignment: MainAxisAlignment.center,
                                                                                  //             children: [
                                                                                  //               Row(
                                                                                  //                 mainAxisAlignment: MainAxisAlignment.start,
                                                                                  //                 children: [
                                                                                  //                   Icon(
                                                                                  //                     Icons.email_outlined,
                                                                                  //                     color: Color(0xFFfb4611),
                                                                                  //                   ),
                                                                                  //                   SizedBox(
                                                                                  //                     width: 5,
                                                                                  //                   ),
                                                                                  //                   // ClipRRect(
                                                                                  //                   //   borderRadius: BorderRadius.circular(8.0),
                                                                                  //                   //   child: Container(
                                                                                  //                   //     //  padding: EdgeInsets.only(left: 15,right: 15),
                                                                                  //                   //     margin: EdgeInsets.only(top: 0, right: 0),

                                                                                  //                   //     child: Container(
                                                                                  //                   //         // color: Colors.pink,
                                                                                  //                   //         // padding: EdgeInsets.all(2),
                                                                                  //                   //         margin: EdgeInsets.only(top: 0, left: 10),
                                                                                  //                   //         child: Text(item["about"].toString()),
                                                                                  //                   //         // child: item["about"].toString().length > 15
                                                                                  //                   //         //     ? Text(
                                                                                  //                   //         //         item["email"].toString().substring(0, 16),
                                                                                  //                   //         //         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "Rabar_B", fontSize: 15),
                                                                                  //                   //         //         textAlign: TextAlign.left,
                                                                                  //                   //         //       )
                                                                                  //                   //         //     : Text(
                                                                                  //                   //         //         item["email"],
                                                                                  //                   //         //         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                                                                                  //                   //         //         textAlign: TextAlign.left,
                                                                                  //                   //         //       ))
                                                                                  //                   //     ),
                                                                                  //                   //   ),
                                                                                  //                   // ),
                                                                                  //                   // Container(
                                                                                  //                   //   margin: EdgeInsets.only(top: 10, right: 10),
                                                                                  //                   //   child: Text(item["name"], style: TextStyle(color: Colors.black, fontSize: 10), textAlign: TextAlign.right),
                                                                                  //                   // ),
                                                                                  //                 ],
                                                                                  //               ),
                                                                                  //               Row(
                                                                                  //                 mainAxisAlignment: MainAxisAlignment.start,
                                                                                  //                 children: [
                                                                                  //                   Icon(
                                                                                  //                     Icons.phone,
                                                                                  //                     color: Color(0xFFfb4611),
                                                                                  //                   ),
                                                                                  //                   SizedBox(
                                                                                  //                     width: 12,
                                                                                  //                   ),
                                                                                  //                   Text(item['phone'].toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "Rabar_D", fontSize: 20), textAlign: TextAlign.right),
                                                                                  //                 ],
                                                                                  //               ),
                                                                                  //             ],
                                                                                  //           ),
                                                                                  //         ),
                                                                                  //         // SizedBox(
                                                                                  //         //   height: 10,
                                                                                  //         // ),
                                                                                  //         // Container(
                                                                                  //         //   margin: EdgeInsets.only(top: 10, right: 10),
                                                                                  //         //   child: Text(Category[0].toString(), style: TextStyle(color: Colors.black, fontSize: 18), textAlign: TextAlign.right),
                                                                                  //         // ),
                                                                                  //         // SizedBox(
                                                                                  //         //   height: 100,
                                                                                  //         // ),
                                                                                  //         Container(
                                                                                  //           padding: EdgeInsets.only(top: 0, left: 0, right: 15),
                                                                                  //           //  margin:EdgeInsets.only(left: 15,right: 15),
                                                                                  //           child: Column(
                                                                                  //             children: [
                                                                                  //               // Row(
                                                                                  //               //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  //               //   children: [
                                                                                  //               //     ClipRRect(
                                                                                  //               //       borderRadius: BorderRadius.circular(8.0),
                                                                                  //               //       child: Container(
                                                                                  //               //         color: Colors.pink,
                                                                                  //               //         padding: EdgeInsets.all(5),
                                                                                  //               //         child: Text(
                                                                                  //               //           item['email'],
                                                                                  //               //           style: TextStyle(color: Colors.white,
                                                                                  //               //            fontSize: 16),
                                                                                  //               //           textAlign: TextAlign.left,
                                                                                  //               //         ),
                                                                                  //               //       ),
                                                                                  //               //     ),

                                                                                  //               //   ],
                                                                                  //               // ),
                                                                                  //             ],
                                                                                  //           ),
                                                                                  //         ),
                                                                                  //       ],
                                                                                  //     ),
                                                                                  //   ],
                                                                                  // ),
                                                                                  // ),

                                                                                  )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ),
                                            )).toList()),
                          );
                        }
                      },
                    ),
                  ),

                  //Instructor Section
                  //       ScaledList(
                  //     itemCount: imgList.length,
                  //     itemColor: (index) {
                  //       return kMixedColors[index % kMixedColors.length];
                  //     },
                  //     itemBuilder: (index, selectedIndex) {
                  //       // final category = img[index];
                  //       return Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Container(
                  //             height: selectedIndex == index ? 100 : 80,
                  //             child: Image.network(imgList[index])
                  //           ),
                  //           SizedBox(height: 15),
                  // //           Text(
                  // //             category.name,
                  // //             style: TextStyle(
                  // // color: Colors.white,
                  // // fontSize: selectedIndex == index ? 25 : 20),
                  // //           )
                  //         ],
                  //       );
                  //     },
                  //   ),

                  /// FEATURED CLASSES
                  Container(
                    margin: EdgeInsets.only(
                      left: Get.locale == Locale('ar') ? 12 : 20,
                      bottom: 14.72,
                      right: Get.locale == Locale('ar') ? 20 : 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Texth1("لایڤ"),
                        Expanded(
                          child: Container(),
                        ),
                        GestureDetector(
                          child: sellAllText(),
                          onTap: () {
                            Get.to(() => AllClassView());
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        Get.locale == Locale('ar') ? 0 : 15,
                        0,
                        Get.locale == Locale('ar') ? 15 : 0,
                        0),
                    child: Obx(() {
                      if (controller.isLoading.value)
                        return LoadingSkeletonItemWidget();
                      else {
                        return Container(
                          height: 200,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.allClassesList.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 18,
                                );
                              },
                              padding: EdgeInsets.fromLTRB(
                                  Get.locale == Locale('ar') ? 0 : 5,
                                  0,
                                  Get.locale == Locale('ar') ? 5 : 0,
                                  0),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                // print(
                                //     '$rootUrl/${controller.allClassesList[index].image}');
                                // print(
                                //     '${controller.allClassesList[index].title['en']}');
                                return SingleItemCardWidget(
                                  showPricing: true,
                                  image:
                                      "$rootUrl/${controller.allClassesList[index].image}",
                                  title: controller.allClassesList[index]
                                          .title['${stctrl.code.value}'] ??
                                      "${controller.allClassesList[index].title['en']}",
                                  subTitle: controller
                                      .allClassesList[index].user.name,
                                  price: controller.allClassesList[index].price,
                                  discountPrice: controller
                                      .allClassesList[index].discountPrice,
                                  onTap: () async {
                                    final ClassController allCourseController =
                                        Get.put(ClassController());
                                    allCourseController.courseID.value =
                                        controller.allClassesList[index].id;
                                    allCourseController.getClassDetails();
                                    Get.to(() => ClassDetailsPage());
                                  },
                                );
                              }),
                        );
                      }
                    }),
                  ),

                  /// FEATURED QUIZZES
                  Container(
                    margin: EdgeInsets.only(
                      left: Get.locale == Locale('ar') ? 12 : 20,
                      bottom: 14.72,
                      right: Get.locale == Locale('ar') ? 20 : 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Texth1("کویزەکان"),
                        Expanded(
                          child: Container(),
                        ),
                        GestureDetector(
                          child: sellAllText(),
                          onTap: () {
                            Get.to(() => AllQuizView());
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        Get.locale == Locale('ar') ? 0 : 15,
                        0,
                        Get.locale == Locale('ar') ? 15 : 0,
                        0),
                    child: Obx(() {
                      if (controller.isLoading.value)
                        return LoadingSkeletonItemWidget();
                      else {
                        return Container(
                          height: 200,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.allQuizzesList.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 18,
                                );
                              },
                              padding: EdgeInsets.fromLTRB(
                                  Get.locale == Locale('ar') ? 0 : 5,
                                  0,
                                  Get.locale == Locale('ar') ? 5 : 0,
                                  0),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return SingleItemCardWidget(
                                  showPricing: true,
                                  image:
                                      "$rootUrl/${controller.allQuizzesList[index].image}",
                                  title: controller.allQuizzesList[index]
                                          .title['${stctrl.code.value}'] ??
                                      "${controller.allQuizzesList[index].title['en']}",
                                  subTitle: controller
                                      .allQuizzesList[index].user.name,
                                  price: controller.allQuizzesList[index].price,
                                  discountPrice: controller
                                      .allQuizzesList[index].discountPrice,
                                  onTap: () async {
                                    context.loaderOverlay.show();
                                    final QuizController allQuizController =
                                        Get.put(QuizController());
                                    allQuizController.courseID.value =
                                        controller.allQuizzesList[index].id;

                                    await allQuizController.getQuizDetails();

                                    if (allQuizController.isQuizBought.value) {
                                      await allQuizController
                                          .getMyQuizDetails();
                                      Get.to(() => MyQuizDetailsPageView());
                                      context.loaderOverlay.hide();
                                    } else {
                                      Get.to(() => QuizDetailsPageView());
                                      context.loaderOverlay.hide();
                                    }
                                  },
                                );
                              }),
                        );
                      }
                    }),
                  ),

                  //**  POPULAR COURSES
                  Container(
                      margin: EdgeInsets.only(
                        left: Get.locale == Locale('ar') ? 12 : 20,
                        bottom: 14.72,
                        top: 30,
                        right: Get.locale == Locale('ar') ? 20 : 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Texth1("${stctrl.lang["Popular Courses"]}"),
                          Texth1("کۆرسە دیارەکان"),
                          Expanded(
                            child: Container(),
                          ),
                          GestureDetector(
                            child: sellAllText(),
                            onTap: () {
                              Get.to(() => AllCourseView());
                            },
                          )
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        Get.locale == Locale('ar') ? 0 : 15,
                        0,
                        Get.locale == Locale('ar') ? 15 : 0,
                        0),
                    child: Obx(() {
                      if (controller.isLoading.value)
                        return LoadingSkeletonItemWidget();
                      else {
                        return Container(
                          height: 200,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.popularCourseList.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 18,
                                );
                              },
                              padding: EdgeInsets.fromLTRB(
                                  Get.locale == Locale('ar') ? 0 : 5,
                                  0,
                                  Get.locale == Locale('ar') ? 5 : 0,
                                  0),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                // print(
                                //     '$rootUrl/${controller.popularCourseList[0].thumbnail}');
                                return SingleItemCardWidget(
                                  showPricing: true,
                                  image:
                                      "$rootUrl/${controller.popularCourseList[index].thumbnail}",
                                  title: controller.popularCourseList[index]
                                          .title['${stctrl.code.value}'] ??
                                      "${controller.popularCourseList[index].title['en']}",
                                  subTitle: controller
                                      .popularCourseList[index].user.name,
                                  price:
                                      controller.popularCourseList[index].price,
                                  discountPrice: controller
                                      .popularCourseList[index].discountPrice,
                                  onTap: () async {
                                    context.loaderOverlay.show();
                                    controller.selectedLessonID.value = 0;
                                    controller.courseID.value =
                                        controller.popularCourseList[index].id;
                                    await controller.getCourseDetails();

                                    if (controller.isCourseBought.value) {
                                      final MyCourseController
                                          myCoursesController =
                                          Get.put(MyCourseController());

                                      myCoursesController.courseID.value =
                                          controller
                                              .popularCourseList[index].id;
                                      myCoursesController
                                          .selectedLessonID.value = 0;
                                      myCoursesController
                                          .myCourseDetailsTabController
                                          .controller
                                          .index = 0;

                                      await myCoursesController
                                          .getCourseDetails();
                                      Get.to(() => MyCourseDetailsView());
                                      context.loaderOverlay.hide();
                                    } else {
                                      Get.to(() => CourseDetailsPage());
                                      context.loaderOverlay.hide();
                                    }
                                  },
                                );
                              }),
                        );
                      }
                    }),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
