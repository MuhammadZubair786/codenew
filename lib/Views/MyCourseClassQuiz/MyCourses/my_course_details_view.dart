// Dart imports:
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:html/parser.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms_flutter_app/Controller/lesson_controller.dart';
import 'package:lms_flutter_app/Controller/quiz_controller.dart';
import 'package:lms_flutter_app/Controller/site_controller.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';
import 'package:lms_flutter_app/Model/Course/FileElement.dart';
import 'package:lms_flutter_app/Service/permission_service.dart';
import 'package:lms_flutter_app/Views/Downloads/DownloadsFolder.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyQuiz/start_quiz_page.dart';
import 'package:lms_flutter_app/Views/VideoView/PDFViewPage.dart';
import 'package:lms_flutter_app/utils/CustomExpansionTileCard.dart';

import 'package:lms_flutter_app/utils/CustomSnackBar.dart';
import 'package:lms_flutter_app/utils/MediaUtils.dart';
import 'package:lms_flutter_app/utils/SliverAppBarTitleWidget.dart';
import 'package:lms_flutter_app/utils/widgets/StarCounterWidget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:open_document/open_document.dart';

import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/download_controller.dart';
import 'package:lms_flutter_app/Controller/myCourse_controller.dart';
import 'package:lms_flutter_app/Controller/my_course_details_tab_controller.dart';
import 'package:lms_flutter_app/Views/VideoView/VideoChipherPage.dart';

import 'package:lms_flutter_app/Views/VideoView/VimeoPlayerPage.dart';
import 'package:lms_flutter_app/Views/VideoView/VideoPlayerPage.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/styles.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;

import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

// ignore: must_be_immutable
class MyCourseDetailsView extends StatefulWidget {
  @override
  _MyCourseDetailsViewState createState() => _MyCourseDetailsViewState();
}

class _MyCourseDetailsViewState extends State<MyCourseDetailsView> {
  final SiteController _stctrl = Get.put(SiteController());
  final MyCourseController controller = Get.put(MyCourseController());

  final HomeController controller1 = Get.put(HomeController());
  GetStorage userToken = GetStorage();

  String tokenKey = "token";

  double width;

  double percentageWidth;

  double height;

  double percentageHeight;

  bool playing = false;

  String youtubeID = "";

  var progress = "داونلۆد";

  var received;
  var Instructor = [];
  math.Random random = math.Random();

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

  void initCheckPermission() async {
    final _handler = PermissionsService();
    await _handler.requestPermission(
      Permission.storage,
      onPermissionDenied: () => setState(
        () => debugPrint("Error: "),
      ),
    );
  }

