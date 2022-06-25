import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:oktoast/oktoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xochuapp/providers/products.dart';
import 'package:xochuapp/screens/homepage.dart';
import 'package:xochuapp/strings/strings.dart';

class Product extends StatefulWidget {
  final String? id;
  const Product(
      {Key? key, required this.id})
      : super(key: key);
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  late Future fetchProduct;
  late String date;
  late SharedPreferences logindata;

  void initState() {
    fetchProduct = Provider.of<ProductsProvider>(context, listen: false)
        .getProducts(id: widget.id.toString(), lang: translator.activeLanguageCode);
    super.initState();
  }

  Future<void> addToCart() async {
    logindata = await SharedPreferences.getInstance();
    var queryParams = {
      'id': logindata.getInt('user_id').toString(),
      'qty': '1',
      'product': widget.id.toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}addcartitem" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      Map mapRes = json.decode(response.body);
      if (mapRes['insert'] == true) {
        setState(() {
          //MyHomePage.totalCartItems = mapRes['total'];
        });
        showToast(
          "Добавлено в корзину!",
          duration: Duration(seconds: 5),
          position: ToastPosition.bottom,
          backgroundColor: Colors.green,
          radius: 24,
          textPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          textStyle: TextStyle(fontSize: 14.0, color: Colors.white),
        );
      } else {
        showToast(
          "Товар уже добавлен в корзину!",
          duration: Duration(seconds: 5),
          position: ToastPosition.bottom,
          backgroundColor: Colors.red,
          radius: 24,
          textPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          textStyle: TextStyle(fontSize: 14.0, color: Colors.black),
        );
      }
    }
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: true,
            backgroundColor: const Color(0xFF1B1D1F),
            elevation: 0,
            title: Text(
              "Товар",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  letterSpacing: 0.02,
                  fontWeight: FontWeight.w600),
            ),
            bottom: PreferredSize(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            topLeft: Radius.circular(30.0)),
                        color: const Color(0xFFF4F5F6),
                      ),
                      height: 15,
                      margin:EdgeInsets.only(top:10)
                    ),
                    Container(
                      width:MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F5F6),
                      ),
                      child: TabBar(
                          isScrollable: true,
                          unselectedLabelColor: Colors.grey.withOpacity(0.6),
                          indicatorColor: Colors.transparent,
                          labelColor: const Color(0xFF1B1D1F),
                          tabs: [
                            Tab(
                              child: Text(
                                "Общая информация",
                                style: TextStyle(
                                    fontSize: 13,
                                    letterSpacing: 0.02,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Детали приза",
                                style: TextStyle(
                                  fontSize: 13,
                                  letterSpacing: 0.02,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Информация",
                                style: TextStyle(
                                  fontSize: 13,
                                  letterSpacing: 0.02,
                                ),
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
                preferredSize: Size.fromHeight(55.0)
            ),
          ),
          body: FutureBuilder(
            future: fetchProduct,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                date = DateFormat.yMMMMd().format(
                    DateTime.parse(snapshot.data.data[0].timer.toString()));
                return TabBarView(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        child: Column(
                          textBaseline: TextBaseline.alphabetic,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Выиграй",
                              style: TextStyle(
                                  color: Color(0xFF3B71FE),
                                  fontSize: 17,
                                  letterSpacing: 0.02,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "${snapshot.data.data[0].translation?.winTitle
                                  .toString()}",
                              style: TextStyle(
                                  color: Color(0xFF23262F),
                                  fontSize: 20,
                                  letterSpacing: 0.02,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Крайний срок: ${date} или когда все лоты будут раскуплены',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color(0xFF777E91),
                                fontSize: 10,
                                letterSpacing: 0.02,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(0xFFE6E8EC),
                                      ),
                                    ),
                                    child: FavoriteButton(
                                      isFavorite: false,
                                      iconDisabledColor: Colors.black12,
                                      iconSize: 33,
                                      valueChanged: (_isFavorite) {

                                      },
                                    )
                                ),
                                SizedBox(width: 16),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20)),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color(0xFFE6E8EC),
                                    ),
                                  ),
                                  child:TextButton(
                                    onPressed: () {
                                      Share.share('${AppStrings.localUrl}/product?id=${widget.id.toString()}&language=${translator.activeLanguageCode}');
                                    },
                                    child:Icon(Icons.share, color: Color(0xFFE6E8EC), size: 20,),
                                  )
                                ),
                              ],
                            ),
                            Divider(
                              height: 45,
                              thickness: 1,
                              endIndent: 0,
                              color: Color(0xFFE6E8EC),
                            ),
                            Container(
                              width:MediaQuery.of(context).size.width,
                              margin:EdgeInsets.only(bottom:16),
                              padding:EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20)),
                                color: Colors.white,
                                border: Border.all(
                                  color: Color(0xFFE6E8EC),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Стоимость',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Color(0xFF1B1D1F),
                                        fontSize: 15,
                                        letterSpacing: 0.02,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w800
                                    ),
                                  ),
                                  Text(
                                    '₽ ${snapshot.data.data[0].price.toString()}',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color(0xFF3B71FE),
                                        fontSize: 15,
                                        letterSpacing: 0.02,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w800
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Уважаемый клиент, за доставку взимается отдельная плата в размере ₽ ${snapshot.data.data[0].deliveryPrice.toString()}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0xFF777E91),
                                  fontSize: 11,
                                  letterSpacing: 0.02,
                              ),
                            ),
                            SizedBox(height:16),
                            Center(
                              child: TextButton(
                                  child: Text("Хочу".toUpperCase(),
                                      style: TextStyle(
                                          color: Color(0xFF101D27),
                                          fontSize: 13,
                                          letterSpacing: 0.04,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w800)),
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.symmetric(
                                              horizontal: 75, vertical: 12)),
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(Colors.white),
                                      backgroundColor: MaterialStateProperty.all<Color>(
                                          Color(0xFFFEDC00)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(24.0),
                                              side:
                                              BorderSide(color: Color(0xFFFEDC00))))),
                                  onPressed: () {
                                    addToCart();
                                  }),
                            ),
                            SizedBox(height:24),
                            Stack(children: [
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 45, bottom: 20),
                                  padding: EdgeInsets.all(16),
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
                                  child: Column(
                                    textBaseline: TextBaseline.alphabetic,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Image.network(
                                        "${AppStrings.localUrl}${snapshot.data.data[0].prizeImage.toString()}",
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(height:30),
                                      Text(
                                        'Купи',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF1B1D1F),
                                            fontSize: 15,
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: 0.02,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        '${snapshot.data.data[0].translation?.buyTitle
                                            .toString()}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF3B71FE),
                                            fontSize: 17,
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: 0.02,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 5),
                                      HtmlWidget('${snapshot.data.data[0].translation?.buyBody.toString()}')
                                    ],
                                  )),
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  right:0,
                                  child: CircularPercentIndicator(
                                    radius: 45.0,
                                    animation: false,
                                    animationDuration: 1200,
                                    lineWidth: 7.0,
                                    percent: 0.7,
                                    center: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '0 / ${snapshot.data.data[0].tickets.toString()}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF1B1D1F),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.02,
                                          ),
                                        ),
                                        Text(
                                          'продано ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF777E91),
                                            fontSize: 11,
                                            letterSpacing: 0.02,
                                          ),
                                        ),
                                      ],
                                    ),
                                    circularStrokeCap: CircularStrokeCap.butt,
                                    backgroundColor: Color(0xFFF4F5F6),
                                    progressColor: Color(0xFF22DE63),
                                    fillColor: Colors.white,
                                  )),
                            ]),
                            SizedBox(height:12),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 45, bottom: 20),
                                padding: EdgeInsets.all(16),
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
                                child: Column(
                                  textBaseline: TextBaseline.alphabetic,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Image.network(
                                      "${AppStrings.localUrl}${snapshot.data.data[0].prizeImage.toString()}",
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(height:30),
                                    Text(
                                      'Выиграй',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF1B1D1F),
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic,
                                          letterSpacing: 0.02,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      '${snapshot.data.data[0].translation?.winTitle
                                          .toString()}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF3B71FE),
                                          fontSize: 17,
                                          fontStyle: FontStyle.italic,
                                          letterSpacing: 0.02,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: 5),
                                    HtmlWidget('${snapshot.data.data[0].translation?.winBody.toString()}')
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        color: Color(0xFFF9FAFB),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                          child: Column(
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Детали приза",
                                style: TextStyle(
                                    color: Color(0xFF101D27),
                                    fontSize: 17,
                                    letterSpacing: 0.02,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height:12),
                              Container(
                                width: 150,
                                height: 150,
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
                                  "${AppStrings.localUrl}${snapshot.data.data[0].prizeImage.toString()}",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height:12),
                              Text(
                                "${snapshot.data.data[0].translation?.winTitle
                                    .toString()}",
                                style: TextStyle(
                                    color: Color(0xFF3B71FE),
                                    fontSize: 15,
                                    letterSpacing: 0.02,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height:12),
                              HtmlWidget('${snapshot.data.data[0].translation?.winBody.toString()}')
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        color: Color(0xFFF9FAFB),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                          child: Column(
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Информация о продукте",
                                style: TextStyle(
                                    color: Color(0xFF101D27),
                                    fontSize: 17,
                                    letterSpacing: 0.02,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height:12),
                              Container(
                                width: 150,
                                height: 150,
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
                                  "${AppStrings.localUrl}${snapshot.data.data[0].buyImage.toString()}",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height:12),
                              Text(
                                "${snapshot.data.data[0].translation?.buyTitle
                                    .toString()}",
                                style: TextStyle(
                                    color: Color(0xFF3B71FE),
                                    fontSize: 15,
                                    letterSpacing: 0.02,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height:12),
                              HtmlWidget('${snapshot.data.data[0].translation?.buyBody.toString()}')
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          ),
          floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  backgroundColor:Color(0xFFFEDC00),
                  extendedPadding:EdgeInsets.symmetric(horizontal: 46,vertical: 11),
                  label:Text(
                    "Хочу",
                    style: TextStyle(
                        color: Color(0xFF101D27),
                        fontSize: 15,
                        letterSpacing: 0.02,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w800),
                  ),
                  onPressed: () {
                    addToCart();
                  },
                  heroTag: null,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  padding:EdgeInsets.all(11),
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                        width: 1.5, color: Color(0xFFB1B5C3)),
                  ),
                  child:FavoriteButton(
                    isFavorite: false,
                    iconDisabledColor: Colors.black12,
                    iconSize: 40,
                    valueChanged: (_isFavorite) {

                    },
                  )
                ),
              ]
          ),
      ),
    );
  }
}