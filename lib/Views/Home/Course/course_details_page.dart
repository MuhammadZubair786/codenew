// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:html/parser.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/cart_controller.dart';
import 'package:lms_flutter_app/Controller/course_details_tab_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/download_controller.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';
import 'package:lms_flutter_app/Controller/lesson_controller.dart';
import 'package:lms_flutter_app/Views/VideoView/PDFViewPage.dart';
import 'package:lms_flutter_app/Views/VideoView/VideoChipherPage.dart';
import 'package:lms_flutter_app/Views/VideoView/VimeoPlayerPage.dart';
import 'package:lms_flutter_app/Views/VideoView/VideoPlayerPage.dart';
import 'package:lms_flutter_app/utils/CustomAlertBox.dart';
import 'package:lms_flutter_app/utils/CustomExpansionTileCard.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/MediaUtils.dart';
import 'package:lms_flutter_app/utils/SliverAppBarTitleWidget.dart';
import 'package:lms_flutter_app/utils/styles.dart';
import 'package:lms_flutter_app/utils/widgets/StarCounterWidget.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:open_document/open_document.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

// ignore: must_be_immutable
class CourseDetailsPage extends StatefulWidget {
  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
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
    // print("code :" + stctrl.code.toString());
    print(controller.courseDetails.value.user.about);
  }

  String _parseHtmlString1(String htmlString) {
    if (htmlString != null) {
      final document = parse(htmlString);
      final String parsedString =
          parse(document.body.text).documentElement.text;
      var data = parsedString.split(".");
      // print(data);
      return parsedString.substring(0, 30);
    } else {
      return "";
    }
  }

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

  String _parseHtmlString2(String htmlString) {
    if (htmlString != null) {
      final document = parse(htmlString);
      final String parsedString =
          parse(document.body.text).documentElement.text;
      return parsedString;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.put(DashboardController());

    final CourseDetailsTabController _tabx =
        Get.put(CourseDetailsTabController());

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: AppcourseDescriptionTitle(
            controller.courseDetails.value.title['${stctrl.code.value}'] ??
                "${controller.courseDetails.value.title['en']}"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: SpinKitPulse(
            color: Get.theme.primaryColor,
            size: 30.0,
          ),
        ),
        child: Obx(() {
          if (controller.isCourseLoading.value)
            return Center(
              child: CupertinoActivityIndicator(),
            );
          return extend.NestedScrollView(
            // floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 280.0,
                  automaticallyImplyLeading: false,
                  titleSpacing: 20,
                  title: SliverAppBarTitleWidget(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(onPressed: () {}, child: Text("Ok")),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            controller.courseDetails.value
                                    .title['${stctrl.code.value}'] ??
                                "${controller.courseDetails.value.title['en']}",
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
                                '$rootUrl/${controller.courseDetails.value.image}'),
                            placeholder: AssetImage('images/fcimg.png'),
                            fit: BoxFit.cover,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 26),
                            color: Colors.black.withOpacity(0.7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [],
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
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    constraints: BoxConstraints(
                      maxHeight: double.infinity,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.0),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(4, 8), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                          width: 0.4,
                          color: Color.fromARGB(255, 182, 182, 182),
                        ),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                              child: ContainercourseDescriptionTitle(
                            controller.courseDetails.value
                                    .title['${stctrl.code.value}'] ??
                                "${controller.courseDetails.value.title['en']}",
                          )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //  ElevatedButton(onPressed: (){
                        //   print(controller.courseDetails.value);
                        //  }, child: Text("Ok")),

                        Divider(
                          height: 0.5,
                          color: Color.fromARGB(255, 182, 182, 182),
                        ),

                        Container(
                          height:93,
                           margin:  stctrl.code == 'ar' ? EdgeInsets.only(left: 0):EdgeInsets.only(left: 0),
                          padding: EdgeInsets.only(top: 10,left: 0),
                          child: Row(
                            mainAxisAlignment: stctrl.code == 'ar'
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding: stctrl.code == 'ar'
                                      ? EdgeInsets.only(left: 0,right: 7,top: 5)
                                      : EdgeInsets.only(left: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Column(
                                    children: [
                                        Text("ئاست",
                                    style: TextStyle(fontSize: 9,color:Colors.black,
                                    fontWeight: FontWeight.bold
                                    ),),
                                      Icon(
                                        Icons.insert_chart_sharp,
                                        color: Color(0xFFfb4611),
                                        size: 25,
                                      ),
                                      SizedBox(
                                        height: 0,
                                      ),

                                       controller.courseDetails.value.level.toString() == "1" ? 
                                      Text(
                                        "دەستپێکەران"
                                       ,
                                        style: TextStyle(
                                           fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 71, 71, 71)),
                                      ):
                                      controller.courseDetails.value.level.toString() == "2" ? 
                                       Text(
                                        "مام ناوەند"
                                       ,
                                        style: TextStyle(
                                           fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 71, 71, 71)),
                                      ):
                                      controller.courseDetails.value.level.toString() == "3" ? 
                                       Text(
                                        "پێشکەوتوو"
                                       ,
                                        style: TextStyle(
                                           fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 71, 71, 71)),
                                      ):
                                       controller.courseDetails.value.level.toString() == "4" ? 
                                       Text(
                                        "پرۆ"
                                       ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 71, 71, 71)),
                                      ):
                                       Text(
                                        "null"
                                       ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 71, 71, 71)),
                                      )
                                  
                                      ,
                                    ],
                                  )),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.20,
                                child: VerticalDivider(
                                  color: Color.fromARGB(255, 182, 182, 182),
                                  thickness: 0.5,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.20,
                                 margin:  stctrl.code == 'ar' ?  
                                 EdgeInsets.only(left: 15):EdgeInsets.only(left: 0),
                                padding: stctrl.code == 'ar' ?     EdgeInsets.only(left: 0,top: 5,right: 15):
                                EdgeInsets.only(left: 0,top: 5,right: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children: [
                                      Text("بەشداری",
                                    style: TextStyle(fontSize: 9,color:Colors.black,
                                    fontWeight: FontWeight.bold
                                    ),),
                                    Icon(
                                      Icons.subscriptions,
                                      color: Color(0xFFfb4611),
                                      size: 25,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left:0,right: 8),
                                      child: Text(
                                       controller.courseDetails.value.totalEnrolled.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 37, 37, 37)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              VerticalDivider(
                                color: Color.fromARGB(255, 182, 182, 182),
                                thickness: 0.5,
                              ),
                              Container(
                                padding: stctrl.code=='ar' ?  
                                EdgeInsets.only(left: 17,top: 6,right: 7):EdgeInsets.only(left: 0,top: 5),
                                // width: MediaQuery.of(context).size.width*0.20,
                                child: Column(
                                  children: [
                                    Text(" هەڵسەنگاندن ",
                                    style: TextStyle(fontSize: 9,color:Colors.black,
                                    fontWeight: FontWeight.bold
                                    ),),
                                    Icon(
                                      Icons.rate_review,
                                      color: Color(0xFFfb4611),
                                      size: 25,
                                    ),
                                    SizedBox(
                                      height: 3,
                                      width: 80,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          controller.courseDetails.value.review.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 65, 63, 63)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 5,
                      bottom: 5,
                    ),
                    constraints: BoxConstraints(
                      maxHeight: double.infinity,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.1,
                          color: Color.fromARGB(255, 128, 128, 128),
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 220, 220, 220)
                                .withOpacity(0.0),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(4, 8), // changes position of shadow
                          ),
                        ]),
                    child: Column(
                      children: [
                        Container(

                            margin: EdgeInsets.only(top: 2),
                            child: Align(
                               alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.only(left:30,right:30),
                                child: Text("زانیاری مامۆستا",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 16, 16, 16),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 25,
                                        fontFamily: "CodaRegular")),
                              ),
                            )),
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: double.infinity,
                          ),
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 20),
                                      child: ClipOval(
                                        child: Image.network(
                                          '$rootUrl/${controller.courseDetails.value.user.image}',
                                          width: 85,
                                          height: 85,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                     width: 230,
                                    constraints: BoxConstraints(
                                      maxHeight: double.infinity,
                                    ),
                                    padding: EdgeInsets.only(right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller
                                              .courseDetails.value.user.name,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 16, 16, 16),
                                              fontFamily: "CodaRegular"),
                                          textAlign: TextAlign.right,
                                        ),
                                        Container(
                                          child: Text(
                                            _parseHtmlString(controller
                                                .courseDetails
                                                .value
                                                .user
                                                .about),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 16, 16, 16),
                                                fontFamily: "CodaRegular"),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                 
                                ],
                              ),
                              // Container(
                              //   margin: EdgeInsets.all(2),
                              //   child: HtmlWidget(''''
                              //       ${controller.courseDetails.value.user.about}
                              //       '''),
                              // )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  controller.courseDetails.value.duration != ""
                      ? Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 5,
                            bottom: 5,
                          ),
                          height: 110,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.1,
                               color: Color.fromARGB(255, 128, 128, 128),
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                   color: Color.fromARGB(255, 220, 220, 220)
                                .withOpacity(0.0),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(4, 8), // changes position of shadow
                                ),
                              ]),
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 2),
                                  child: Align(
                               alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.only(left:30,right:30),
                                    child: Text("کاتی کۆرس ",
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 16, 16, 16),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 25,
                                            fontFamily: "Rabar_B")),
                                  ))),
                              Container(
                                alignment: Alignment.topCenter,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                     Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        padding: EdgeInsets.only(right: 20),
                                        child: ClipOval(
                                            child: Icon(
                                          Icons.watch_later_outlined,
                                          size: 50,
                                          color: Colors.grey,
                                        )),
                                        // CircleAvatar(
                                        //   radius: 30.0,
                                        //   backgroundColor: Color(0xFFD7598F),
                                        //   backgroundImage: NetworkImage(
                                        //     '$rootUrl/${controller.courseDetails.value.image}',

                                        //   ),
                                        // ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              
                                              Text(
                                                "  "+
                                                
                                                  controller.courseDetails.value
                                                    .duration.toString()+"  " ,
                                                   
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 16, 16, 16),
                                                    fontFamily: "Rabar_D"),
                                                textAlign: TextAlign.right,
                                              ),
                                               Text(
                                                "دەقە "  ,
                                                   
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 16, 16, 16),
                                                    fontFamily: "Rabar_D"),
                                                textAlign: TextAlign.right,
                                              ),
                                              
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                   
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(""),
                  SizedBox(
                    height: 15,
                  ),
                  controller.courseDetails.value.about != ""
                      ? Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 5,
                            bottom: 5,
                          ),
                          constraints: BoxConstraints(
                            maxHeight: double.infinity,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.1,
                                color: Color.fromARGB(255, 128, 128, 128),
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                   color: Color.fromARGB(255, 220, 220, 220)
                                .withOpacity(0.0),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(4, 8), // changes position of shadow
                                ),
                              ]),
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 2),
                                  child: Align(
                               alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.only(left:30,right:30),
                                
                                child:Text("زانیاری کۆرس",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 16, 16, 16),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 25,
                                          fontFamily: "Rabar_B")))),
                              ),
                              Container(
                                alignment: Alignment.topCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            // width: MediaQuery.of(context).size.width*0.80,
                                            child: Container(
                                              width: percentageWidth * 90,
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 5),
                                              child: HtmlWidget(
                                                '''
                ${controller.courseDetails.value.about['ar'] ?? "${controller.courseDetails.value.about['ar']}"}
                 ''',
                                                textStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color.fromARGB(
                                                        255, 10, 1, 1),
                                                    fontFamily: "Rabar_D"),
                                              ),
                                            ),

                                            // child: HtmlWidget(
                                            //   '''
                                            //  ${controller.courseDetails.value.about.toString()}
                                            //  ''',
                                            //   // overflow: TextOverflow.ellipsis,
                                            //   // style: TextStyle(

                                            // color:
                                            //     Color.fromARGB(255, 16, 16, 16),
                                            // fontFamily: "CodaRegular"),
                                            // textAlign: TextAlign.justify,

                                            // ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(""),
                  SizedBox(
                    height: 15,
                  ),
                  controller.courseDetails.value.outcomes != ""
                      ? Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 5,
                            bottom: 5,
                          ),
                          constraints: BoxConstraints(
                            maxHeight: double.infinity,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.1,
                                color: Color.fromARGB(255, 128, 128, 128),
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                   color: Color.fromARGB(255, 220, 220, 220)
                                .withOpacity(0.0),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(4, 8), // changes position of shadow
                                ),
                              ]),
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 2, left: 2, right: 2),
                                  child: Align(
                               alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.only(left:30,right:30),
                                child:Text("چی فێردەبیت",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 16, 16, 16),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 25,
                                          fontFamily: "Rabar_B"))))),
                              Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(
                                    left: 5, right: 5, bottom: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      width: percentageWidth * 100,
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 5),
                                      child: HtmlWidget(
                                        '''
                ${controller.courseDetails.value.outcomes['ar'] ?? "${controller.courseDetails.value.outcomes['ar']}" ?? "${controller.courseDetails.value.outcomes['ar']}"}
                ''',
                                        customStylesBuilder: (element) {
                                          if (element.classes.contains('foo')) {
                                            return {'color': 'red'};
                                          }
                                          return null;
                                        },
                                        customWidgetBuilder: (element) {
                                          if (element.attributes['foo'] ==
                                              'bar') {
                                            // return FooBarWidget();
                                          }
                                          return null;
                                        },
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color:
                                                Color.fromARGB(255, 16, 16, 16),
                                            fontFamily: "Rabar_D"),
                                      ),
                                    ),
                                    // TextClick(_parseHtmlString(controller.courseDetails.value.outcomes["en"])),
                                    // TextClick("قبل العرس بايام كثيرةً وبسنة أحياناً"),
                                    // TextClick(
                                    //     "في بلدي يسأل الرجل امرأة أن تتزوجه عندما يحبها"),
                                    // TextClick("قبل العرس بايام كثيرةً وبسنة أحياناً"),
                                    // TextClick(
                                    //     "في بلدي يسأل الرجل امرأة أن تتزوجه عندما يحبها"),
                                    // TextClick("قبل العرس بايام كثيرةً وبسنة أحياناً"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(""),
                  SizedBox(
                    height: 15,
                  ),
                  //   Container(
                  //     margin: EdgeInsets.only(
                  //       left: 10,
                  //       right: 10,
                  //       top: 5,
                  //       bottom: 5,
                  //     ),
                  //     constraints: BoxConstraints(
                  //       maxHeight: double.infinity,
                  //     ),
                  //     decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         border: Border.all(
                  //           width: 1,
                  //           color: Color.fromARGB(255, 255, 255, 255),
                  //         ),
                  //         borderRadius: BorderRadius.circular(30),
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Color.fromARGB(255, 220, 220, 220)
                  //                 .withOpacity(0.5),
                  //             spreadRadius: 10,
                  //             blurRadius: 10,
                  //             offset: Offset(4, 8), // changes position of shadow
                  //           ),
                  //         ]),
                  //     child: Column(
                  //       children: [
                  //         Container(
                  //             margin: EdgeInsets.only(top: 2, left: 2, right: 2),
                  //             child: Center(
                  //               child: Text("متطلبات الدورة",
                  //                   style: TextStyle(
                  //                       color: Color.fromARGB(255, 16, 16, 16),
                  //                       fontWeight: FontWeight.w900,
                  //                       fontSize: 20,
                  //                       fontFamily: "Rabar_B")),
                  //             )),
                  //         Container(
                  //           alignment: Alignment.topCenter,
                  //           padding:
                  //               EdgeInsets.only(left: 5, right: 5, bottom: 10),
                  //           child: Column(
                  //             children: [
                  //               Container(
                  //                 width: percentageWidth * 100,
                  //                 padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                  //                 child: HtmlWidget(
                  //                   '''
                  // ${controller.courseDetails.value.requirements['ar'] ?? "${controller.courseDetails.value.requirements['ar']}" ?? "${controller.courseDetails.value.requirements['ar']}"}
                  // ''',
                  //                   customStylesBuilder: (element) {
                  //                     if (element.classes.contains('foo')) {
                  //                       return {'color': 'red'};
                  //                     }
                  //                     return null;
                  //                   },
                  //                   customWidgetBuilder: (element) {
                  //                     if (element.attributes['foo'] == 'bar') {
                  //                       // return FooBarWidget();
                  //                     }
                  //                     return null;
                  //                   },
                  //                   textStyle: TextStyle(
                  //                       fontWeight: FontWeight.normal,
                  //                       color: Color.fromARGB(255, 16, 16, 16),
                  //                       textBaseline: TextBaseline.alphabetic,
                  //                       fontFamily: "Rabar_D"),
                  //                 ),
                  //               ),
                  //               // TextClick(_parseHtmlString(controller.courseDetails.value.outcomes["en"])),
                  //               // TextClick("قبل العرس بايام كثيرةً وبسنة أحياناً"),
                  //               // TextClick(
                  //               //     "في بلدي يسأل الرجل امرأة أن تتزوجه عندما يحبها"),
                  //               // TextClick("قبل العرس بايام كثيرةً وبسنة أحياناً"),
                  //               // TextClick(
                  //               //     "في بلدي يسأل الرجل امرأة أن تتزوجه عندما يحبها"),
                  //               // TextClick("قبل العرس بايام كثيرةً وبسنة أحياناً"),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),

                  SizedBox(height: 10),
                  // controller.courseDetails.value.lessons.length > 0
                  //     ? Container(
                          // margin: EdgeInsets.only(
                          //   left: 10,
                          //   right: 10,
                          //   top: 5,
                          //   bottom: 5,
                          // ),
                          // constraints: BoxConstraints(
                          //   maxHeight: double.infinity,
                          // ),
                          // decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     border: Border.all(
                          //       width: 1,
                          //       color: Color.fromARGB(255, 255, 255, 255),
                          //     ),
                          //     borderRadius: BorderRadius.circular(30),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Color.fromARGB(255, 220, 220, 220)
                          //             .withOpacity(0.5),
                          //         spreadRadius: 10,
                          //         blurRadius: 10,
                          //         offset: Offset(
                          //             4, 8), // changes position of shadow
                          //       ),
                          //     ]),
                  //         child: Column(
                  //           children: [
                              // Container(
                              //     margin: EdgeInsets.only(
                              //         top: 2, left: 2, right: 2),
                              //     child: Center(
                              //       child: Text("منهاج دراسي",
                              //           style: TextStyle(
                              //               color:
                              //                   Color.fromARGB(255, 16, 16, 16),
                              //               fontWeight: FontWeight.w900,
                              //               fontSize: 20,
                              //               fontFamily: "rabar_B")),
                              //     )),
                  //             Container(
                  //               alignment: Alignment.topCenter,
                  //               padding: EdgeInsets.only(
                  //                   left: 5, right: 5, bottom: 10),
                  //               child: Column(
                  //                 children: [
                  //                   Container(
                  //                       width: percentageWidth * 100,
                  //                       padding: EdgeInsets.fromLTRB(
                  //                           0, percentageHeight * 3, 0, 0),
                  //                       child: ListView.builder(
                  //                           shrinkWrap: true,
                  //                           // physics: NeverScrollableScrollPhysics(),
                  //                           itemCount: controller.courseDetails
                  //                               .value.lessons.length,
                  //                           itemBuilder: (context, index) {
                  //                             return Container(
                  //                                 margin: EdgeInsets.all(9),
                  //                                 constraints: BoxConstraints(
                  //                                   maxHeight: double.infinity,
                  //                                 ),
                  //                                 child: Column(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment.start,
                  //                                   crossAxisAlignment:
                  //                                       CrossAxisAlignment
                  //                                           .start,
                  //                                   children: [
                  //                                     Row(
                  //                                       mainAxisAlignment:
                  //                                           MainAxisAlignment
                  //                                               .spaceBetween,
                  //                                       children: [
                  //                                         Text(
                  //                                           (index + 1)
                  //                                                   .toString() +
                  //                                               ") " +
                  //                                               controller
                  //                                                   .courseDetails
                  //                                                   .value
                  //                                                   .lessons[
                  //                                                       index]
                  //                                                   .name +
                  //                                               " Lectures",
                  //                                           style: TextStyle(
                  //                                               fontFamily:
                  //                                                   "Rabar_B",
                  //                                               color: Colors
                  //                                                   .black,
                  //                                               fontWeight:
                  //                                                   FontWeight
                  //                                                       .bold,
                  //                                               fontSize: 20),
                  //                                         ),
                  //                                         Text(
                  //                                           controller
                  //                                                   .courseDetails
                  //                                                   .value
                  //                                                   .lessons[
                  //                                                       index]
                  //                                                   .duration
                  //                                                   .toString() +
                  //                                               "min",
                  //                                           style: TextStyle(
                  //                                               fontFamily:
                  //                                                   "Rabar_D",
                  //                                               color: Colors
                  //                                                   .black,
                  //                                               fontSize: 20),
                  //                                         ),
                  //                                       ],
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                                   .only(
                  //                                               left: 20.0),
                  //                                       child: Text(
                  //                                         " host :" +
                  //                                             controller
                  //                                                 .courseDetails
                  //                                                 .value
                  //                                                 .lessons[
                  //                                                     index]
                  //                                                 .host,
                  //                                         style: TextStyle(
                  //                                             fontFamily:
                  //                                                 "Rabar_B",
                  //                                             color:
                  //                                                 Colors.black,
                  //                                             fontSize: 15),
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                                   .only(
                  //                                               left: 20.0),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Icon(
                  //                                             Icons.lock,
                  //                                             color: Colors.red,
                  //                                             size: 20,
                  //                                           ),
                  //                                           //        Text(
                  //                                           // "  "+
                  //                                           //           controller.courseDetails.value
                  //                                           //               .lessons[index].isLock.toString() ,

                  //                                           // style: TextStyle(
                  //                                           //           color: Colors.black,
                  //                                           //           fontSize: 15),
                  //                                           // ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ));
                  //                           }))
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : Text(""),
                  SizedBox(
                    height: 0,
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(
                  //     left: 10,
                  //     right: 10,
                  //     top: 5,
                  //     bottom: 5,
                  //   ),
                  //   height: 490,
                  //   width: MediaQuery.of(context).size.width,
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       border: Border.all(
                  //         width: 1,
                  //         color: Color.fromARGB(255, 255, 255, 255),
                  //       ),
                  //       borderRadius: BorderRadius.circular(30),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Color.fromARGB(255, 220, 220, 220)
                  //               .withOpacity(0.5),
                  //           spreadRadius: 10,
                  //           blurRadius: 10,
                  //           offset: Offset(4, 8), // changes position of shadow
                  //         ),
                  //       ]),
                  //   child: Column(
                  //     children: [
                  //       // Text("كل ايام",
                  //       //     style: TextStyle(
                  //       //         color: Color.fromARGB(255, 16, 16, 16),
                  //       //         fontWeight: FontWeight.w900,
                  //       //         fontSize: 20,
                  //       //         fontFamily: "CodaRegular")),
                  //       // AddTextWidget("اذن تقول"),
                  //       // AddTextWidget("كل الضيوف"),
                  //       // AddTextWidget("بالنسبة لهم"),
                  //       // AddTextWidget("رأس الطالب"),
                  //       // AddTextWidget("اذن تقول"),
                  //       // AddTextWidget(" يوفر أب العروس")
                  //     ],
                  //   ),
                  // ),
                  // //
                  // // TabBar(
                  // //   labelColor: Colors.white,
                  // //   tabs: _tabx.myTabs,
                  // //   unselectedLabelColor: AppStyles.unSelectedTabTextColor,
                  // //   controller: _tabx.controller,
                  // //   // indicator: Get.theme.tabBarTheme.indicator,
                  // //   // automaticIndicatorColorAdjustment: true,
                  // //   isScrollable: false,
                  // //   labelStyle: Get.textTheme.subtitle2,
                  // //   unselectedLabelStyle: Get.textTheme.subtitle2,

                  // // ),
                  // // Expanded(
                  // //   child: TabBarView(
                  // //     controller: _tabx.controller,
                  // //     physics: NeverScrollableScrollPhysics(),
                  // //     children: <Widget>[
                  // //       descriptionWidget(controller, dashboardController),
                  // //       curriculumWidget(controller, dashboardController),
                  // //       reviewWidget(controller, dashboardController),
                  // //     ],
                  // //   ),
                  // // )

                  // Text("CHANGE",style: TextStyle(color: Colors.yellow),),
                 
                  Container(
                      margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 0,
                            bottom: 5,
                          ),
                          constraints: BoxConstraints(
                            maxHeight: double.infinity,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.1,
                                color: Color.fromARGB(255, 117, 117, 117),
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                   color: Color.fromARGB(255, 220, 220, 220)
                                .withOpacity(0.0),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(4, 8), // changes position of shadow
                                ),
                              ]),

                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                                  margin: EdgeInsets.only(
                                      top: 2, left: 2, right: 2),
                               child:  Align(
                               alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.only(left:30,right:30),
                                child: Text("وانە و چاپتەرەکان",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 16, 16, 16),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 25,
                                          fontFamily: "rabar_B"))),)),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: controller.courseDetails.value.chapters.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 4,
                            );
                          },
                          itemBuilder: (context, index) {
                            var lessons = controller.courseDetails.value.lessons
                                .where((element) =>
                                    int.parse(element.chapterId.toString()) ==
                                    int.parse(controller
                                        .courseDetails.value.chapters[index].id
                                        .toString()))
                                .toList();
                            var total = 0;
                            print(lessons);
                            lessons.forEach((element) {
                              if (element.duration != null &&
                                  element.duration != "") {
                                if (!element.duration.contains("H")) {
                                  total += double.parse(element.duration).toInt();
                                }
                              }
                            });
                            final GlobalKey expansionTileKey = GlobalKey();

                             void _scrollToSelectedContent(GlobalKey myKey) {
      final keyContext = myKey.currentContext;

      if (keyContext != null) {
        Future.delayed(Duration(milliseconds: 200)).then((value) {
          Scrollable.ensureVisible(keyContext,
              duration: Duration(milliseconds: 200));
        });
      }
    }
                           return CustomExpansionTileCard(
                key: expansionTileKey,
                baseColor: Colors.white,
               
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                onExpansionChanged: (isExpanded) {
                        if (isExpanded) _scrollToSelectedContent(expansionTileKey);
                },
                title: Container(
                color : Get.theme.brightness==Brightness.dark? Colors.white: Colors.white , 
                  margin: EdgeInsets.only(top:20),
                  child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              (index + 1).toString() + ". ",style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black
                              ),
                            ),
                            SizedBox(
                              width: 0,
                            ),
                            Expanded(
                              child: Text(
                                controller.courseDetails.value.chapters[index].name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                              color: Colors.black

                                ),
                              ),
                            ),
                            total > 0
                                ? Text(
                                    getTimeString(total).toString() +
                                        " کاتژمێر",
                                        style: TextStyle(fontSize: 16),
                                  )
                                : SizedBox.shrink()
                          ],
                  ),
                ),
                children: <Widget>[
                        ListView.builder(
                            itemCount: lessons.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            itemBuilder: (BuildContext context, int index) {
                              if (lessons[index].isLock == 1) {
                                return InkWell(
                                  onTap: () {
                                    CustomSnackBar().snackBarWarning(
                                      "ئەم وانەیە قفڵ کراوە. ئەم کۆرسە بکڕە بۆ ئەوەی بە تەواوی دەستت پێێ بگات.",
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Icon(
                                                Icons.lock,
                                                color: Get.theme.primaryColor,
                                                size: 18,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: lessons[index].isQuiz == 1
                                                  ? Text(
                                                      lessons[index].quiz[0].title[
                                                              '${stctrl.code.value}'] ??
                                                          "",
                                                      style: Get.textTheme.subtitle2,
                                                    )
                                                  : Text(
                                                      lessons[index].name ?? "",
                                                      style: Get.textTheme.subtitle2,
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return InkWell(
                                  onTap: () async {
                                    if (lessons[index].isQuiz != 1) {
                                      context.loaderOverlay.show();
                                      final isVisible = context.loaderOverlay.visible;
                                      // print(isVisible);

                                      controller.selectedLessonID.value =
                                          lessons[index].id;

                                      if (lessons[index].host == "Vimeo") {
                                        var vimeoID = lessons[index]
                                            .videoUrl
                                            .replaceAll("/videos/", "");

                                        Get.bottomSheet(
                                          VimeoPlayerPage(
                                            lesson: lessons[index],
                                            videoTitle: "${lessons[index].name}",
                                            videoId: '$rootUrl/vimeo/video/$vimeoID',
                                          ),
                                          backgroundColor: Colors.black,
                                          isScrollControlled: true,
                                        );
                                        context.loaderOverlay.hide();
                                      } else if (lessons[index].host == "Youtube") {
                                        Get.bottomSheet(
                                          VideoPlayerPage(
                                            "Youtube",
                                            lesson: lessons[index],
                                            videoID: lessons[index].videoUrl,
                                          ),
                                          backgroundColor: Colors.black,
                                          isScrollControlled: true,
                                        );
                                        context.loaderOverlay.hide();
                                      } else if (lessons[index].host == "SCORM") {
                                        var videoUrl;
                                        videoUrl = rootUrl + lessons[index].videoUrl;

                                        final LessonController lessonController =
                                            Get.put(LessonController());

                                        await lessonController
                                            .updateLessonProgress(lessons[index].id,
                                                lessons[index].courseId, 1)
                                            .then((value) async {
                                          Get.bottomSheet(
                                            VimeoPlayerPage(
                                              lesson: lessons[index],
                                              videoTitle: lessons[index].name,
                                              videoId: '$videoUrl',
                                            ),
                                            backgroundColor: Colors.black,
                                            isScrollControlled: true,
                                          );
                                          context.loaderOverlay.hide();
                                        });
                                      } else if (lessons[index].host == "VdoCipher") {
                                        await generateVdoCipherOtp(
                                                lessons[index].videoUrl)
                                            .then((value) {
                                          if (value['otp'] != null) {
                                            final EmbedInfo embedInfo =
                                                EmbedInfo.streaming(
                                              otp: value['otp'],
                                              playbackInfo: value['playbackInfo'],
                                              embedInfoOptions: EmbedInfoOptions(
                                                autoplay: true,
                                              ),
                                            );

                                            Get.bottomSheet(
                                              VdoCipherPage(
                                                embedInfo: embedInfo,
                                              ),
                                              backgroundColor: Colors.black,
                                              isScrollControlled: true,
                                            );
                                            context.loaderOverlay.hide();
                                          } else {
                                            context.loaderOverlay.hide();
                                            CustomSnackBar()
                                                .snackBarWarning(value['message']);
                                          }
                                        });
                                      } else {
                                        var videoUrl;
                                        if (lessons[index].host == "Self") {
                                          videoUrl =
                                              rootUrl + "/" + lessons[index].videoUrl;
                                          Get.bottomSheet(
                                            VideoPlayerPage(
                                              "network",
                                              lesson: lessons[index],
                                              videoID: videoUrl,
                                            ),
                                            backgroundColor: Colors.black,
                                            isScrollControlled: true,
                                          );
                                          context.loaderOverlay.hide();
                                        } else if (lessons[index].host == "URL" ||
                                            lessons[index].host == "Iframe") {
                                          videoUrl = lessons[index].videoUrl;
                                          Get.bottomSheet(
                                            VideoPlayerPage(
                                              "network",
                                              lesson: lessons[index],
                                              videoID: videoUrl,
                                            ),
                                            backgroundColor: Colors.black,
                                            isScrollControlled: true,
                                          );
                                          context.loaderOverlay.hide();
                                        } else if (lessons[index].host == "PDF") {
                                          videoUrl =
                                              rootUrl + "/" + lessons[index].videoUrl;
                                          Get.to(() => PDFViewPage(
                                                pdfLink: videoUrl,
                                              ));
                                          context.loaderOverlay.hide();
                                        } else {
                                          videoUrl = lessons[index].videoUrl;

                                          String filePath;

                                          final extension = p.extension(videoUrl);

                                          Directory applicationSupportDir =
                                              await getApplicationSupportDirectory();
                                          String appSupportPath =
                                              applicationSupportDir.path;

                                          filePath =
                                              "$appSupportPath/${companyName}_${lessons[index].name}$extension";

                                          final isCheck =
                                              await OpenDocument.checkDocument(
                                                  filePath: filePath);

                                          debugPrint("Exist: $isCheck");

                                          if (isCheck) {
                                            context.loaderOverlay.hide();
                                            await OpenDocument.openDocument(
                                              filePath: filePath,
                                            );
                                          } else {
                                            final LessonController lessonController =
                                                Get.put(LessonController());

                                            // ignore: deprecated_member_use
                                            if (await canLaunch(
                                                rootUrl + '/' + videoUrl)) {
                                              await lessonController
                                                  .updateLessonProgress(
                                                      lessons[index].id,
                                                      lessons[index].courseId,
                                                      1)
                                                  .then((value) async {
                                                context.loaderOverlay.hide();
                                                final DownloadController
                                                    downloadController =
                                                    Get.put(DownloadController());
                                                Get.dialog(showDownloadAlertDialog(
                                                  context,
                                                  lessons[index].name ?? "",
                                                  videoUrl,
                                                  downloadController,
                                                ));
                                              });
                                            } else {
                                              context.loaderOverlay.hide();
                                              CustomSnackBar().snackBarError(
                                                  "${stctrl.lang["Unable to open"]}" +
                                                      " ${lessons[index].name}");
                                              // throw 'Unable to open url : ${rootUrl + '/' + videoUrl}';
                                            }
                                          }
                                        }
                                      }
                                    } else {
                                      CustomSnackBar().snackBarWarning(
                                        "ئەم وانەیە قفڵ کراوە. ئەم کۆرسە بکڕە بۆ ئەوەی بە تەواوی دەستت پێێ بگات.",
                                      );
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            lessons[index].isQuiz == 1
                                                ? Icon(
                                                    FontAwesomeIcons.questionCircle,
                                                    color: Get.theme.primaryColor,
                                                    size: 16,
                                                  )
                                                : !MediaUtils.isFile(
                                                        lessons[index].host)
                                                    ? Icon(
                                                        Icons.play_circle_outline,
                                                        color: Get.theme.primaryColor,
                                                        size: 16,
                                                      )
                                                    : Icon(
                                                        FontAwesomeIcons.file,
                                                        color: Get.theme.primaryColor,
                                                        size: 16,
                                                      ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: lessons[index].isQuiz == 1
                                                    ? Text(
                                                        lessons[index]
                                                                .quiz[0]
                                                                .title ??
                                                            "",
                                                        style:
                                                            Get.textTheme.subtitle2,
                                                      )
                                                    : Text(
                                                        lessons[index].name ?? "",
                                                        style:
                                                            Get.textTheme.subtitle2,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                ],
              );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                                   reviewWidget(controller, dashboardController),

                ],
              ),
            ),
          );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: dashboardController.loggedIn.value
          ? controller.isCourseBought.value
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
                  : Container(
                    width: MediaQuery.of(context).size.width*0.90,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFfb4611),
                        ),
                        child: Text(
                          "بەشداری کۆرس بکە",
                          style: Get.textTheme.subtitle2
                              .copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          dashboardController.loggedIn.value
                              ? addToCart(
                                  controller.courseDetails.value.id.toString())
                              : showCustomAlertDialog(
                                  "داخڵ بوون",
                                  "هێشتا داخلی هەژمار نەبویت",
                                  "تەماشای کارتەکەت بکە",
                                );
                        },
                      ),
                  )
          : Container(
            width: MediaQuery.of(context).size.width*0.90,
            child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                  dashboardController.changeTabIndex(1);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFfb4611),
                ),
                child: Text(
                  "هەمووی بەدەست بێنە",
                  style: Get.textTheme.subtitle2.copyWith(color: Colors.white,
                  fontSize: 20
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ),
    );
  }

  Container AddTextWidget(String txt) {
    return Container(
      height: 60,
      padding: EdgeInsets.all(6),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color.fromARGB(255, 219, 219, 219),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.add,
            color: Colors.black,
          ),
          Text(txt,
              style: TextStyle(
                  color: Color.fromARGB(255, 16, 16, 16),
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  fontFamily: "CodaRegular")),
        ],
      ),
    );
  }

  Row TextClick(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                text,
                style: TextStyle(
                    color: Color.fromARGB(255, 16, 16, 16),
                    fontFamily: "CodaRegular"),
                textAlign: TextAlign.right,
                maxLines: 2,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: EdgeInsets.only(right: 20),
            child: ClipOval(
                child: Icon(
              Icons.check,
              size: 30,
              color: Colors.grey,
            )),
            // CircleAvatar(
            //   radius: 30.0,
            //   backgroundColor: Color(0xFFD7598F),
            //   backgroundImage: NetworkImage(
            //     '$rootUrl/${controller.courseDetails.value.image}',

            //   ),
            // ),
          ),
        ),
      ],
    );
  }

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
      // cartController.cartList = [].obs;
      cartController.getCartList();
      controller.courseID.value = controller.courseDetails.value.id;
      controller.getCourseDetails();
      return message;
    } else {
      //show error message
      return "Somthing Wrong";
    }
  }

  Widget descriptionWidget(
      HomeController controller, DashboardController dashboardController) {
    return extend.NestedScrollViewInnerScrollPositionKeyWidget(
      const Key('Tab1'),
      Scaffold(
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            Container(
              width: percentageWidth * 100,
              padding: EdgeInsets.fromLTRB(0, percentageHeight * 3, 0, 0),
              child: HtmlWidget(
                '''
                ${controller.courseDetails.value.about['${stctrl.code.value}'] ?? "${controller.courseDetails.value.about['en']}"}
                ''',
                customStylesBuilder: (element) {
                  if (element.classes.contains('foo')) {
                    return {'color': 'red'};
                  }
                  return null;
                },
                customWidgetBuilder: (element) {
                  if (element.attributes['foo'] == 'bar') {
                    // return FooBarWidget();
                  }
                  return null;
                },
                textStyle: Get.textTheme.subtitle2,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "دەرەنجام",
              style: Get.textTheme.subtitle2,
            ),
            Container(
              width: percentageWidth * 100,
              padding: EdgeInsets.fromLTRB(0, percentageHeight * 3, 0, 0),
              child: HtmlWidget(
                '''
                ${controller.courseDetails.value.outcomes['${stctrl.code.value}'] ?? "${controller.courseDetails.value.outcomes['en']}" ?? "${controller.courseDetails.value.outcomes['en']}"}
                ''',
                customStylesBuilder: (element) {
                  if (element.classes.contains('foo')) {
                    return {'color': 'red'};
                  }
                  return null;
                },
                customWidgetBuilder: (element) {
                  if (element.attributes['foo'] == 'bar') {
                    // return FooBarWidget();
                  }
                  return null;
                },
                textStyle: Get.textTheme.subtitle2,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "پێداویستییەکان",
              style: Get.textTheme.subtitle2,
            ),
            Container(
              width: percentageWidth * 100,
              // height: percentageHeight * 25,
              padding: EdgeInsets.fromLTRB(0, percentageHeight * 3, 0, 0),
              child: HtmlWidget(
                '''
                ${controller.courseDetails.value.requirements['${stctrl.code.value}'] ?? "" ?? ""}
                ''',
                customStylesBuilder: (element) {
                  if (element.classes.contains('foo')) {
                    return {'color': 'red'};
                  }
                  return null;
                },
                customWidgetBuilder: (element) {
                  if (element.attributes['foo'] == 'bar') {
                    // return FooBarWidget();
                  }
                  return null;
                },
                textStyle: Get.textTheme.subtitle2,
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: dashboardController.loggedIn.value
            ? controller.isCourseBought.value
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
                    : Container(
                    width: MediaQuery.of(context).size.width*0.90,

                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFfb4611),
                          ),
                          child: Text(
                            "بەشداری کۆرس بکە",
                            style: Get.textTheme.subtitle2
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            dashboardController.loggedIn.value
                                ? addToCart(
                                    controller.courseDetails.value.id.toString())
                                : showCustomAlertDialog(
                                    "داخڵ بوون",
                                    "هێشتا داخلی هەژمار نەبویت",
                                    "تەماشای کارتەکەت بکە",
                                  );
                          },
                        ),
                    )
            : Container(
            width: MediaQuery.of(context).size.width*0.90,
              child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                    dashboardController.changeTabIndex(1);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFfb4611),
                  ),
                  child: Text(
                    "هەمووی بەدەست بێنە",
                    style: Get.textTheme.subtitle2.copyWith(color: Colors.white,
                     fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
            ),
      ),
    );
  }

  Widget curriculumWidget(
      HomeController controller, DashboardController dashboardController) {
    void _scrollToSelectedContent(GlobalKey myKey) {
      final keyContext = myKey.currentContext;

      if (keyContext != null) {
        Future.delayed(Duration(milliseconds: 200)).then((value) {
          Scrollable.ensureVisible(keyContext,
              duration: Duration(milliseconds: 200));
        });
      }
    }

    return extend.NestedScrollViewInnerScrollPositionKeyWidget(
        const Key('Tab2'),
        Scaffold(
          body: ListView.separated(
            itemCount: controller.courseDetails.value.chapters.length,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 4,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              var lessons = controller.courseDetails.value.lessons
                  .where((element) =>
                      int.parse(element.chapterId.toString()) ==
                      int.parse(controller
                          .courseDetails.value.chapters[index].id
                          .toString()))
                  .toList();
              var total = 0;
              lessons.forEach((element) {
                if (element.duration != null && element.duration != "") {
                  if (!element.duration.contains("H")) {
                    total += double.parse(element.duration).toInt();
                  }
                }
              });
              final GlobalKey expansionTileKey = GlobalKey();
              return CustomExpansionTileCard(
                key: expansionTileKey,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                onExpansionChanged: (isExpanded) {
                  if (isExpanded) _scrollToSelectedContent(expansionTileKey);
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      (index + 1).toString() + ". ",
                    ),
                    SizedBox(
                      width: 0,
                    ),
                    Expanded(
                      child: Text(
                        controller.courseDetails.value.chapters[index].name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    total > 0
                        ? Text(
                            getTimeString(total).toString() +
                                " کاتژمێر",
                          )
                        : SizedBox.shrink()
                  ],
                ),
                children: <Widget>[
                  ListView.builder(
                      itemCount: lessons.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (BuildContext context, int index) {
                        if (lessons[index].isLock == 1) {
                          return InkWell(
                            onTap: () {
                              CustomSnackBar().snackBarWarning(
                                "ئەم وانەیە قفڵ کراوە. ئەم کۆرسە بکڕە بۆ ئەوەی بە تەواوی دەستت پێێ بگات.",
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Icon(
                                          Icons.lock,
                                          color: Get.theme.primaryColor,
                                          size: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: lessons[index].isQuiz == 1
                                            ? Text(
                                                lessons[index].quiz[0].title[
                                                        '${stctrl.code.value}'] ??
                                                    "",
                                                style: Get.textTheme.subtitle2,
                                              )
                                            : Text(
                                                lessons[index].name ?? "",
                                                style: Get.textTheme.subtitle2,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap: () async {
                              if (lessons[index].isQuiz != 1) {
                                context.loaderOverlay.show();
                                final isVisible = context.loaderOverlay.visible;
                                // print(isVisible);

                                controller.selectedLessonID.value =
                                    lessons[index].id;

                                if (lessons[index].host == "Vimeo") {
                                  var vimeoID = lessons[index]
                                      .videoUrl
                                      .replaceAll("/videos/", "");

                                  Get.bottomSheet(
                                    VimeoPlayerPage(
                                      lesson: lessons[index],
                                      videoTitle: "${lessons[index].name}",
                                      videoId: '$rootUrl/vimeo/video/$vimeoID',
                                    ),
                                    backgroundColor: Colors.black,
                                    isScrollControlled: true,
                                  );
                                  context.loaderOverlay.hide();
                                } else if (lessons[index].host == "Youtube") {
                                  Get.bottomSheet(
                                    VideoPlayerPage(
                                      "Youtube",
                                      lesson: lessons[index],
                                      videoID: lessons[index].videoUrl,
                                    ),
                                    backgroundColor: Colors.black,
                                    isScrollControlled: true,
                                  );
                                  context.loaderOverlay.hide();
                                } else if (lessons[index].host == "SCORM") {
                                  var videoUrl;
                                  videoUrl = rootUrl + lessons[index].videoUrl;

                                  final LessonController lessonController =
                                      Get.put(LessonController());

                                  await lessonController
                                      .updateLessonProgress(lessons[index].id,
                                          lessons[index].courseId, 1)
                                      .then((value) async {
                                    Get.bottomSheet(
                                      VimeoPlayerPage(
                                        lesson: lessons[index],
                                        videoTitle: lessons[index].name,
                                        videoId: '$videoUrl',
                                      ),
                                      backgroundColor: Colors.black,
                                      isScrollControlled: true,
                                    );
                                    context.loaderOverlay.hide();
                                  });
                                } else if (lessons[index].host == "VdoCipher") {
                                  await generateVdoCipherOtp(
                                          lessons[index].videoUrl)
                                      .then((value) {
                                    if (value['otp'] != null) {
                                      final EmbedInfo embedInfo =
                                          EmbedInfo.streaming(
                                        otp: value['otp'],
                                        playbackInfo: value['playbackInfo'],
                                        embedInfoOptions: EmbedInfoOptions(
                                          autoplay: true,
                                        ),
                                      );

                                      Get.bottomSheet(
                                        VdoCipherPage(
                                          embedInfo: embedInfo,
                                        ),
                                        backgroundColor: Colors.black,
                                        isScrollControlled: true,
                                      );
                                      context.loaderOverlay.hide();
                                    } else {
                                      context.loaderOverlay.hide();
                                      CustomSnackBar()
                                          .snackBarWarning(value['message']);
                                    }
                                  });
                                } else {
                                  var videoUrl;
                                  if (lessons[index].host == "Self") {
                                    videoUrl =
                                        rootUrl + "/" + lessons[index].videoUrl;
                                    Get.bottomSheet(
                                      VideoPlayerPage(
                                        "network",
                                        lesson: lessons[index],
                                        videoID: videoUrl,
                                      ),
                                      backgroundColor: Colors.black,
                                      isScrollControlled: true,
                                    );
                                    context.loaderOverlay.hide();
                                  } else if (lessons[index].host == "URL" ||
                                      lessons[index].host == "Iframe") {
                                    videoUrl = lessons[index].videoUrl;
                                    Get.bottomSheet(
                                      VideoPlayerPage(
                                        "network",
                                        lesson: lessons[index],
                                        videoID: videoUrl,
                                      ),
                                      backgroundColor: Colors.black,
                                      isScrollControlled: true,
                                    );
                                    context.loaderOverlay.hide();
                                  } else if (lessons[index].host == "PDF") {
                                    videoUrl =
                                        rootUrl + "/" + lessons[index].videoUrl;
                                    Get.to(() => PDFViewPage(
                                          pdfLink: videoUrl,
                                        ));
                                    context.loaderOverlay.hide();
                                  } else {
                                    videoUrl = lessons[index].videoUrl;

                                    String filePath;

                                    final extension = p.extension(videoUrl);

                                    Directory applicationSupportDir =
                                        await getApplicationSupportDirectory();
                                    String appSupportPath =
                                        applicationSupportDir.path;

                                    filePath =
                                        "$appSupportPath/${companyName}_${lessons[index].name}$extension";

                                    final isCheck =
                                        await OpenDocument.checkDocument(
                                            filePath: filePath);

                                    debugPrint("Exist: $isCheck");

                                    if (isCheck) {
                                      context.loaderOverlay.hide();
                                      await OpenDocument.openDocument(
                                        filePath: filePath,
                                      );
                                    } else {
                                      final LessonController lessonController =
                                          Get.put(LessonController());

                                      // ignore: deprecated_member_use
                                      if (await canLaunch(
                                          rootUrl + '/' + videoUrl)) {
                                        await lessonController
                                            .updateLessonProgress(
                                                lessons[index].id,
                                                lessons[index].courseId,
                                                1)
                                            .then((value) async {
                                          context.loaderOverlay.hide();
                                          final DownloadController
                                              downloadController =
                                              Get.put(DownloadController());
                                          Get.dialog(showDownloadAlertDialog(
                                            context,
                                            lessons[index].name ?? "",
                                            videoUrl,
                                            downloadController,
                                          ));
                                        });
                                      } else {
                                        context.loaderOverlay.hide();
                                        CustomSnackBar().snackBarError(
                                            "${stctrl.lang["Unable to open"]}" +
                                                " ${lessons[index].name}");
                                        // throw 'Unable to open url : ${rootUrl + '/' + videoUrl}';
                                      }
                                    }
                                  }
                                }
                              } else {
                                CustomSnackBar().snackBarWarning(
                                  "ئەم وانەیە قفڵ کراوە. ئەم کۆرسە بکڕە بۆ ئەوەی بە تەواوی دەستت پێێ بگات.",
                                );
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      lessons[index].isQuiz == 1
                                          ? Icon(
                                              FontAwesomeIcons.questionCircle,
                                              color: Get.theme.primaryColor,
                                              size: 16,
                                            )
                                          : !MediaUtils.isFile(
                                                  lessons[index].host)
                                              ? Icon(
                                                  Icons.play_circle_outline,
                                                  color: Get.theme.primaryColor,
                                                  size: 16,
                                                )
                                              : Icon(
                                                  FontAwesomeIcons.file,
                                                  color: Get.theme.primaryColor,
                                                  size: 16,
                                                ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: lessons[index].isQuiz == 1
                                              ? Text(
                                                  lessons[index]
                                                          .quiz[0]
                                                          .title ??
                                                      "",
                                                  style:
                                                      Get.textTheme.subtitle2,
                                                )
                                              : Text(
                                                  lessons[index].name ?? "",
                                                  style:
                                                      Get.textTheme.subtitle2,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                ],
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: dashboardController.loggedIn.value
              ? controller.isCourseBought.value
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
                      : Container(
                    width: MediaQuery.of(context).size.width*0.90,

                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFfb4611),
                            ),
                            child: Text(
                              "بەشداری کۆرس بکە",
                              style: Get.textTheme.subtitle2
                                  .copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              dashboardController.loggedIn.value
                                  ? addToCart(controller.courseDetails.value.id
                                      .toString())
                                  : showCustomAlertDialog(
                                      "داخڵ بوون",
                                      "هێشتا داخلی هەژمار نەبویت",
                                      "تەماشای کارتەکەت بکە",
                                    );
                            },
                          ),
                      )
              : Container(
            width: MediaQuery.of(context).size.width*0.90,
                child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.back();
                      dashboardController.changeTabIndex(1);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFfb4611),
                    ),
                    child: Text(
                      "هەمووی بەدەست بێنە",
                      style:
                          Get.textTheme.subtitle2.copyWith(color: Colors.white,
                           fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ),
        ));
  }

  showDownloadAlertDialog(BuildContext context, String title, String fileUrl,
      DownloadController downloadController) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("نەخێر"),
      onPressed: () {
        context.loaderOverlay.hide();
        Navigator.of(Get.overlayContext).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Text("داونلۆد"),
      onPressed: () async {
        context.loaderOverlay.hide();
        Navigator.of(Get.overlayContext).pop();
        downloadController.downloadFile(fileUrl, title, context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "$title",
        style: Get.textTheme.subtitle1,
      ),
      content: Text("دەتەوێت ئەم فایلە داونلۆد بکەیت؟"),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    return alert;
  }

  Widget reviewWidget(
      HomeController controller, DashboardController dashboardController) {
    return extend.NestedScrollViewInnerScrollPositionKeyWidget(
        const Key('Tab4'),
        Container(
                color: Colors.white,

          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              Container(
                  child: Center(
                      child: Align(
                                 alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.only(left:30,right:20),
                                  child: Text(
                "هەڵسەنگاندنی بەکارهێنەران ",
                style: TextStyle(
                    color : Get.theme.brightness==Brightness.dark? Colors.black : Colors.black , fontFamily: "DynaPuff",   fontWeight: FontWeight.w900,
                                              fontSize: 25,),
              ))))),
              SizedBox(height: 10),
              GestureDetector(
                child: Container(
                  
                  width: percentageWidth * 100,
                  height: percentageHeight * 6,
                  padding: EdgeInsets.fromLTRB(20, 0, 30, 0),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                       color: Get.theme.brightness==Brightness.dark? Colors.white : Colors.white ,
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
                                                        ? NetworkImage(
                                                            "$rootUrl/${dashboardController.profileData.image ?? ""}")
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
                                              controller.courseDetails.value.id,
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
                                            style:
                                                Get.textTheme.subtitle2.copyWith(
                                              color: Colors.white,
                                            ),
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
              controller.courseDetails.value.reviews.length == 0
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(
                        "هیچ پێداچونەوەیەک نەدۆزرایەوە",
                        style: Get.textTheme.subtitle2,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.courseDetails.value.reviews.length,
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
                                  controller.courseDetails.value.reviews[index]
                                          .userImage
                                          .contains('public/')
                                      ? CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Color(0xFFD7598F),
                                          backgroundImage: NetworkImage(
                                              "$rootUrl/${controller.courseDetails.value.reviews[index].userImage}"))
                                      : CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Color(0xFFD7598F),
                                          backgroundImage: NetworkImage(
                                            controller.courseDetails.value
                                                .reviews[index].userImage,
                                          )),
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
                                              cartTotal(controller.courseDetails
                                                  .value.reviews[index].userName),
                                              Expanded(
                                                child: Container(),
                                              ),
                                              StarCounterWidget(
                                                value: controller.courseDetails
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
                                                .courseDetails
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
          ),
        ));
  }

  Future generateVdoCipherOtp(url) async {
    Uri apiUrl = Uri.parse('https://dev.vdocipher.com/api/videos/$url/otp');

    var response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Apisecret $vdoCipherApiKey'
      },
    );
    var decoded = jsonDecode(response.body);
    return decoded;
  }
}
