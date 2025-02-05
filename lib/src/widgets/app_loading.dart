import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../general_controller/GeneralController.dart';
import '../utils/AppFonts.dart';



class AppLoading extends StatelessWidget {
  const AppLoading({Key? key, this.message}) : super(key: key);
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Platform.isAndroid
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(height: Get.height * 0.01),
                  if (message != null)
                    Text(
                      message!,
                      style: StyleRefer.poppinsMedium.copyWith(
                        fontSize: 14,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                ],
              ))
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(
                    radius: 20,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(height: Get.height * 0.01),
                  if (message != null)
                    Text(
                      message!,
                      style: StyleRefer.poppinsMedium.copyWith(
                        fontSize: 14,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class AppLoadingWidget {
  static GetBuilder<GeneralController> loadingBar() {
    return GetBuilder<GeneralController>(
      builder: (controller) {
        return controller.loaderCheck ? AppLoading(message: controller.message) : const Offstage();
      },
    );
  }
}