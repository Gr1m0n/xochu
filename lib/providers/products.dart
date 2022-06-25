import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xochuapp/strings/strings.dart';
import 'package:xochuapp/models/products_model.dart';

class ProductsProvider extends ChangeNotifier {
  Future<ResponseData> getProducts ({
    int? homepage,
    int? sale,
    int? soldout,
    int? catalog,
    String? id,
    String? lang,
  }) async {
    var queryParams = {
      'homepage': homepage.toString(),
      'sale': sale.toString(),
      'soldout': soldout.toString(),
      'catalog': catalog.toString(),
      'id': id.toString(),
      'lang': lang.toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}get-products" + '?' + queryString;
    final response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ResponseData responseData = ResponseData.fromJson(data);
      /*print("-----------------------------------------------------");
      print(responseData.data!.length);
      print(requestUrl);*/
      return responseData;
    } else {
      throw Exception();
    }
    notifyListeners();
  }
}