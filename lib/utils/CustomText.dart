// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';

// ignore: non_constant_identifier_names
Widget Texth1(String txt) {
  return Text(
    txt,
    style:  TextStyle(
      fontSize: 19,
      color: Get.theme.brightness == Brightness.dark ? Colors.white: Color.fromARGB(255, 39, 38, 38)
      ,
     fontFamily: "AvenirNext"
    ),
  );
}

// ignore: non_constant_identifier_names
Widget Texth2(String txt) {
  return Text(
    txt,
    style:  TextStyle(
      fontSize: 19,
      color: Get.theme.brightness == Brightness.dark ? Colors.white: Color.fromARGB(255, 39, 38, 38),
     fontFamily: "AvenirNext"
    ),
  );
}

// ignore: non_constant_identifier_names
Widget CatTitle(String txt) {
  return Text(
    txt,
    maxLines: 1,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 39, 38, 38),
     fontFamily: "AvenirNext"
    ),
  );
}

// ignore: non_constant_identifier_names
Widget CatSubTitle(String txt) {
  return Text(
    txt,
    style: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      fontFamily: "DynaPuff",
      color: Color.fromARGB(255, 134, 134, 134),
    ),
  );
}

Widget sellAllText() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(top: 3),
        child: Text("هەموو",
            style: TextStyle(
              color: Get.theme.primaryColor,
              fontFamily: "CodaRegular",
              // backgroundColor: Colors.yellow
            )),
      ),
      Container(
        child: Icon(
          Icons.arrow_right,
          color: Get.theme.primaryColor,
        ),
      ),
    ],
  );
}

Widget courseTitle(String txt) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Text(
      txt,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Get.textTheme.subtitle1.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
      fontFamily: "DynaPuff",
      ),
    ),
  );
}

Widget courseTitle2(String txt) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Text(
      txt,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Get.textTheme.subtitle1.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
      fontFamily: "DynaPuff",
      ),
    ),
  );
}

Widget courseTPublisher(String txt) {
  return Text(txt,
      style: TextStyle(
          fontSize: 11, fontWeight:
          
           FontWeight.w500,
           fontFamily: "DynaPuff", color: Color(0xff8E99B7)));
}

Widget cartMoney(String txt) {
  return Text(txt,
      style: Get.textTheme.subtitle1.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xfffb4611),
          fontFamily: 'AvenirNext'));
}

Widget cartTitle(String txt) {
  return Text(txt,
      style: Get.textTheme.subtitle1.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          fontFamily: 'AvenirNext'));
}

Widget cartTotal(String txt) {
  return Text(txt,
      style: Get.textTheme.subtitle1.copyWith(
                  color : Get.theme.brightness==Brightness.dark? Colors.black : Colors.black , 
        
          fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'AvenirNext'));
}

Widget couponTitle(String txt) {
  return Text(txt,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: Color(0xff23BC20),
          fontFamily: 'AvenirNext'));
}

Widget couponTotal(String txt) {
  return Text(txt,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xff23BC20),
          fontFamily: 'AvenirNext'));
}

Widget couponError(String txt) {
  return Text(txt,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xffbc2020),
          fontFamily: 'AvenirNext'));
}

Widget courseDescriptionTitle(String txt) {
  return Text(
    txt,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Color(0xffffffff),
      fontFamily: 'AvenirNext',
    ),
    textAlign: TextAlign.left,
  );
}

Widget AppcourseDescriptionTitle(String txt) {
  return Text(
    txt,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Color(0xffffffff),
      fontFamily: 'DynaPuff',
    ),
    textAlign: TextAlign.left,
  );
}

Widget ContainercourseDescriptionTitle(String txt) {
  return Text(
    txt,
    style: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w600,
      color: Color.fromARGB(255, 19, 17, 17),
      fontFamily: 'DynaPuff',
    ),
    // textAlign: TextAlign.left,
  );
}

Widget courseDescriptionPublisher(String txt) {
  return Text(txt,
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xffffffff)));
}

Widget courseStructure(String txt) {
  return Text(
    txt,
    style: Get.textTheme.subtitle2.copyWith(fontSize: 14),
  );
}

String getTimeString(int value) {
  final int hour = value ~/ 60;
  final int minutes = value % 60;
  return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
}

// ignore: non_constant_identifier_names
Widget PopularPostTitle(String txt) {
  return Text(txt,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Get.textTheme.subtitle1.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'AvenirNext',
      ));
}