  @override
  void dispose() {
    controller.commentController.text = "";
    controller.selectedLessonID.value = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyCourseDetailsTabController _tabx =
        Get.put(MyCourseDetailsTabController());

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
            controller.myCourseDetails.value.title['${stctrl.code.value}'] ??
                "${controller.myCourseDetails.value.title['en']}"),
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
          if (controller.isMyCourseLoading.value)
            return Center(
              child: CupertinoActivityIndicator(),
            );
          return extend.NestedScrollView(
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
                            controller.myCourseDetails.value
                                    .title['${stctrl.code.value}'] ??
                                "${controller.myCourseDetails.value.title['en']}",
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
                                '${rootUrl + '/' + controller.myCourseDetails.value.image}'),
                            placeholder: AssetImage('images/fcimg.png'),
                            fit: BoxFit.cover,
                          ),
                          // Container(
                          //   padding: EdgeInsets.symmetric(horizontal: 26),
                          //   color: Colors.black.withOpacity(0.7),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       GestureDetector(
                          //         onTap: () => Get.back(),
                          //         child: Row(
                          //           children: [
                          //             Icon(
                          //               Icons.arrow_back_outlined,
                          //               color: Colors.white,
                          //             ),
                          //             Text(
                          //               "گەڕانەوە",
                          //               style: TextStyle(
                          //                   fontSize: 15,
                          //                   fontWeight: FontWeight.w500,
                          //                   color: Colors.white),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         height: 30,
                          //       ),
                          //       courseDescriptionTitle(controller
                          //               .myCourseDetails
                          //               .value
                          //               .title['${_stctrl.code.value}'] ??
                          //           ""),
                          //       courseDescriptionPublisher(
                          //           controller.myCourseDetails.value.user.name),
                          //       Row(
                          //         children: [
                          //           Expanded(
                          //             child: Column(
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //               children: [
                          //                 StarCounterWidget(
                          //                   value: double.parse(controller
                          //                       .myCourseDetails.value.review
                          //                       .toString()),
                          //                   color: Color(0xffFFCF23),
                          //                   size: 10,
                          //                 ),
                          //                 SizedBox(
                          //                   height: percentageHeight * 1,
                          //                 ),
                          //                 courseDescriptionPublisher('(' +
                          //                     controller
                          //                         .myCourseDetails.value.review
                          //                         .toString() +
                          //                     ') ' +
                          //                     "لەسەر بنەمای" +
                          //                     ' ' +
                          //                     controller.myCourseDetails.value
                          //                         .reviews.length
                          //                         .toString() +
                          //                     ' ' +
                          //                     "پێداچونەوە"),
                          //               ],
                          //             ),
                          //           ),
                          //           controller.myCourseDetails.value
                          //                           .trailerLink !=
                          //                       null &&
                          //                   controller.myCourseDetails.value
                          //                           .host !=
                          //                       "ImagePreview"
                          //               ? GestureDetector(
                          //                   child: CircleAvatar(
                          //                       radius: 20.0,
                          //                       backgroundColor:
                          //                           Color(0xFFD7598F),
                          //                       child: ClipRRect(
                          //                         child: Icon(
                          //                           Icons.play_arrow,
                          //                           size: 22,
                          //                           color: Colors.white,
                          //                         ),
                          //                         borderRadius:
                          //                             BorderRadius.circular(
                          //                                 20.0),
                          //                       )),
                          //                   onTap: () async {
                          //                     if (controller.myCourseDetails
                          //                             .value.host ==
                          //                         "Vimeo") {
                          //                       var vimeoID = controller
                          //                           .myCourseDetails
                          //                           .value
                          //                           .trailerLink
                          //                           .replaceAll("/videos/", "");

                          //                       Get.bottomSheet(
                          //                         VimeoPlayerPage(
                          //                           videoTitle:
                          //                               "${controller.myCourseDetails.value.title}",
                          //                           videoId:
                          //                               '$rootUrl/vimeo/video/$vimeoID',
                          //                         ),
                          //                         backgroundColor: Colors.black,
                          //                         isScrollControlled: true,
                          //                       );
                          //                     } else if (controller
                          //                             .myCourseDetails
                          //                             .value
                          //                             .host ==
                          //                         "Youtube") {
                          //                       Get.bottomSheet(
                          //                         VideoPlayerPage(
                          //                           "Youtube",
                          //                           videoID: controller
                          //                               .myCourseDetails
                          //                               .value
                          //                               .trailerLink,
                          //                         ),
                          //                         backgroundColor: Colors.black,
                          //                         isScrollControlled: true,
                          //                       );
                          //                     } else if (controller
                          //                             .myCourseDetails
                          //                             .value
                          //                             .host ==
                          //                         "VdoCipher") {
                          //                       await generateVdoCipherOtp(
                          //                               controller
                          //                                   .myCourseDetails
                          //                                   .value
                          //                                   .trailerLink)
                          //                           .then((value) {
                          //                         if (value['otp'] != null) {
                          //                           final EmbedInfo embedInfo =
                          //                               EmbedInfo.streaming(
                          //                             otp: value['otp'],
                          //                             playbackInfo:
                          //                                 value['playbackInfo'],
                          //                             embedInfoOptions:
                          //                                 EmbedInfoOptions(
                          //                               autoplay: true,
                          //                             ),
                          //                           );

                          //                           Get.bottomSheet(
                          //                             VdoCipherPage(
                          //                               embedInfo: embedInfo,
                          //                             ),
                          //                             backgroundColor:
                          //                                 Colors.black,
                          //                             isScrollControlled: true,
                          //                           );
                          //                           context.loaderOverlay
                          //                               .hide();
                          //                         } else {
                          //                           context.loaderOverlay
                          //                               .hide();
                          //                           CustomSnackBar()
                          //                               .snackBarWarning(
                          //                                   value['message']);
                          //                         }
                          //                       });
                          //                     } else {
                          //                       // ignore: unused_local_variable
                          //                       var videoUrl;
                          //                       if (controller.myCourseDetails
                          //                               .value.host ==
                          //                           "Self") {
                          //                         videoUrl = rootUrl +
                          //                             "/" +
                          //                             controller.myCourseDetails
                          //                                 .value.trailerLink;
                          //                       }
                          //                       Get.bottomSheet(
                          //                         VideoPlayerPage("network"
                          //                             // videoTitle: controller
                          //                             //     .myCourseDetails
                          //                             //     .value
                          //                             //
                          //                             //     .title,
                          //                             // videoUrl: videoUrl,

                          //                             ),
                          //                         backgroundColor: Colors.black,
                          //                         isScrollControlled: true,
                          //                       );
                          //                     }
                          //                   },
                          //                 )
                          //               : Container()
                          //         ],
                          //       ),
                          //       SizedBox(
                          //         height: percentageHeight * 1.5,
                          //       ),
                          //       Row(
                          //         children: [
                          //           Container(
                          //             padding: EdgeInsets.symmetric(
                          //                 horizontal: 10, vertical: 10),
                          //             decoration: BoxDecoration(
                          //               color: Get.theme.cardColor,
                          //               shape: BoxShape.rectangle,
                          //               borderRadius: BorderRadius.circular(5),
                          //             ),
                          //             child: Row(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.spaceEvenly,
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //               children: [
                          //                 Icon(
                          //                   Icons.access_time,
                          //                   color: Get.theme.primaryColor,
                          //                   size: 14,
                          //                 ),
                          //                 SizedBox(
                          //                   width: 1,
                          //                 ),
                          //                 controller.myCourseDetails.value
                          //                             .duration ==
                          //                         "5H"
                          //                     ? courseStructure('05:00 Hr(s)')
                          //                     : courseStructure(
                          //                         getTimeString(int.parse(
                          //                                     controller
                          //                                         .myCourseDetails
                          //                                         .value
                          //                                         .duration))
                          //                                 .toString() +
                          //                             " کاتژمێر",
                          //                       ),
                          //               ],
                          //             ),
                          //           ),
                          //           Expanded(child: Container()),
                          //           Container(
                          //             padding: EdgeInsets.symmetric(
                          //                 horizontal: 10, vertical: 10),
                          //             decoration: BoxDecoration(
                          //               color: Get.theme.cardColor,
                          //               shape: BoxShape.rectangle,
                          //               borderRadius: BorderRadius.circular(5),
                          //             ),
                          //             child: Row(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.spaceEvenly,
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //               children: [
                          //                 Icon(
                          //                   Icons.insert_chart_sharp,
                          //                   color: Get.theme.primaryColor,
                          //                   size: 14,
                          //                 ),
                          //                 SizedBox(
                          //                   width: 5,
                          //                 ),
                          //                 courseStructure(controller
                          //                             .myCourseDetails
                          //                             .value
                          //                             .level ==
                          //                         1
                          //                     ? "ئاستی سەرەتایی"
                          //                     : controller.myCourseDetails.value
                          //                                 .level ==
                          //                             2
                          //                         ? "ئاستی مام ناوەند"
                          //                         : controller.myCourseDetails
                          //                                     .value.level ==
                          //                                 3
                          //                             ? "ئاستی پێشکەوتوو"
                          //                             : controller
                          //                                         .myCourseDetails
                          //                                         .value
                          //                                         .level ==
                          //                                     4
                          //                                 ? "ئاستی پرۆ"
                          //                                 : ""),
                          //               ],
                          //             ),
                          //           ),
                          //           Expanded(child: Container()),
                          //           Container(
                          //             padding: EdgeInsets.symmetric(
                          //                 horizontal: 10, vertical: 10),
                          //             decoration: BoxDecoration(
                          //               color: Get.theme.cardColor,
                          //               shape: BoxShape.rectangle,
                          //               borderRadius: BorderRadius.circular(5),
                          //             ),
                          //             child: Row(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.spaceEvenly,
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //               children: [
                          //                 Icon(
                          //                   Icons.person_add_alt_1,
                          //                   color: Get.theme.primaryColor,
                          //                   size: 14,
                          //                 ),
                          //                 SizedBox(
                          //                   width: 5,
                          //                 ),
                          //                 courseStructure(controller
                          //                     .myCourseDetails
                          //                     .value
                          //                     .totalEnrolled
                          //                     .toString()),
                          //               ],
                          //             ),
                          //           ),
                          //         ],
                          //       )
                          //     ],
                          //   ),
                          // ),
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
                          width: 0.1,
                          color: Color.fromARGB(255, 128, 128, 128),
                        ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                            child: ContainercourseDescriptionTitle(
                          controller.myCourseDetails.value
                                  .title['${stctrl.code.value}'] ??
                              "${controller.myCourseDetails.value.title['en']}",
                        )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //  ElevatedButton(onPressed: (){
                      //   print(controller.myCourseDetails.value);
                      //  }, child: Text("Ok")),

                      Divider(
                        height: 0.1,
                        color: Color.fromARGB(255, 182, 182, 182),
                      ),

                      Container(
                          height: 93,
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
                                        Text("ئاست ",
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
                                        controller.myCourseDetails.value.level.toString() == "1" ? 
                                      Text(
                                        "دەستپێکەران"
                                       ,
                                        style: TextStyle(
                                           fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 71, 71, 71)),
                                      ):
                                      controller.myCourseDetails.value.level.toString() == "2" ? 
                                       Text(
                                        "مام ناوەند"
                                       ,
                                        style: TextStyle(
                                           fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 71, 71, 71)),
                                      ):
                                      controller.myCourseDetails.value.level.toString() == "3" ? 
                                       Text(
                                        "پێشکەوتوو"
                                       ,
                                        style: TextStyle(
                                           fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 71, 71, 71)),
                                      ):
                                       controller.myCourseDetails.value.level.toString() == "4" ? 
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

                                    ],
                                  )),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.20,
                                child: VerticalDivider(
                                  color: Color.fromARGB(255, 182, 182, 182),
                                  thickness: 1,
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
                                       controller.myCourseDetails.value.totalEnrolled.toString(),
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
                                thickness: 1,
                              ),
                              Container(
                                padding: stctrl.code=='ar' ?  
                                EdgeInsets.only(left: 17,top: 6,right: 7):EdgeInsets.only(left: 0,top: 5),
                                // width: MediaQuery.of(context).size.width*0.20,
                                child: Column(
                                  children: [
                                    Text("هەڵسەنگاندن ",
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
                                          controller.myCourseDetails.value.review.toString(),
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
                            color: Colors.grey.withOpacity(0.0),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(4, 8), // changes position of shadow
                          ),
                        ],),
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 2),
                          child: Center(
                            child: Text("زانیاری مامۆستا",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 16, 16, 16),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                    fontFamily: "CodaRegular")),
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
                                          '$rootUrl/${controller.myCourseDetails.value.user.image}',
                                          width: 80,
                                          height: 80,
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
                                              .myCourseDetails.value.user.name,
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
                                                .myCourseDetails
                                                .value
                                                .user
                                                .about),
                                            style: TextStyle(
                                                fontSize: 8,
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
                  height: 20,
                ),
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
                  padding: EdgeInsets.zero,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabx.controller,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      curriculumWidget(controller),
                      filesWidget(controller),
                      questionsAnswerWidget(controller),
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget curriculumWidget(
    MyCourseController controller,
  ) {
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
      const Key('curriculumWidget'),
      ListView.separated(
        itemCount: controller.myCourseDetails.value.chapters.length,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 4,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          var lessons = controller.myCourseDetails.value.lessons
              .where((element) =>
                  int.parse(element.chapterId.toString()) ==
                  int.parse(controller.myCourseDetails.value.chapters[index].id
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
                    controller.myCourseDetails.value.chapters[index].name,
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
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  itemBuilder: (BuildContext context, int index) {
                    return Obx(() {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: controller.selectedLessonID.value ==
                                    lessons[index].id
                                ? Get.theme.primaryColor
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: lessons[index].isQuiz == 1
                            ? InkWell(
                                onTap: () async {
                                  controller.selectedLessonID.value =
                                      lessons[index].id;
                                  context.loaderOverlay.show();
                                  final QuizController quizController =
                                      Get.put(QuizController());

                                  quizController.lessonQuizId.value =
                                      lessons[index].quizId;
                                  quizController.courseID.value =
                                      controller.courseID.value;

                                  await quizController
                                      .getLessonQuizDetails()
                                      .then((value) {
                                    context.loaderOverlay.hide();
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
                                          quizController.myQuizDetails.value
                                                      .quiz.questionTimeType ==
                                                  0
                                              ? courseStructure(
                                                  "کاتی کویز" +
                                                      ": " +
                                                      quizController
                                                          .myQuizDetails
                                                          .value
                                                          .quiz
                                                          .questionTime
                                                          .toString() +
                                                      " "
                                                          "دەقە بۆ هەر پرسیارێک",
                                                )
                                              : courseStructure(
                                                  "کاتی کویز" +
                                                      ": " +
                                                      quizController
                                                          .myQuizDetails
                                                          .value
                                                          .quiz
                                                          .questionTime
                                                          .toString() +
                                                      "دەقە",
                                                ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Text(
                                                    "${stctrl.lang["Cancel"]}",
                                                    style:
                                                        Get.textTheme.subtitle1,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              Obx(() {
                                                return quizController
                                                        .isQuizStarting.value
                                                    ? Container(
                                                        width: 100,
                                                        height:
                                                            percentageHeight *
                                                                5,
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            CupertinoActivityIndicator())
                                                    : ElevatedButton(
                                                        onPressed: () async {
                                                          await quizController
                                                              .startQuizFromLesson()
                                                              .then((value) {
                                                            if (value) {
                                                              Get.back();
                                                              Get.to(() => StartQuizPage(
                                                                  getQuizDetails:
                                                                      quizController
                                                                          .myQuizDetails
                                                                          .value));
                                                            } else {
                                                              Get.snackbar(
                                                                "هەڵە",
                                                                "دەتەوێت کویزەکە دەست پێ بکەیت؟",
                                                                snackPosition:
                                                                    SnackPosition
                                                                        .BOTTOM,
                                                                backgroundColor:
                                                                    Colors.red,
                                                                colorText:
                                                                    Colors
                                                                        .black,
                                                                borderRadius: 5,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                              );
                                                            }
                                                          });
                                                        },
                                                        child: Text(
                                                          "دەست پێ کردن",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xffffffff),
                                                              height: 1.3,
                                                              fontFamily:
                                                                  'AvenirNext'),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      );
                                              })
                                            ],
                                          ),
                                        ],
                                      ),
                                      radius: 5,
                                    );
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.questionCircle,
                                        color: Get.theme.primaryColor,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(
                                              lessons[index].quiz[0].title ??
                                                  "",
                                              style: Get.textTheme.subtitle2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  context.loaderOverlay.show();
                                  final isVisible =
                                      context.loaderOverlay.visible;
                                  print(isVisible);

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
                                        videoId:
                                            '$rootUrl/vimeo/video/$vimeoID',
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
                                    videoUrl =
                                        rootUrl + lessons[index].videoUrl;

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
                                  } else if (lessons[index].host ==
                                      "VdoCipher") {
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
                                            lesson: lessons[index],
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
                                      videoUrl = rootUrl +
                                          "/" +
                                          lessons[index].videoUrl;
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
                                      videoUrl = rootUrl +
                                          "/" +
                                          lessons[index].videoUrl;
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
                                      String folderPath =
                                          applicationSupportDir.path;

                                      filePath =
                                          "$folderPath/${companyName}_${lessons[index].name}$extension";

                                      final isCheck =
                                          await OpenDocument.checkDocument(
                                              filePath: filePath);

                                      debugPrint("Exist: $isCheck");

                                      if (isCheck) {
                                        context.loaderOverlay.hide();
                                        if (extension.contains('.zip')) {
                                          Get.to(() => DownloadsFolder(
                                                filePath: folderPath,
                                                title: "My Downloads",
                                              ));
                                        } else {
                                          await OpenDocument.openDocument(
                                            filePath: filePath,
                                          );
                                        }
                                      } else {
                                        final LessonController
                                            lessonController =
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
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return showDownloadAlertDialog(
                                                    context,
                                                    lessons[index].name ?? "",
                                                    videoUrl,
                                                    downloadController,
                                                  );
                                                });
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
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      !MediaUtils.isFile(lessons[index].host)
                                          ? Icon(
                                              FontAwesomeIcons.solidPlayCircle,
                                              color: Get.theme.primaryColor,
                                              size: 16,
                                            )
                                          : Icon(
                                              FontAwesomeIcons.file,
                                              color: Get.theme.primaryColor,
                                              size: 16,
                                            ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(lessons[index].name ?? "",
                                              style: Get.textTheme.subtitle2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      );
                    });
                  }),
            ],
          );
        },
      ),
    );
  }

  Widget filesWidget(MyCourseController controller) {
    final DownloadController downloadController = Get.put(DownloadController());

    return extend.NestedScrollViewInnerScrollPositionKeyWidget(
      const Key('Tab2'),
      ListView.builder(
        itemCount: controller.myCourseDetails.value.files.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return fileDetailsWidget(
              context,
              controller.myCourseDetails.value.files[index],
              downloadController);
        },
      ),
    );
  }

  Widget fileDetailsWidget(BuildContext context, FileElement file,
      DownloadController downloadController) {
    return InkWell(
      onTap: () async {
        context.loaderOverlay.show();
        String filePath;

        final extension = p.extension(file.file);

        Directory applicationSupportDir =
            await getApplicationSupportDirectory();
        String folderPath = applicationSupportDir.path;

        filePath = "$folderPath/${companyName}_${file.fileName}$extension";

        final isCheck = await OpenDocument.checkDocument(filePath: filePath);

        debugPrint("Exist: $isCheck");

        if (isCheck) {
          final DownloadController downloadController =
              Get.put(DownloadController());
          showDialog(
              context: context,
              builder: (context) {
                return showDownloadAlertDialog(
                  context,
                  file.fileName ?? "",
                  file.file,
                  downloadController,
                );
              });
        } else {
          context.loaderOverlay.hide();
          if (extension.contains('.zip')) {
            Get.to(() => DownloadsFolder(
                  filePath: folderPath,
                  title: "داونلۆدەکانم",
                ));
          } else {
            await OpenDocument.openDocument(
              filePath: filePath,
            );
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                file.fileName != null
                    ? Container(
                        child: Icon(
                          FontAwesomeIcons.fileDownload,
                          color: Get.theme.primaryColor,
                          size: 16,
                        ),
                      )
                    : Container(),
                SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    file.fileName.toString(),
                    style: Get.textTheme.subtitle1,
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget questionsAnswerWidget(MyCourseController controller) {
    return extend.NestedScrollViewInnerScrollPositionKeyWidget(
      const Key('Tab3'),
      Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.myCourseDetails.value.comments.length,
                physics: NeverScrollableScrollPhysics(),
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
                                image: controller.myCourseDetails.value
                                        .comments[index].user.image
                                        .contains('public/')
                                    ? NetworkImage(rootUrl +
                                        '/' +
                                        controller.myCourseDetails.value
                                            .comments[index].user.image)
                                    : NetworkImage(controller.myCourseDetails
                                        .value.comments[index].user.image),
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
                                          controller.myCourseDetails.value
                                              .comments[index].user.name
                                              .toString(),
                                          style: Get.textTheme.subtitle1,
                                        ),
                                        Expanded(child: Container()),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            controller.myCourseDetails.value
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
                                      controller.myCourseDetails.value
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
            )
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
                    image: controller.dashboardController.profileData.image
                            .contains('public')
                        ? NetworkImage(rootUrl +
                                "/" +
                                controller
                                    .dashboardController.profileData.image ??
                            "")
                        : NetworkImage(rootUrl +
                                "/" +
                                controller
                                    .dashboardController.profileData.image ??
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
                  controller.submitComment(controller.myCourseDetails.value.id,
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

  showDownloadAlertDialog(BuildContext context, String title, String fileUrl,
      DownloadController downloadController) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "نەخێر",
      ),
      onPressed: () {
        context.loaderOverlay.hide();
        Navigator.of(Get.overlayContext).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Text(
        "داونلۆد",
      ),
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

  Future<void> checkPermissions(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (statuses[Permission.storage] != statuses[PermissionStatus.granted]) {
      try {
        statuses = await [
          Permission.storage,
        ].request();
      } on Exception {
        debugPrint("Error");
      }

      if (statuses[Permission.storage] == statuses[PermissionStatus.granted])
        print("write  permission ok");
      else
        permissionsDenied(context);
    } else {
      print("write permission ok");
    }
  }

  void permissionsDenied(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return SimpleDialog(
            title: Text("${stctrl.lang["Permission denied"]}"),
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                child: Text(
                  "${stctrl.lang["You must grant all permission to use this application"]}",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              )
            ],
          );
        });
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

  String getExtention(String url) {
    var parts = url.split("/");
    return parts[parts.length - 1];
  }
}
