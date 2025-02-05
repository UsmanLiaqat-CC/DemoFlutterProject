
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AppResource.dart';

class Utils{

  static String date_format="MM-dd-yyyy";

  static void launchPrivacyPolicy() async {
    const url = 'https://sites.google.com/view/privacy-policy-for-swift-atten/home'; // Replace with your actual link
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.snackbar(AppStrings.error, ErrorStrings.cannot_open_privacy_policy_link);
    }
  }
}

//____________________________________________-

Future<Uint8List?> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
}