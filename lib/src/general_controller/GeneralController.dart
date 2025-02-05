import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user_model_response.dart';
import '../modules/login/view.dart';
import '../notification/firebase_messaging.dart';
import '../services/get_service.dart';
import '../services/urls.dart';
import '../utils/AppResource.dart';
import '../utils/keys.dart';
import '../widgets/dialog.dart';


class GeneralController extends GetxController {
  ///-------------------------------------------
  UserModel userModel = UserModel();

  ///-------------------------------------------
  GetStorage box = GetStorage();

  ///-------------------------------internet-check
  bool internetChecker = true;

  @override
  void onInit() {
    super.onInit();
    // Retrieve the user model from storage
    if (box.hasData(AppKeys.user)) {
      userModel = UserModel.fromJson(box.read(AppKeys.user));
      log("UserModel loaded from storage: ${userModel.toJson()}");
    }
  }


  changeInternetCheckerState(bool value) {
    internetChecker = value;
    update();
  }

  ///----internet-settings-------------
  String connectionStatus = 'Unknown';
  final Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  bool internetCheck = true;
  bool errorBoxShow = false;

  //---------internet-checker-functions----------------------

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult? result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = (await connectivity.checkConnectivity()) as ConnectivityResult?;
      update();
    } on PlatformException catch (e) {
      log(e.toString());
    }
    log('updateConnectionStatus');
    return updateConnectionStatus(result!);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    log('updateConnectionStatus  $result');
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        connectionStatus = result.toString();
        if (result != ConnectivityResult.none) {
          internetCheck = true;
          // Get.find<SplashScreenLogic>().timer();
        } else {
          internetCheck = false;
          ResponseDialog.showError(AppStrings.checkInternet);
          log('InternetOFF');
        }
        update();
        break;
      default:
        connectionStatus = 'Failed to get connectivity.';
        update();
        break;
    }
  }

  ///------------------------------App Direction Check
  bool isDirectionRTL(BuildContext context) {
    final TextDirection currentDirection = Directionality.of(context);
    final bool isRTL = currentDirection == TextDirection.rtl;
    return isRTL;
  }

  ///------------------------------- loader-check
  bool loaderCheck = false;
  String? message;

  changeLoaderCheck(bool value,{String? message}) {
    loaderCheck = value;
    this.message=message;
    update();
  }

  ///------------------------------- Server-check
  bool serverCheck = true;

  changeServerCheck(bool value) {
    serverCheck = value;
    update();
  }

  void logout() {

    GeneralController generalController = Get.find<GeneralController>();
    Map<String, dynamic>? userData = generalController.box.read(AppKeys.user);
    UserModel user = UserModel.fromJson(userData!);

    print("logout:${user?.toJson()}");

    String api_url="${userLogout}/${user.sId?.toString()}";
    getMethod(api_url,null, logoutHandle, authHeader: true);
  }


  logoutHandle(bool responseCheck, Map<String, dynamic> response)  {
    if (responseCheck) {
      print("logoutHandle:${response}");
      // Clear user-related data from the controller
      Get.snackbar(AppStrings.success, response['message']);
      NotificationsSubscription.fcmUnSubscribe(topic:userModel?.sId);
      manageLogout();
      return;
    }
    // Error handling
    List<String> errors = [];
    // Check if errors is an array
    if (response['errors'] != null) {
      if (response['errors'] is List) {
        errors = List<String>.from(response['errors'].map((x) => x["detail"]));
      }
    }
    // Check if there's a single error object
    if (response['error'] != null) {
      errors.add(response['error']['detail']);
    }
    if (errors.isNotEmpty) {
      ResponseDialog.showError(errors[0]);
    }
  }

  void manageLogout() {
    userModel = UserModel();
    box.remove(AppKeys.authToken);
    box.remove(AppKeys.user);
    Get.offAll(LoginView());
  }
}