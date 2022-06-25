import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xochuapp/models/wishlist_model.dart';
import 'package:xochuapp/providers/wishlist.dart';
import 'package:xochuapp/strings/strings.dart';
import 'package:favorite_button/favorite_button.dart';

class Wishlist extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  late Future fetchWishlist;
  late SharedPreferences logindata;
  void initState() {
    fetchWishlist = Provider.of<WishlistProvider>(context, listen: false)
        .getWishlist(lang: translator.activeLanguageCode);
    super.initState();
  }
  void didUpdateWidget(Widget oldWidget) {
    setState(() {
      fetchWishlist = Provider.of<WishlistProvider>(context, listen: false)
          .getWishlist(lang: translator.activeLanguageCode);
    });
  }
  Future<void> removeWishlist(String id) async {
    logindata = await SharedPreferences.getInstance();
    var queryParams = {
      'item': id.toString(),
      'id': logindata.getInt('user_id').toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}remove-wishlist" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      Map mapRes = json.decode(response.body);
      if (mapRes['response'] == true) {
        setState(() {
          fetchWishlist = Provider.of<WishlistProvider>(context, listen: false)
              .getWishlist(lang: translator.activeLanguageCode);
        });
        showToast(
          "Удалено из избранного!",
          duration: Duration(seconds: 5),
          position: ToastPosition.bottom,
          backgroundColor: Colors.green,
          radius: 24,
          textPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          textStyle: TextStyle(fontSize: 14.0, color: Colors.white),
        );
      }
    }
  }
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          textBaseline: TextBaseline.alphabetic,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Text(
              'Избранное',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color(0xFF1B1D1F),
                  fontSize: 17,
                  letterSpacing: 0.02,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 16),
            FutureBuilder(
              future: fetchWishlist,
              builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData)
                  return ListView.builder(
                    itemCount: snapshot.data.data.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      WishlistModel dataModel = snapshot.data.data[index];
                      return Row(
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.only(right: 15),
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(width: 1.5, color: Color(0xFFF4F5F6)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(.3),
                                  blurRadius: 10.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(
                                    0.0, // Move to right 10  horizontally
                                    10.0, // Move to bottom 10 Vertically
                                  ),
                                )
                              ],
                            ),
                            child: Image.network(
                              "${AppStrings.localUrl}${dataModel.buyImage}",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Column(
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: [
                              Text(
                                '${dataModel.title.toString()}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF23262F),
                                  fontSize: 13,
                                  letterSpacing: 0.02,
                                ),
                              ),
                              Text(
                                '₽ ${dataModel.price}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color(0xFF3B71FE),
                                    fontSize: 15,
                                    letterSpacing: 0.02,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w800),
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    padding: EdgeInsets.all(12),
                                    margin: EdgeInsets.only(right: 15),
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          width: 1.5, color: Color(0xFFF4F5F6)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(.3),
                                          blurRadius: 10.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(
                                            0.0, // Move to right 10  horizontally
                                            10.0, // Move to bottom 10 Vertically
                                          ),
                                        )
                                      ],
                                    ),
                                    child: Image.network(
                                      "${AppStrings.localUrl}${dataModel.winImage}",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Column(
                                    textBaseline: TextBaseline.alphabetic,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    children: [
                                      Text('0 из ${dataModel.tickets}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color(0xFF1B1D1F),
                                              fontSize: 11,
                                              letterSpacing: 0.02,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(height: 8),
                                      Container(
                                        width: 100,
                                        height: 6,
                                        decoration: new BoxDecoration(
                                          color: Color(0xFFFCD225),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text('макс. время розыгрыша:',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Color(0xFF777E91),
                                            fontSize: 10,
                                            letterSpacing: 0.02,
                                          )),
                                      Text('${dataModel.timer}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Color(0xFF777E91),
                                            fontSize: 10,
                                            letterSpacing: 0.02,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    onPressed: null,
                                    style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 35),
                                        backgroundColor: Colors.white,
                                        side: BorderSide(width: 1.0, color: Colors.black),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(24))),
                                    child: const Text(
                                      "ХОЧУ",
                                      style: TextStyle(
                                          color: Color(0xFF101D27),
                                          fontSize: 16,
                                          letterSpacing: 0.02,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  SizedBox(width:20),
                                  FavoriteButton(
                                    isFavorite: true,
                                    iconDisabledColor: Colors.black12,
                                    valueChanged: (_isFavorite) {
                                      removeWishlist(dataModel.id.toString());
                                    },
                                  )
                                ],
                              ),
                              SizedBox(height:25),
                            ],
                          ),
                        ],
                      );
                    }
                  );
                else
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(32),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          width: 1, color: Color(0xFFE6E8EC)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'В избранном пусто? 😔',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xFF1B1D1F),
                              fontSize: 17,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 0.02,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height:10),
                        Text(
                          'Это не страшно! Вы всегда можете ее наполнить',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xFF777E91),
                              fontSize: 13,
                              letterSpacing: 0.02,
                          ),
                        ),
                      ],
                    ),
                  );
              }
            ),
          ],
        ),
      ),
    );
  }
}
