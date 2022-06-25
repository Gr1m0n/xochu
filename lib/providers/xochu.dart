import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xochuapp/strings/strings.dart';
import 'package:xochuapp/models/xochu_model.dart';

class XochuProvider extends ChangeNotifier {
  Future<ResponseXochuData> getProducts ({
    String? lang,
  }) async {
    var queryParams = {
      'lang': lang.toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}get-xochu-products" + '?' + queryString;
    final response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ResponseXochuData responseData = ResponseXochuData.fromJson(data);
      return responseData;
    } else {
      throw Exception();
    }
  }
}