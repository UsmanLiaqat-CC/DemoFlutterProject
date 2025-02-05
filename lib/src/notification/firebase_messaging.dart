import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../general_controller/GeneralController.dart';


class NotificationsSubscription {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> showNotificationPermission() async {
    await _firebaseMessaging.requestPermission();
  }
  static Future<String?> deviceToken() async {
   return await _firebaseMessaging.getToken();
  }

  static void fcmSubscribe({String? topic}) {
    _firebaseMessaging.subscribeToTopic(
        topic ?? Get.find<GeneralController>().userModel.sId.toString() ?? '');
  }

  static void fcmUnSubscribe({String? topic}) {
    _firebaseMessaging.unsubscribeFromTopic(topic ??  Get.find<GeneralController>().userModel.sId.toString() ?? '');
  }

  static initialNotificationHandle() async {
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (initialMessage.data.isNotEmpty) {
        Map<String, dynamic> jsonResp =
            json.decode(initialMessage.data['job'].toString());
      }
    }
  }
}
