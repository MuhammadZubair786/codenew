// Flutter imports:
// ignore_for_file: missing_return

import 'dart:async';

import 'package:flutter/material.dart';

// Package imports:

import 'package:get/get.dart';
import 'package:lms_flutter_app/Controller/myCourse_controller.dart';
import 'package:lms_flutter_app/Views/Home/Instructor.dart';
import 'package:lms_flutter_app/Views/Home/Instructor/Instructor.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyCourses/my_course_details_view.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyQuiz/my_quiz_details_view.dart';
import 'package:lms_flutter_app/utils/DefaultLoadingWidget.dart';
import 'package:lms_flutter_app/utils/widgets/LoadingSkeletonItemWidget.dart';
import 'package:lms_flutter_app/utils/widgets/SingleCardItemWidget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_skeleton/loading_skeleton.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scaled_list/scaled_list.dart';

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
import 'package:webview_flutter/webview_flutter.dart';

class SliderWebView extends StatefulWidget {
  var url;
  var title;
  SliderWebView(this.url, this.title);

  @override
  State<SliderWebView> createState() => _SliderWebViewState(url, title);
}

class _SliderWebViewState extends State<SliderWebView> {
  var url;
  var title;
  _SliderWebViewState(this.url, this.title);
  WebViewController _webViewController;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(title.toString(),style: TextStyle(color: Colors.white),),
      //   centerTitle: true,
      //   backgroundColor: Colors.black,

      // ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: url,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
              _controller.complete(webViewController);
            },
            onPageStarted: (data) {
              _webViewController.evaluateJavascript(
                "document.getElementsByTagName('header')[0].style.display='none'",
              );
                  _webViewController.evaluateJavascript(
                "document.getElementsByTagName('newsletter_form_inner')[0].style.display='none'",
              );
              _webViewController.evaluateJavascript(
                "document.getElementsByTagName('footer')[0].style.display='none'",
              );
            },
            onProgress: (int progress) {
              _webViewController.evaluateJavascript(
                  "document.getElementsByTagName('header')[0].style.display='none'");
              _webViewController.evaluateJavascript(
                "document.getElementsByTagName('footer')[0].style.display='none'",
              );
                  _webViewController.evaluateJavascript(
                "document.getElementsByTagName('newsletter_form_inner')[0].style.display='none'",
              );
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');

              // Removes header and footer from page
              _webViewController.evaluateJavascript(
                  "document.getElementsByTagName('header')[0].style.display='none'");

              _webViewController.evaluateJavascript(
                "document.getElementsByTagName('footer')[0].style.display='none'",
              );
                  _webViewController.evaluateJavascript(
                "document.getElementsByTagName('newsletter_form_inner')[0].style.display='none'",
              );
            },
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.abc),
      //   onPressed: () {
      //     _webViewController.evaluateJavascript(
      //         "document.getElementsByTagName('header')[0].style.display='none'");
      //   },
      // )
    );
  }
}
