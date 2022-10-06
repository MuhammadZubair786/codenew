// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Model/User/User.dart';
import 'package:lms_flutter_app/Service/RemoteService.dart';
import 'package:loader_overlay/loader_overlay.dart';

class EditProfileController extends GetxController {
  final DashboardController dashboardController =
      Get.put(DashboardController());

  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  var profileData = User();

  // var image = File("").obs;
  var isLoading = false.obs;

  var selectedImagePath = "".obs;

  var userImage = "".obs;

  TextEditingController ctFirstName = TextEditingController();
  TextEditingController ctEmail = TextEditingController();
  TextEditingController ctPhone = TextEditingController();
  TextEditingController ctAddress = TextEditingController();
  TextEditingController ctCountry = TextEditingController();
  TextEditingController ctCity = TextEditingController();
  TextEditingController ctZipCode = TextEditingController();

  @override
  void onReady() {
    getProfileData();
    super.onReady();
  }

  Future<User> getProfileData() async {
    String token = await userToken.read(tokenKey);
    try {
      isLoading(true);
      update();
      var products = await RemoteServices.getProfile(token);
      if (products != null) {
        profileData = products;
        ctFirstName.text = profileData.name;
        ctEmail.text = profileData.email;
        ctPhone.text = profileData.phone;
        ctAddress.text = profileData.address;
        ctCountry.text = profileData.country;
        ctCity.text = profileData.city;
        ctZipCode.text = profileData.zip;
        userImage.value = profileData.image;
      }
      return products;
    } finally {
      isLoading(false);
      update();
    }
  }

  Future getImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowCompression: true,
      onFileLoading: (FilePickerStatus status) {},
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      // image.value = File(pickedFile.path);
      selectedImagePath.value = result.files.first.path;
    } else {
      Get.snackbar(
        "هەڵە",
        "هیچ وێنەیەک هەلنەبژێردراوە",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 5,
      );
    }
  }

  Future updateProfile(BuildContext context) async {
    context.loaderOverlay.show();
    String token = await userToken.read(tokenKey);

    var postUri = Uri.parse(baseUrl + '/update-profile');
    var request = new http.MultipartRequest("POST", postUri);
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    request.headers['$authHeader'] = '$isBearer' + '$token';
    request.fields['name'] = ctFirstName.text;
    request.fields['email'] = ctEmail.text;
    request.fields['phone'] = ctPhone.text;
    request.fields['address'] = ctAddress.text;
    request.fields['city'] = ctCity.text;
    request.fields['country'] = ctCountry.text;
    request.fields['zip'] = ctZipCode.text;
    request.fields['about'] = '';

    if (selectedImagePath.value != "") {
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('image', selectedImagePath.value);
      request.files.add(multipartFile);
    } else {

    }
    request
        .send()
        .then((result) async {
          http.Response.fromStream(result).then((response) {
            var jsonString = jsonDecode(response.body);
            if (response.statusCode == 200) {
              Get.snackbar(
                "سەرکەوتوو بوو",
                jsonString['message'].toString(),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Get.theme.primaryColor,
                colorText: Colors.white,
                borderRadius: 5,
              );
              dashboardController.getProfileData();
            } else {
              Get.snackbar(
                "سەرکەوتوو نەبوو",
                jsonString['message'].toString(),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
                borderRadius: 5,
              );
            }

            return response.body;
          });
        })
        .catchError((err) => print('error : ' + err.toString()))
        .whenComplete(() {
          context.loaderOverlay.hide();
        });
  }
}
