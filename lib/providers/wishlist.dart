import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xochuapp/strings/strings.dart';
import 'package:xochuapp/models/wishlist_model.dart';

class WishlistProvider extends ChangeNotifier {
  late SharedPreferences logindata;
  Future<ResponseWishlistData> getWishlist({
    String? lang,
  }) async {
    logindata = await SharedPreferences.getInstance();
    var queryParams = {
      'lang': lang.toString(),
      'id': logindata.getInt('user_id').toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}wishlist" + '?' + queryString;
    final response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ResponseWishlistData responseData = ResponseWishlistData.fromJson(data);
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
