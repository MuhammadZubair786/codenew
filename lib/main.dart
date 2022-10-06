// Flutter imports:

import 'dart:io';

import 'package:connection_notifier/connection_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Views/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Bindings/dashboard_binding.dart';
import 'Config/themes.dart';
import 'Service/theme_service.dart';

class MyHttpoverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

var language;
bool langValue = false;

void main() async {
  await GetStorage.init();
  final sharedPref = await SharedPreferences.getInstance();
  HttpOverrides.global = new MyHttpoverrides();
  language = sharedPref.getString('language');
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return kDebugMode && Platform.isIOS
        ? GetMaterialApp(
            title: '$companyName',
            debugShowCheckedModeBanner: false,
            // fallbackLocale: Locale('en_US'),
            theme: Themes.light,
            darkTheme: Themes.dark,
            themeMode: ThemeService().theme,
            home: FutureBuilder(
                future: _initialization,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text(
                          snapshot.error.toString(),
                        ),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Scaffold(
                      body: SplashScreen(),
                    );
                  }
                  return CircularProgressIndicator();
                }),
            initialBinding: DashboardBinding(),
            builder: (BuildContext context, Widget child) {
              return FlutterSmartDialog(child: child);
            },
          )
        : ConnectionNotifier(
            child: GetMaterialApp(
              title: '$companyName',
              debugShowCheckedModeBanner: false,
              // fallbackLocale: Locale('en_US'),
              theme: Themes.light,
              darkTheme: Themes.dark,
              themeMode: ThemeService().theme,
              home: FutureBuilder(
                  future: _initialization,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Scaffold(
                        body: Center(
                          child: Text(
                            snapshot.error.toString(),
                          ),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Scaffold(
                        body: SplashScreen(),
                      );
                    }
                    return CircularProgressIndicator();
                  }),
              initialBinding: DashboardBinding(),
              builder: (BuildContext context, Widget child) {
                return FlutterSmartDialog(child: child);
              },
            ),
          );
  }
}
