// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Flutter imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lms_flutter_app/Model/User/User.dart';
import 'package:lms_flutter_app/Views/MainNavigationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/cart_controller.dart';
import 'package:lms_flutter_app/Service/RemoteService.dart';
import 'package:lms_flutter_app/utils/widgets/persistant_bottom_custom/persistent-tab-view.dart';

class DashboardController extends GetxController {
  final CartController cartController = Get.find<CartController>();

  PersistentTabController persistentTabController =
      PersistentTabController(initialIndex: 0);

  var scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  var loginReturn = " ";
  var token = "";
  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  var loggedIn = false.obs;

  String loadToken;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final TextEditingController registerName = TextEditingController();
  final TextEditingController registerEmail = TextEditingController();
  final TextEditingController registerPhone = TextEditingController();
  final TextEditingController registerPassword = TextEditingController();
  final TextEditingController registerConfirmPassword = TextEditingController();

  var isLoading = false.obs;

  var loginMsg = "".obs;

  var profileData = User();

  var isRegisterScreen = false.obs;

  void changeTabIndex(int index) async {
    Get.focusScope.unfocus();
    persistentTabController.index = index;
    if (persistentTabController.index == 3) {
      if (loggedIn.value) {
        // String token = await userToken.read(tokenKey);
        getProfileData();
        scaffoldKey.currentState.openEndDrawer();
      }

      // changeTabIndex(0);
    } else if (persistentTabController.index == 1) {
      if (loggedIn(true)) {
        cartController.cartList.value = [];
        cartController.getCartList();
      }
    }
    checkToken();
  }

  Future<void> loadUserToken() async {
    loadToken = await loadData();
    if (loadToken != null) {
      var toke = await userToken.read(tokenKey);
      checkToken();
      cartController.isLoading.value = true;
      cartController.getCartList();
      isLoading(false);
      return toke;
    } else {
      await userToken.remove(tokenKey);
    }
  }

