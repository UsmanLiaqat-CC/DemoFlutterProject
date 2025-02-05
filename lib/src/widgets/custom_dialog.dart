import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/AppColor.dart';
import '../utils/AppFonts.dart';
import 'custom_elevated.dart';
import 'custom_small_text.dart';
import 'custom_textform.dart';

void showCustomDialog({
  String title = '',
  required Widget image,
  required String confirmText,
  String confirmButtonText = 'Approve',
  required String confirmActionText,
  Color buttonColor = Colors.red,
  required VoidCallback onConfirm,
}) {
  Get.defaultDialog(
    title: title,
    titleStyle: const TextStyle(height: 0),
    titlePadding: EdgeInsets.zero,
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          image,
          Text(
            confirmText,
            style: StyleRefer.poppinsSemiBold
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            confirmActionText,
            style: StyleRefer.poppinsMedium
                .copyWith(fontSize: 12, color: AppColor.textColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Get.height * 0.01),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SmallText(text: 'Comment:'),
              SizedBox(height: Get.height * 0.009),
              const CustomTextField(
                hintText: 'Enter Comment...',
                maxLine: 6,
                minLine: 4,
                borderEnabled: true,
              )
            ],
          ),
        ],
      ),
    ),
    backgroundColor: Colors.white,
    confirm: CustomElevatedButton(
      onPressed: onConfirm,
      backgroundColor: buttonColor,
      foregroundColor: Colors.white,
      width: Get.width * 0.5,
      height: Get.width * 0.12,
      child: Text(
        confirmButtonText,
        style: StyleRefer.poppinsMedium
            .copyWith(fontSize: 15, color: Colors.white),
      ),
    ),
    barrierDismissible: true,
  );
}
