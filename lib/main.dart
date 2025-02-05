import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rich_out/src/general_controller/GeneralController.dart';
import 'package:rich_out/src/notification/notification_class.dart';

import 'src/modules/login/view.dart';
import 'src/modules/splash/view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCSNvEBXhyUTpiGQtAWzAddyNfMfOy_-LU",
      appId: "1:224861025242:android:3ee18da1810fcfac1e46e3",
      messagingSenderId: "224861025242",
      projectId: "iseeyou-e329d",
    ),
  ):
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAb8xYEGKTU1lkFDx20JA7d33XQSYPqq2U",
          appId: "1:224861025242:ios:ccb4618eb31990991e46e3",
          messagingSenderId: "224861025242",
          projectId: "iseeyou-e329d"));
  Get.put(GeneralController());
  NotificationService().initMessaging();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/home', page: () =>LoginView()),
      ],
    );
  }
}
