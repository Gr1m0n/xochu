import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xochuapp/strings/strings.dart';
import 'package:xochuapp/models/notifications_model.dart';

class NotificationsProvider extends ChangeNotifier {
  late SharedPreferences logindata;
  Future<ResponseNotificationsData> getNotifications ({
    int? id,
  }) async {
    logindata = await SharedPreferences.getInstance();
    var queryParams = {
      'id': logindata.getInt('user_id').toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}notifications" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ResponseNotificationsData responseData = ResponseNotificationsData.fromJson(data);
      print("-----------------------------------------------------");
      print(responseData.data!.length);
      print(requestUrl);
      return responseData;
    } else {
      throw Exception();
    }
  }
}
