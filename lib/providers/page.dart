import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xochuapp/strings/strings.dart';
import 'package:xochuapp/models/page_model.dart';

class PageProvider extends ChangeNotifier {
  Future<ResponsePageData> getPage ({
    int? id,
    String? lang,
  }) async {
    var queryParams = {
      'id': id.toString(),
      'lang': lang.toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}page" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ResponsePageData responseData = ResponsePageData.fromJson(data);
      /*print("-----------------------------------------------------");
      print(responseData.data!.length);
      print(requestUrl);*/
      return responseData;
    } else {
      throw Exception();
    }
  }
}
