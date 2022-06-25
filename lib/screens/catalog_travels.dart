import 'dart:convert';
import 'dart:io';
import 'package:favorite_button/favorite_button.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:oktoast/oktoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xochuapp/models/banners_model.dart';
import 'package:xochuapp/models/products_model.dart';
import 'package:xochuapp/providers/banners.dart';
import 'package:xochuapp/providers/page.dart';
import 'package:xochuapp/providers/products.dart';
import 'package:xochuapp/screens/homepage.dart';
import 'package:xochuapp/screens/product.dart';
import 'package:xochuapp/widgets/appbar.dart';
import 'package:xochuapp/strings/strings.dart';

class CatalogTravels extends StatefulWidget {
  @override
  _CatalogTravelsState createState() => _CatalogTravelsState();
}
class _CatalogTravelsState extends State<CatalogTravels> {
  late Future fetchCharityBanners;
  late Future fetchSaleProducts;
  late Future fetchPrizeProducts;
  late Future fetchPage;
  late SharedPreferences logindata;
  void initState() {
    fetchPage = Provider.of<PageProvider>(context, listen: false)
        .getPage(id: 5, lang: translator.activeLanguageCode);
    fetchCharityBanners = Provider.of<BannersProvider>(context, listen: false)
        .getBanners(position: 4, lang: translator.activeLanguageCode);
    fetchSaleProducts = Provider.of<ProductsProvider>(context, listen: false)
        .getProducts(sale: 4, lang: translator.activeLanguageCode);
    fetchPrizeProducts = Provider.of<ProductsProvider>(context, listen: false)
        .getProducts(catalog: 1, lang: translator.activeLanguageCode);
    super.initState();
  }
  Future<void> addToCart(String id) async {
    logindata = await SharedPreferences.getInstance();
    var queryParams = {
      'id': logindata.getInt('user_id').toString(),
      'qty': '1',
      'product': id.toString(),
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
  Future<void> setWishlist(String id) async {
    logindata = await SharedPreferences.getInstance();
    var queryParams = {
      'item': id.toString(),
      'id': logindata.getInt('user_id').toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}add-wishlist" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      Map mapRes = json.decode(response.body);
      if (mapRes['response'] == true) {
        showToast(
          "Добавлено в избранное!",
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBarWidget(title: 'Путешествия'),
      ),
      body: SingleChildScrollView(
        child: Column(
          textBaseline: TextBaseline.alphabetic,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
              Container(
                decoration: BoxDecoration(color: Colors.white),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 24),
                padding: EdgeInsets.all(24),
                child: Column(
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder(
                        future: fetchPage,
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData)
                            return Image.network(
                              "${AppStrings.localUrl}${snapshot.data.data[0].translation?.mobileImage.toString()}",
                              fit: BoxFit.cover,
                            );
                          else
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        }
                    ),
                    SizedBox(height:40),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/icon1.png",
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Скоро будет распродано',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 18,
                              letterSpacing: 0.02,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      child: FutureBuilder(
                          future: fetchSaleProducts,
                          builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData)
                              return ListView.builder(
                                  itemCount: snapshot.data.data.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    DataModel dataModel = snapshot.data.data[index];
                                    return Stack(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width / 1.4,
                                          height: 340,
                                          margin: EdgeInsets.only(
                                              top: 21, right: 20),
                                          padding: EdgeInsets.all(20),
                                          decoration: new BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                                width: 1.5,
                                                color: Color(0xFFF4F5F6)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(.3),
                                                blurRadius: 10.0,
                                                spreadRadius: 0.0,
                                                offset: Offset(
                                                  0.0,
                                                  // Move to right 10  horizontally
                                                  10.0, // Move to bottom 10 Vertically
                                                ),
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            textBaseline: TextBaseline.alphabetic,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.baseline,
                                            children: [
                                              Text(
                                                'Получи',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color(0xFF1B1D1F),
                                                    fontSize: 15,
                                                    fontStyle: FontStyle.italic,
                                                    letterSpacing: 0.02,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              Text(
                                                '₽ ${dataModel.price}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color(0xFF3B71FE),
                                                    fontSize: 17,
                                                    fontStyle: FontStyle.italic,
                                                    letterSpacing: 0.02,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              SizedBox(height:15),
                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => Product(id:dataModel.id)),
                                                  );
                                                },
                                                child: Image.network(
                                                  "${AppStrings.localUrl}${dataModel.prizeImage}",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(height:15),
                                              Text(
                                                'Купите ${dataModel.translation?.buyTitle} и получите шанс выиграть этот приз',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Color(0xFF1B1D1F),
                                                  fontSize: 13,
                                                  letterSpacing: 0.02,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: Column(
                                            children: [
                                              Text(
                                                '0 продано из ${dataModel.tickets}',
                                                style: TextStyle(
                                                  color: Color(0xFF1B1D1F),
                                                  fontSize: 13,
                                                  letterSpacing: 0.02,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 15, right: 35, top: 5),
                                                height: 6,
                                                decoration: new BoxDecoration(
                                                  color: Color(0xFFF34C17),
                                                  borderRadius: BorderRadius
                                                      .circular(16),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 20,
                                            left: 0,
                                            right: 0,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 50),
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  addToCart(dataModel.id.toString());
                                                },
                                                style: OutlinedButton.styleFrom(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 16),
                                                    backgroundColor: Colors.white,
                                                    side: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.black),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(24))),
                                                child: const Text(
                                                  "ХОЧУ",
                                                  style: TextStyle(
                                                      color: Color(0xFF101D27),
                                                      fontSize: 16,
                                                      letterSpacing: 0.02,
                                                      fontStyle: FontStyle.italic,
                                                      fontWeight: FontWeight.w800),
                                                ),
                                              ),
                                            )),
                                      ],
                                    );
                                  }
                              );
                            else
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                          }

                      ),
                    )
                  ]
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 45),
                decoration: new BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Покупая у нас вы имеете возможность:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF101D27),
                            fontSize: 20,
                            letterSpacing: 0.02,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 350,
                      margin: EdgeInsets.only(top: 24),
                      padding: EdgeInsets.only(top: 18, bottom: 18, left: 15),
                      decoration: new BoxDecoration(
                        color: Color(0xFFF4F5F6),
                      ),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            margin: EdgeInsets.only(right: 20),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/features1.png",
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Получать призы',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF101D27),
                                      fontSize: 15,
                                      letterSpacing: 0.02,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Покупайте товарыи получайте ценные призы',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF777E91),
                                    fontSize: 13,
                                    letterSpacing: 0.02,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            margin: EdgeInsets.only(right: 20),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/features2.png",
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Путешествовать',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF101D27),
                                      fontSize: 15,
                                      letterSpacing: 0.02,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'В качестве приза может быть и путешествие',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF777E91),
                                    fontSize: 13,
                                    letterSpacing: 0.02,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            margin: EdgeInsets.only(right: 20),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/features3.png",
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Пожертвовать',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF101D27),
                                      fontSize: 15,
                                      letterSpacing: 0.02,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'После выигрыша приза вы можете его пожертвовать',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF777E91),
                                    fontSize: 13,
                                    letterSpacing: 0.02,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/icon1.png",
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Получай призы',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 18,
                              letterSpacing: 0.02,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    FutureBuilder(
                        future: fetchPrizeProducts,
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData)
                            return ListView.builder(
                                itemCount: snapshot.data.data.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  DataModel dataModel = snapshot.data.data[index];
                                  var date = DateFormat.yMMMMd().format(DateTime.parse(dataModel.timer.toString()));
                                  return Stack(children: [
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
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                          children: [
                                            Image.network(
                                              "${AppStrings.localUrl}${dataModel.prizeImage}",
                                              fit: BoxFit.cover,
                                            ),
                                            SizedBox(height:10),
                                            Text(
                                              'Получи',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color(0xFF1B1D1F),
                                                  fontSize: 18,
                                                  fontStyle: FontStyle.italic,
                                                  letterSpacing: 0.02,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              '${dataModel.translation?.winTitle}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color(0xFF3B71FE),
                                                  fontSize: 24,
                                                  fontStyle: FontStyle.italic,
                                                  letterSpacing: 0.02,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Купите ${dataModel.translation?.buyTitle} и получите шанс выиграть этот приз',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Color(0xFF1B1D1F),
                                                fontSize: 13,
                                                letterSpacing: 0.02,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Всего за ${dataModel.price}₽',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color(0xFF54524A),
                                                  fontSize: 15,
                                                  letterSpacing: 0.02,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                OutlinedButton(
                                                  onPressed: (){
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => Product(id:dataModel.id.toString())),
                                                    );
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: 12, horizontal: 23),
                                                      backgroundColor: Colors.white,
                                                      side: BorderSide(
                                                          width: 1.0, color: Colors.black),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(24))),
                                                  child: const Text(
                                                    "ДЕТАЛИ",
                                                    style: TextStyle(
                                                        color: Color(0xFF101D27),
                                                        fontSize: 16,
                                                        letterSpacing: 0.02,
                                                        fontStyle: FontStyle.italic,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ),
                                                OutlinedButton(
                                                  onPressed: (){
                                                    addToCart(dataModel.id.toString());
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: 12, horizontal: 70),
                                                      backgroundColor: Color(0xFFFEDC00),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(24))),
                                                  child: const Text(
                                                    "ХОЧУ",
                                                    style: TextStyle(
                                                        color: Color(0xFF101D27),
                                                        fontSize: 16,
                                                        letterSpacing: 0.02,
                                                        fontStyle: FontStyle.italic,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Крайний срок: ${date} или когда все лоты будут раскуплены',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Color(0xFF777E91),
                                                fontSize: 10,
                                                letterSpacing: 0.02,
                                              ),
                                            ),
                                          ],
                                        )),
                                    Positioned(
                                      top: 55,
                                      right: 24,
                                      child: FavoriteButton(
                                        isFavorite: false,
                                        iconDisabledColor: Colors.black12,
                                        valueChanged: (_isFavorite) {
                                          if(_isFavorite == true) {
                                            setWishlist(dataModel.id.toString());
                                          } else {
                                            removeWishlist(dataModel.id.toString());
                                          }
                                        },
                                      ),
                                    ),
                                    Positioned(
                                        top: 0,
                                        left: 15,
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
                                                '0 / ${dataModel.tickets}',
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
                                  ]);
                                }
                            );
                          else
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        }
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Text(
                      'Филиалы и благотворительные организации',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFF101D27),
                          fontSize: 17,
                          letterSpacing: 0.02,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 16),
                    FutureBuilder(
                        future: fetchCharityBanners,
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData)
                            return CarouselSlider.builder(
                                itemCount: snapshot.data.data.length,
                                options: CarouselOptions(
                                  autoPlay: true,
                                  aspectRatio: 2.0,
                                  enlargeCenterPage: true,
                                ),
                                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                                  BannersModel bannersData = snapshot.data.data[itemIndex];
                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Product(id:bannersData.productID)),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(18)),
                                        child: Image.network(
                                          "${AppStrings.localUrl}${bannersData.translation?.mobile}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            );
                          else
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        }
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}