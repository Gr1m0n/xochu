import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xochuapp/strings/strings.dart';
import 'package:xochuapp/models/faq_model.dart';

class FaqProvider extends ChangeNotifier {
  Future<ResponseFaqData> getBanners ({
    String? lang,
  }) async {
    var queryParams = {
      'lang': lang.toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}faq" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ResponseFaqData responseData = ResponseFaqData.fromJson(data);
      return responseData;
    } else {
      throw Exception();
    }
  }
}
