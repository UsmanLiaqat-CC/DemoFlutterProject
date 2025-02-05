import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../general_controller/GeneralController.dart';
import '../models/user_model_response.dart';




enum NotificationType { job, chat }

// @pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  log('_firebaseMessagingBackgroundHandler');
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
// ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
// ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class NotificationService {
  late FlutterLocalNotificationsPlugin _fltNotification;
  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  Future<void> initMessaging() async {
    var androidInit =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInit = const DarwinInitializationSettings(defaultPresentSound: true);
    var initSetting =
        InitializationSettings(android: androidInit, iOS: iosInit);
    _fltNotification = FlutterLocalNotificationsPlugin();
    _fltNotification.initialize(
      initSetting,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            // TODO: Handle this case.
            selectNotificationStream.add(notificationResponse.payload);
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    await _firebaseMessaging.requestPermission();
    //***********************************************************//

    _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    ///=========message handler==========

    remoteMessageHandler(RemoteMessage message) {
      if (message.notification != null) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        print("NotificationTEST: $notification");

        if (notification != null && android != null) {
          log("NotificationTEST: Notification Show  '${message.data}'");
          log("NotificationTEST: Notification notificationType  '${message.data['notificationType']}'");

          _fltNotification.show(
              notification.hashCode,
              notification.title,
              notification.body,
               NotificationDetails(
                  android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                // 'channel Description',
                priority: Priority.high,
                importance: Importance.max,
                playSound: true,
                    styleInformation: BigTextStyleInformation( notification.body??'')

              )),
              payload: json.encode(message.data));

        }
      }
    }

    FirebaseMessaging.onMessage.listen(remoteMessageHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        log("NotificationTEST: onMessageOpenedApp Show  '${message.data}");

        chatClickHandle(message.data);

        if (message.data['type'] == NotificationType.chat.name) {
          chatClickHandle(message.data);
          return;
        }
        if (message.data['type'] == NotificationType.job.name) {
          jobClickHandle(message.data);
          return;
        }
      }
    });
    //****************************************************************//
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _configureSelectNotificationSubject();
  }

  //****************************************************************//

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      if (payload == null) return;
      log('payload:${payload}');
      Map valueMap = jsonDecode(payload);
      if (valueMap['type'] == NotificationType.chat.name) {
        chatClickHandle(valueMap);
        return;
      }
      if (valueMap['type'] == NotificationType.job.name) {
        jobClickHandle(valueMap);
        return;
      }
    });
  }

//***********************************************************//
  chatClickHandle(Map valueMap) {


    print("NotificationTEST: ChatClickHandle:${valueMap}");

    // Extract values from the valueMap
    String receiverId = valueMap['receiver_id'] ?? '';
    String chatName = valueMap['chatName'] ?? '';
    String socketId = valueMap['sender_socket_id'] ?? '';
    String sender_id = valueMap['sender_id'] ?? '';


    // print("ChatClickHandle: ReceiverId: $receiverId, ChatName: $chatName, SocketId: $socketId \n userModel:${currentUserModel.toJson()}");

    // Navigate to the ChatScreenView and pass the extracted values
    // Get.to(ChatScreenView(), arguments: {
    //   'receiverId': sender_id,
    //   'chatName': chatName,
    //   'socketId': socketId,
    //   'json_data': valueMap,
    // });

  }



//**********************Job*************************************//
  jobClickHandle(Map valueMap) {
    if (valueMap['job'] == null) return;
    Map<String, dynamic> jsonResp = json.decode(valueMap['job'].toString());
    /*Jobs job = Jobs.fromJson(jsonResp);
    Get.to(const JobDetailsView(), arguments: {"job": job});*/
  }
//***********************************************************//
}