  Future<String> loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey);
  }

  Future<bool> checkToken() async {
    String token = await userToken.read(tokenKey);

    if (token != null) {
      loggedIn.value = true;
      update();
      getProfileData();
      return true;
    } else {
      loggedIn.value = false;
      update();
      return false;
    }
  }

  // call login api
  Future fetchUserLogin() async {
    try {
      isLoading(true);
      var login = await RemoteServices.login(email.text, password.text);
      if (login != null) {
        if (login['data']['is_verify'] != null) {
          token = login['data']['access_token'];
          loginMsg.value = login['message'];
          if (token.length > 5) {
            await saveToken(token);
            await loadUserToken();
            await setupNotification();
             await stctrl.getLanguage();
          }
          return login;
        } else {
          loginMsg.value = "پشتراست نەکراوەتەوە";
          Get.snackbar(
            "ئیمەیلەکەت پشتراست کەرەوە",
            "پێش بەردەوام بوون، سەرێکی ئیمەیلەکەت بکە بۆ وەرگرتنی لینکی پشتراست کردنەوە",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 5,
            duration: Duration(seconds: 6),
          );
        }
      }
    } finally {
      isLoading(false);
    }
  }



    Future fetchUserLogin2() async {
    try {
      isLoading(true);
      var login = await RemoteServices.login(registerEmail.text, registerPassword.text);
      if (login != null) {
        if (login['data']['is_verify'] != null) {
          token = login['data']['access_token'];
          loginMsg.value = login['message'];
          if (token.length > 5) {
            await saveToken(token);
            await loadUserToken();
            await setupNotification();
             await stctrl.getLanguage();
          }
          return login;
        } else {
          loginMsg.value = "پشتراست نەکراوەتەوە";
          Get.snackbar(
            "ئیمەیلەکەت پشتراست کەرەوە",
            "پێش بەردەوام بوون، سەرێکی ئیمەیلەکەت بکە بۆ وەرگرتنی لینکی پشتراست کردنەوە",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 5,
            duration: Duration(seconds: 6),
          );
        }
      }
    } finally {
      isLoading(false);
    }
  }

  Future<bool> socialLogin(Map data) async {
    Uri loginUrl = Uri.parse(baseUrl + '/social-login');

    var body = json.encode(data);
    var response = await http.post(loginUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body);
    log(response.body.toString());
    var jsonString = jsonDecode(response.body);
    if (response.statusCode == 200) {
      token = jsonString['data']['access_token'];

      if (token.length > 5) {
        await userToken.write("method", "${data['provider']}");

        await saveToken(token);
        await loadUserToken();
        await setupNotification();
        await stctrl.getLanguage();

        return true;
      } else {
        return false;
      }
    } else if (response.statusCode == 401) {
      Get.snackbar(
        "زانیاری داخڵ بوون هەڵەیە",
        "ئیمەیل یان وشەی نهێنی هەڵەیە، دووبارە هەوڵ بدەرەوە",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 5,
      );
    } else {
      Get.snackbar(
        "هەڵەیەک رویدا!",
        "${jsonString['message']}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 5,
      );
    }

    return false;
  }

  void showRegisterScreen() {
    isRegisterScreen.value = !isRegisterScreen.value;
    print("Ok");

  }

  Future fetchUserRegister() async {
    try {
      isLoading(true);
      print('Ok');
      var login = await RemoteServices.register(
        registerName.text,
        registerEmail.text,
        registerPhone.text,
        registerPassword.text,
        registerConfirmPassword.text,
      );
      print(login);
      if (login != null) {

        if (login['success'] == true) {
          // showRegisterScreen();

          fetchUserLogin();
           
          


         

          var  userlogin = await fetchUserLogin2();

           registerName.clear();
          registerEmail.clear();
          registerPhone.clear();
          registerPassword.clear();
          registerConfirmPassword.clear();

          Get.snackbar(
            login['message'],
            "",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            borderRadius: 5,
          );
        }

        return login;
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> saveToken(String msg) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (msg.length > 5) {
      await preferences.setString(tokenKey, msg);
      await userToken.write(tokenKey, msg);
    } else {}
  }

  Future<void> removeToken(String msg) async {
    try {
      String token = await userToken.read(tokenKey);

      Uri logoutUrl = Uri.parse(baseUrl + '/logout');
      var response = await http.get(
        logoutUrl,
        headers: {
          'Accept': 'application/json',
          '$authHeader': '$isBearer' + '$token',
        },
      );

      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove(tokenKey);
        await userToken.remove(tokenKey);
        cartController.cartList.value = [];
        loggedIn.value = false;
        await stctrl.getLanguage();
        loginMsg.value = "${stctrl.lang['Logged out']}";
        update();
        Get.snackbar(
          "${stctrl.lang['Done']}",
          jsonString['message'].toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Colors.white,
          borderRadius: 5,
        );
      } else {
        Get.snackbar(
          "چونە هەڵە هەیە لە چونە دەرەوەدەرەوە",
          jsonString['message'].toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 5,
        );
        return null;
      }
    } catch (e) {}
  }

  Future<User> getProfileData() async {
    String token = await userToken.read(tokenKey);
    try {
      var products = await RemoteServices.getProfile(token);
      if (products != null) {
        profileData = products;
      }
      return products;
    } finally {}
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future setupNotification() async {
    // ignore: unused_local_variable
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    messaging.getToken().then((value) async {
      if (loggedIn.value) {
        await sendTokenToServer(value);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // final receivedSms = message.data['message'];
      // print(receivedSms);

      final main = jsonEncode(message.data);

      final data = jsonDecode(main);

      if (data['title'] != null && data['body'] != null) {
        Get.dialog(
          AlertDialog(
            title: data['image'] != null
                ? Image.network(data['image'], width: 50, height: 50)
                : Image.asset(
                    "$appLogo",
                    width: 50,
                    height: 50,
                  ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data['title'],
                    style: Get.theme.textTheme.subtitle1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data['body'],
                    style: Get.theme.textTheme.subtitle2,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        );

        flutterLocalNotificationsPlugin.show(
            message.hashCode,
            data['title'],
            data['body'],
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: '@drawable/notification_icon',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final main = jsonEncode(message.data);

      final data = jsonDecode(main);

      if (data['title'] != null && data['body'] != null) {
        Get.dialog(
          AlertDialog(
            title: data['image'] != null
                ? Image.network(data['image'], width: 50, height: 50)
                : Image.asset(
                    "$appLogo",
                    width: 50,
                    height: 50,
                  ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data['title'],
                    style: Get.theme.textTheme.subtitle1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data['body'],
                    style: Get.theme.textTheme.subtitle2,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        );
      }
    });
  }

  Future sendTokenToServer(String token) async {
    await getProfileData();
    final response = await http.post(
      Uri.parse(baseUrl + '/set-fcm-token?id=${profileData.id}&token=$token'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        '$authHeader': '$isBearer' + '$token',
      },
    );
    if (response.statusCode == 200) {

      print('token updated : $token');
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove(tokenKey);
      await userToken.remove(tokenKey);
      cartController.cartList.value = [];
      checkToken();
      loginMsg.value = "چونە دەرەوە";
      update();
      Get.snackbar(
        "حاڵەت",
        "چونە دەرەوە",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 5,
      );
      throw Exception('Failed to load');
    }
  }

  var obscurePass = true.obs;
  var obscureNewPass = true.obs;
  var obscureConfirmPass = true.obs;

  @override
  void onInit() {
    // loadUserToken();
    checkToken();
    setupNotification();
    if (isDemo) {
      email.text = 'student@infixedu.com';
      password.text = '12345678';
    }
    super.onInit();
  }
}
