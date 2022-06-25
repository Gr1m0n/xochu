import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xochuapp/strings/strings.dart';
import 'package:xochuapp/models/banners_model.dart';

class BannersProvider extends ChangeNotifier {
  Future<ResponseBannersData> getBanners ({
    int? position,
    String? lang,
  }) async {
    var queryParams = {
      'position': position.toString(),
      'lang': lang.toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}get-banners" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ResponseBannersData responseData = ResponseBannersData.fromJson(data);
      return responseData;
    } else {
      throw Exception();
    }
  }
}
