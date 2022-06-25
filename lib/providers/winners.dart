import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xochuapp/strings/strings.dart';
import 'package:xochuapp/models/winners_model.dart';

class WinnersProvider extends ChangeNotifier {
  Future<ResponseWinnersData> getWinners ({
    int? limit,
  }) async {
    var queryParams = {
      'limit': limit.toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}winners" + '?' + queryString;
    final response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ResponseWinnersData responseData = ResponseWinnersData.fromJson(data);
      return responseData;
    } else {
      throw Exception();
    }
  }
}