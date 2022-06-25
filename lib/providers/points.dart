import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xochuapp/strings/strings.dart';
import 'package:xochuapp/models/points_model.dart';

class PointsProvider extends ChangeNotifier {
  Future<ResponsePointsData> getPoints ({
    String? lang,
  }) async {
    var queryParams = {
      'lang': lang.toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}points" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ResponsePointsData responseData = ResponsePointsData.fromJson(data);
      return responseData;
    } else {
      throw Exception();
    }
  }
}
