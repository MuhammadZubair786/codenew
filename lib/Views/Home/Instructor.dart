// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

// Package imports:

import 'package:get/get.dart';
import 'package:html/parser.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';
import 'package:lms_flutter_app/Controller/myCourse_controller.dart';
import 'package:lms_flutter_app/Controller/site_controller.dart';
import 'package:lms_flutter_app/Views/Home/Course/course_details_page.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyCourses/my_course_details_view.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/DefaultLoadingWidget.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';
import 'package:lms_flutter_app/utils/widgets/FilterDrawer.dart';
import 'package:lms_flutter_app/utils/widgets/SingleCardItemWidget.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;

class InstructorData1 extends StatelessWidget {
  var item;
  var data;

  InstructorData1(this.item, this.data);

  double width;
  double percentageWidth;
  double height;
  double percentageHeight;

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

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.put(DashboardController());

    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;

    //  print(data['lessons']);

    // final SiteController _stctrl = Get.put(SiteController());
    final HomeController _homeController = Get.put(HomeController());
    // print(_homeController.courseDetails.map((data) => print(data.about)));

    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: defaultLoadingWidget,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: AppcourseDescriptionTitle(data["title"]
                      ['${stctrl.code.value}'] ??
                  "${data["title"]['en']}"),
              leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    // margin: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width * 100,
                    // height: 340,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: Image.network(
                          'https://aca.teratarget.com/le/${data["image"]}',
                          fit: BoxFit.fitWidth,
                          width: MediaQuery.of(context).size.width),
                    ),
                  ),
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
                          width: 0.6,
                          color: Color.fromARGB(255, 182, 182, 182),
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
                            data["title"]['${stctrl.code.value}'] ??
                                "${data["title"]['en']}",
                          )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //  ElevatedButton(onPressed: (){
                        //   print(controller.courseDetails.value);
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
                                        data["level"].toString() == "1" ? 
                                      Text(
                                        "دەستپێکەران"
                                       ,
                                        style: TextStyle(
                                           fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 71, 71, 71)),
                                      ):
                                     data["level"].toString() == "2" ? 
                                       Text(
                                        "مام ناوەند"
                                       ,
                                        style: TextStyle(
                                           fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 71, 71, 71)),
                                      ):
                                      data["level"].toString() == "3" ? 
                                       Text(
                                        "پێشکەوتوو"
                                       ,
                                        style: TextStyle(
                                          fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 71, 71, 71)),
                                      ):
                                      data["level"].toString() == "4" ? 
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
                                        data["total_enrolled"].toString(),
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
                                    Text("هەڵسەنگاندن",
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
                                          data["reveiw"].toString(),
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
                           child:  Align(
                               alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.only(left:30,right:30),
                                child: Text("زانیاری مامۆستا",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 16, 16, 16),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 25,
                                    fontFamily: "CodaRegular"))))),
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
                                          '$rootUrl/${data["user"]["image"]}',
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
                                          data["user"]["name"],
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 16, 16, 16),
                                              fontFamily: "CodaRegular"),
                                          textAlign: TextAlign.right,
                                        ),
                                        Container(
                                          constraints: BoxConstraints(
                            maxHeight: double.infinity,
                          ),
                                          child: Text(
                                            _parseHtmlString(
                                                data["user"]["about"]),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 16, 16, 16),
                                                fontFamily: "CodaRegular"),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        SizedBox(height: 10,)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                                SizedBox(height: 10,)
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

                  data['duration'] != ""
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
                                  child:  Align(
                               alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.only(left:30,right:30),
                                child: Text("کاتی کۆرس",
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
                                                
                                                    data['duration'].toString()+"  " ,
                                                   
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
                  data['about'] != ""
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
                                  child:  Align(
                               alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.only(left:30,right:30),
                                child: Text("زانیاری کۆرس",
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
                                                  0, 10, 0, 0),
                                              child:  

                                              
                                              
                                               HtmlWidget(
                                                '''
                ${data['about']['ar'] ?? "${data['about']['ar']}" ??  "${data['about']['en']}"}
                 ''',
                                                textStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color.fromARGB(
                                                        255, 16, 16, 16),
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
                  data['outcomes'] != ""
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
                            color: Colors.grey.withOpacity(0.0),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(4, 8), // changes position of shadow
                          ),
                        ],),
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 2, left: 2, right: 2),
                                  child:  Align(
                               alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.only(left:30,right:30),
                                child: Text("چی فێردەبیت",
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 16, 16, 16),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 25,
                                            fontFamily: "Rabar_B")),
                                  ))),
                              Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(
                                    left: 5, right: 5, bottom: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      width: percentageWidth * 100,
                                      padding: EdgeInsets.fromLTRB(
                                          0, percentageHeight * 3, 0, 0),
                                      child: HtmlWidget(
                                        '''
                ${data['outcomes']['ar'] ?? "${data['outcomes']['ar']}" ?? "${data['outcomes']['en']}"}
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
                            margin: EdgeInsets.only(top: 2, left: 2, right: 2),
                            child:  Align(
                               alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.only(left:30,right:30),
                                child: Text("وانە و چاپتەرەکان",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 16, 16, 16),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25,
                                      fontFamily: "Rabar_B")),
                            ))),
                        Container(
                          alignment: Alignment.topCenter,
                          padding:
                              EdgeInsets.only(left: 5, right: 5, bottom: 10),
                          child: Column(
                            children: [
                              Container(
                                width: percentageWidth * 100,
                                padding: EdgeInsets.fromLTRB(
                                    0, percentageHeight * 3, 0, 0),
                                child: HtmlWidget(
                                  '''
                ${data['requirements']['ar'] ?? "${data['requirements']['ar']}" ?? "${data['requirements']['en']}"}
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
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color.fromARGB(255, 16, 16, 16),
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
                  ),
                  SizedBox(height: 10),
                  //  data['lessons'].length > 0
                  //         ? Container(
                  //             margin: EdgeInsets.only(
                  //               left: 10,
                  //               right: 10,
                  //               top: 5,
                  //               bottom: 5,
                  //             ),
                  //             constraints: BoxConstraints(
                  //               maxHeight: double.infinity,
                  //             ),
                  //             decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 border: Border.all(
                  //                   width: 1,
                  //                   color: Color.fromARGB(255, 255, 255, 255),
                  //                 ),
                  //                 borderRadius: BorderRadius.circular(30),
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: Color.fromARGB(255, 220, 220, 220)
                  //                         .withOpacity(0.5),
                  //                     spreadRadius: 10,
                  //                     blurRadius: 10,
                  //                     offset: Offset(
                  //                         4, 8), // changes position of shadow
                  //                   ),
                  //                 ]),
                  //             child: Column(
                  //               children: [
                  //                 Container(
                  //                     margin: EdgeInsets.only(
                  //                         top: 2, left: 2, right: 2),
                  //                     child: Center(
                  //                       child: Text("منهاج دراسي",
                  //                           style: TextStyle(
                  //                               color:
                  //                                   Color.fromARGB(255, 16, 16, 16),
                  //                               fontWeight: FontWeight.w900,
                  //                               fontSize: 20,
                  //                               fontFamily: "rabar_B")),
                  //                     )),
                  //                 Container(
                  //                   alignment: Alignment.topCenter,
                  //                   padding: EdgeInsets.only(
                  //                       left: 5, right: 5, bottom: 10),
                  //                   child: Column(
                  //                     children: [
                  //                       Container(
                  //                           width: percentageWidth * 100,
                  //                           padding: EdgeInsets.fromLTRB(
                  //                               0, percentageHeight * 3, 0, 0),
                  //                           child: ListView.builder(
                  //                               shrinkWrap: true,
                  //                               // physics: NeverScrollableScrollPhysics(),
                  //                               itemCount: data['lessons'].length,
                  //                               itemBuilder: (context, index) {
                  //                                 return Container(
                  //                                     margin: EdgeInsets.all(9),
                  //                                     constraints: BoxConstraints(
                  //                                       maxHeight: double.infinity,
                  //                                     ),
                  //                                     child: Column(
                  //                                       mainAxisAlignment:
                  //                                           MainAxisAlignment.start,
                  //                                       crossAxisAlignment:
                  //                                           CrossAxisAlignment
                  //                                               .start,
                  //                                       children: [
                  //                                         Row(
                  //                                           mainAxisAlignment:
                  //                                               MainAxisAlignment
                  //                                                   .spaceBetween,
                  //                                           children: [
                  //                                             Text(
                  //                                               (index + 1)
                  //                                                       .toString() +
                  //                                                   ") " +
                  //                                                  data['lessons'][index]['name'] +
                  //                                                   " Lectures",
                  //                                               style: TextStyle(
                  //                                                   fontFamily:
                  //                                                       "Rabar_B",
                  //                                                   color: Colors
                  //                                                       .black,
                  //                                                   fontWeight:
                  //                                                       FontWeight
                  //                                                           .bold,
                  //                                                   fontSize: 20),
                  //                                             ),
                  //                                             Text(
                  //                                              data['lessons'][index]['duration']
                  //                                                       .toString() +
                  //                                                   "min",
                  //                                               style: TextStyle(
                  //                                                   fontFamily:
                  //                                                       "Rabar_D",
                  //                                                   color: Colors
                  //                                                       .black,
                  //                                                   fontSize: 20),
                  //                                             ),
                  //                                           ],
                  //                                         ),
                  //                                         Padding(
                  //                                           padding:
                  //                                               const EdgeInsets
                  //                                                       .only(
                  //                                                   left: 20.0),
                  //                                           child: Text(
                  //                                             " host :" +
                  //                                                data['lessons'][index]['host'],
                  //                                             style: TextStyle(
                  //                                                 fontFamily:
                  //                                                     "Rabar_B",
                  //                                                 color:
                  //                                                     Colors.black,
                  //                                                 fontSize: 15),
                  //                                           ),
                  //                                         ),
                  //                                         Padding(
                  //                                           padding:
                  //                                               const EdgeInsets
                  //                                                       .only(
                  //                                                   left: 20.0),
                  //                                           child: Row(
                  //                                             children: [
                  //                                               Icon(
                  //                                                 Icons.lock,
                  //                                                 color: Colors.red,
                  //                                                 size: 20,
                  //                                               ),
                  //                                               //        Text(
                  //                                               // "  "+
                  //                                               //           controller.courseDetails.value
                  //                                               //               .lessons[index].isLock.toString() ,

                  //                                               // style: TextStyle(
                  //                                               //           color: Colors.black,
                  //                                               //           fontSize: 15),
                  //                                               // ),
                  //                                             ],
                  //                                           ),
                  //                                         ),
                  //                                       ],
                  //                                     ));
                  //                               }))
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           )
                  //         : Text(""),

                  //     SizedBox(
                  //       height: 20,
                  //     ),
                  //     Container(
                  //       margin: EdgeInsets.only(
                  //         left: 10,
                  //         right: 10,
                  //         top: 5,
                  //         bottom: 5,
                  //       ),
                  //       constraints: BoxConstraints(
                  //         maxHeight: double.infinity,
                  //       ),
                  //       decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           border: Border.all(
                  //             width: 1,
                  //             color: Color.fromARGB(255, 255, 255, 255),
                  //           ),
                  //           borderRadius: BorderRadius.circular(30),
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Color.fromARGB(255, 220, 220, 220)
                  //                   .withOpacity(0.5),
                  //               spreadRadius: 10,
                  //               blurRadius: 10,
                  //               offset: Offset(4, 8), // changes position of shadow
                  //             ),
                  //           ]),
                  //       child: Column(
                  //         children: [
                  //           Container(
                  //               margin: EdgeInsets.only(top: 2),
                  //               child: Center(
                  //                 child: Text("مدرس حول",
                  //                     style: TextStyle(
                  //                         color: Color.fromARGB(255, 16, 16, 16),
                  //                         fontWeight: FontWeight.w900,
                  //                         fontSize: 20,
                  //                         fontFamily: "CodaRegular")),
                  //               )),
                  //           Container(
                  //             constraints: BoxConstraints(
                  //               maxHeight: double.infinity,
                  //             ),
                  //             alignment: Alignment.topCenter,
                  //             child: Column(
                  //               children: [
                  //                 Row(
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   children: [
                  //                     Container(
                  //                       width:
                  //                           MediaQuery.of(context).size.width * 0.9,
                  //                       constraints: BoxConstraints(
                  //                         maxHeight: double.infinity,
                  //                       ),
                  //                       padding: EdgeInsets.only(right: 10),
                  //                       child: Text(
                  //                         _parseHtmlString('${item["about"]}'),
                  //                         style: TextStyle(
                  //                             fontSize: 22,
                  //                             fontWeight: FontWeight.bold,
                  //                             color:
                  //                                 Color.fromARGB(255, 16, 16, 16),
                  //                             fontFamily: "CodaRegular"),
                  //                         // textAlign: TextAlign.right,
                  //                       ),
                  //                       // Container(
                  //                       //   child: Text(
                  //                       //     _parseHtmlString(controller
                  //                       //         .courseDetails
                  //                       //         .value
                  //                       //         .user
                  //                       //         .about),
                  //                       //     style: TextStyle(
                  //                       //         fontSize: 8,
                  //                       //         fontWeight: FontWeight.bold,
                  //                       //         color: Color.fromARGB(
                  //                       //             255, 16, 16, 16),
                  //                       //         fontFamily: "CodaRegular"),
                  //                       //     textAlign: TextAlign.right,
                  //                       //   ),
                  //                       // ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 // Container(
                  //                 //   margin: EdgeInsets.all(2),
                  //                 //   child: HtmlWidget(''''
                  //                 //       ${controller.courseDetails.value.user.about}
                  //                 //       '''),
                  //                 // )
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                ],
              ),
            )),
      ),
    );
  }
}
