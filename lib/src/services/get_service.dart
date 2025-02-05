import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio_instance;
import 'package:get/get.dart';
import 'package:rich_out/src/services/set_headers.dart';

import '../general_controller/GeneralController.dart';
import '../utils/AppResource.dart';
import '../utils/keys.dart';
import '../widgets/dialog.dart';

getMethod(String apiUrl, dynamic queryData, Function executionMethod,
    {bool authHeader = false}) async {
  dio_instance.Response response;
  dio_instance.Dio dio = dio_instance.Dio();

  dio.options.connectTimeout =const Duration(minutes: 1);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  Get.find<GeneralController>().errorBoxShow = false;
  setAcceptHeader(dio);
  setContentHeader(dio);
  setBasicAuthHeader(dio);
  if (authHeader) {
    setCustomHeader(dio, 'Authorization',
        'Bearer ${Get.find<GeneralController>().box.read(AppKeys.authToken)}');
  }
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      log('Internet Connected');
      Get.find<GeneralController>().changeLoaderCheck(true);
      try {
        log('Data------>> ${queryData} --->apiUrl:${apiUrl}');
        response = await dio.get(apiUrl, queryParameters: queryData);
        log('StatusCode------>> ${response.statusCode}');
        log('Response $apiUrl------>> ${json.encode(response.data)}');
        Get.find<GeneralController>().changeLoaderCheck(false);

        if (response.statusCode! >= 200 && response.statusCode! <= 299) {
          executionMethod(true, response.data);
          return;
        }
        executionMethod(false, {'errors': null});
      } on dio_instance.DioError catch (e) {
        Get.find<GeneralController>().changeLoaderCheck(false);
        if (e.response?.statusCode == 401) {
          suspendedUserHandle(e.response?.data);
          executionMethod(false, {'errors': null});
          return;
        }
        if (e.response?.statusCode == null) {
          ResponseDialog.showError(AppStrings.slow_internet);
          return;
        }
        if ((e.response?.statusCode ?? 500) >= 500) {
          ResponseDialog.showError(AppStrings.server_error);
          log('Dio Error From -->> $e');
          return;
        }

        executionMethod(false, e.response?.data);
        log('Dio Error From Get $apiUrl -->> $e');
      }
    }
  } on SocketException catch (_) {
    Get.find<GeneralController>().changeLoaderCheck(false);
    if (!Get.find<GeneralController>().errorBoxShow) {
      ResponseDialog.showError(AppStrings.server_error);
    }
    Get.find<GeneralController>().errorBoxShow = true;

    log('Internet Not Connected');
  }
}