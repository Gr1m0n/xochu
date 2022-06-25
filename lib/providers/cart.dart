import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xochuapp/strings/strings.dart';
import 'package:xochuapp/models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  Future<ResponseCartData> getCart({
    String? lang,
    String? id,
  }) async {
    var queryParams = {
      'id': id.toString(),
      'lang': lang.toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}cart" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ResponseCartData responseData = ResponseCartData.fromJson(data);
      return responseData;
    } else {
      throw Exception();
    }
    notifyListeners();
  }
}
