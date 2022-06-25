import 'dart:convert';
import 'dart:io';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xochuapp/screens/homepage.dart';
import 'package:xochuapp/screens/product.dart';
import 'package:xochuapp/screens/video.dart';
import 'package:xochuapp/screens/wishlist.dart';
import 'package:xochuapp/strings/strings.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:xochuapp/models/products_model.dart';
import 'package:xochuapp/models/banners_model.dart';
import 'package:xochuapp/models/xochu_model.dart';
import 'package:xochuapp/models/winners_model.dart';
import 'package:xochuapp/providers/banners.dart';
import 'package:xochuapp/providers/products.dart';
import 'package:xochuapp/providers/xochu.dart';
import 'package:xochuapp/providers/winners.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Home extends StatefulWidget {
  Function updateCartCounter;
  Home(this.updateCartCounter);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  late Future fetchTopBanners;
  late Future fetchMiddleBanners;
  late Future fetchCharityBanners;
  late Future fetchSaleProducts;
  late Future fetchPrizeProducts;
  late Future fetchSoldoutProducts;
  late Future fetchXochuProducts;
  late Future fetchWinners;
  late SharedPreferences logindata;
  late YoutubePlayerController _winner;

  void initState() {
    fetchTopBanners = Provider.of<BannersProvider>(context, listen: false)
        .getBanners(position: 1, lang: translator.activeLanguageCode);
    fetchMiddleBanners = Provider.of<BannersProvider>(context, listen: false)
        .getBanners(position: 2, lang: translator.activeLanguageCode);
    fetchCharityBanners = Provider.of<BannersProvider>(context, listen: false)
        .getBanners(position: 4, lang: translator.activeLanguageCode);
    fetchSaleProducts = Provider.of<ProductsProvider>(context, listen: false)
        .getProducts(sale: 1, lang: translator.activeLanguageCode);
    fetchPrizeProducts = Provider.of<ProductsProvider>(context, listen: false)
        .getProducts(homepage: 1, lang: translator.activeLanguageCode);
    fetchSoldoutProducts = Provider.of<ProductsProvider>(context, listen: false)
        .getProducts(soldout: 1, lang: translator.activeLanguageCode);
    fetchXochuProducts = Provider.of<XochuProvider>(context, listen: false)
        .getProducts(lang: translator.activeLanguageCode);
    fetchWinners = Provider.of<WinnersProvider>(context, listen: false)
        .getWinners(limit: 8);
    super.initState();
  }

  void didUpdateWidget(Widget oldWidget) {
    setState(() {
      fetchPrizeProducts = Provider.of<ProductsProvider>(context, listen: false)
          .getProducts(homepage: 1, lang: translator.activeLanguageCode);
    });
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
      setState(() {
        this.widget.updateCartCounter(mapRes['total']);
      });
      if (mapRes['insert'] == true) {
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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FutureBuilder(
              future: fetchTopBanners,
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
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 45),
            decoration: new BoxDecoration(
              //color: Colors.white,
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
                ),
                SizedBox(height: 30),
                FutureBuilder(
                    future: fetchMiddleBanners,
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData)
                        return CarouselSlider.builder(
                            itemCount: snapshot.data.data.length,
                            options: CarouselOptions(
                                autoPlay: true,
                                disableCenter: true,
                                enlargeCenterPage: false,
                                viewportFraction: 1.0,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                }
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
                                  margin: EdgeInsets.only(top: 10, right:15),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(18)),
                                    child: Image.network(
                                      "${AppStrings.localUrl}${bannersData.translation?.mobile}",
                                      fit: BoxFit.contain,
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
                ),
                SizedBox(height: 30),
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
                          bool _isFavorite = false;
                          DataModel dataModel = snapshot.data.data[index];
                          var date = DateFormat.yMMMMd().format(DateTime.parse(dataModel.timer.toString()));
                          return Stack(key: UniqueKey(),children: [
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
                                    SizedBox(height:5),
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
                                              MaterialPageRoute(builder: (context) => Product(id:dataModel.id)),
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
                              child: IconButton(
                                icon:Icon(
                                  Icons.favorite,
                                  color: _isFavorite == true ? Colors.redAccent : Colors.grey,
                                  size:45,
                                ),
                                onPressed: () {
                                    if(_isFavorite == false) {
                                      setWishlist(dataModel.id.toString());
                                      setState(() {
                                        _isFavorite = true;
                                      });
                                    } else {
                                      removeWishlist(dataModel.id.toString());
                                      setState(() {
                                        _isFavorite = false;
                                      });
                                    }
                                },),
                            ),
                            /*Positioned(
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
                            ),*/
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
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 24, top: 20, bottom: 24),
            decoration: new BoxDecoration(
              color: Color(0xFFF4F5F6),
            ),
            child:Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/images/icon1.png",
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Распродано',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          letterSpacing: 0.02,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height:15),
                Text(
                  'Здесь перечислены все наши распроданные кампании с соответствующими датами розыгрыша.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color(0xFF777E91),
                      fontSize: 16,
                      letterSpacing: 0.02,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height:20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  child:FutureBuilder(
                    future: fetchSoldoutProducts,
                    builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData)
                        return ListView.builder(
                          itemCount: snapshot.data.data.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            DataModel dataModel = snapshot.data.data[index];
                            var date = DateFormat.yMMMMd().format(DateTime.parse(dataModel.drawDate.toString()));
                            return Stack(
                              children: [
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 1.4,
                                  height: 340,
                                  margin: EdgeInsets.only(top: 21, right: 20),
                                  padding: EdgeInsets.all(20),
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
                                          0.0,
                                          // Move to right 10  horizontally
                                          10.0, // Move to bottom 10 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    textBaseline: TextBaseline.alphabetic,
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'дата розыгрыша:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Color(0xFF1B1D1F),
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.02,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '${date}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Color(0xFF3B71FE),
                                          fontSize: 22,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.02,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Stack(
                                        children: [
                                          ColorFiltered(
                                            colorFilter: ColorFilter.mode(
                                              Colors.grey,
                                              BlendMode.saturation,
                                            ),
                                            child: Image.network(
                                              "${AppStrings.localUrl}${dataModel.prizeImage}",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top:0,
                                            left:0,
                                            child: Image.asset('assets/images/soldout.png'),
                                          )
                                        ]
                                      ),
                                      SizedBox(height: 10),
                                      HtmlWidget('${dataModel.translation?.prizeBody.toString()}')
                                    ],
                                  ),
                                ),
                                Positioned(
                                    bottom: 20,
                                    left: -10,
                                    right: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50),
                                      child: OutlinedButton(
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Product(id:dataModel.id)),
                                          );
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
                                          "ДЕТАЛИ ПРИЗА",
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
                ))
              ],
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 24, top: 20, bottom: 24),
            decoration: new BoxDecoration(
              color: Color(0xFF1B1D1F),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/images/icon1.png",
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Поздравляем победителей!',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
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
                    future: fetchWinners,
                    builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData)
                        return ListView.builder(
                            itemCount: snapshot.data.data.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              WinnersModel dataModel = snapshot.data.data[index];
                              return Stack(
                                children: [
                                  Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 1.4,
                                    height: 340,
                                    margin: EdgeInsets.only(top: 21, right: 20),
                                    padding: EdgeInsets.all(20),
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
                                            0.0,
                                            // Move to right 10  horizontally
                                            10.0, // Move to bottom 10 Vertically
                                          ),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      textBaseline: TextBaseline.alphabetic,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Image.network(
                                          "${AppStrings.localUrl}${dataModel.image}",
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          'Поздравляем!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color(0xFF3B71FE),
                                              fontSize: 15,
                                              letterSpacing: 0.02,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '${dataModel.user} с выигрышем ${dataModel.title}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF1B1D1F),
                                            fontSize: 13,
                                            letterSpacing: 0.02,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Coupon no: ${dataModel.coupon}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF777E91),
                                            fontSize: 11,
                                            letterSpacing: 0.02,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 20,
                                      left: -10,
                                      right: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: OutlinedButton(
                                          onPressed: (){
                                            var videoId = YoutubePlayer.convertUrlToId("${dataModel.youtube.toString()}");
                                            _winner = YoutubePlayerController(
                                              initialVideoId: videoId.toString(),
                                              flags: YoutubePlayerFlags(
                                                autoPlay: true,
                                                mute: false,
                                              ),
                                            );
                                            NDialog(
                                              dialogStyle: DialogStyle(),
                                              content: Padding(
                                                padding: const EdgeInsets.only(top:15),
                                                child: YoutubePlayer(
                                                  controller: _winner,
                                                  showVideoProgressIndicator: true,
                                                ),
                                              ),
                                            ).show(context);
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
                                            "НАГРАЖДЕНИЕ",
                                            style: TextStyle(
                                                color: Color(0xFF101D27),
                                                fontSize: 16,
                                                letterSpacing: 0.02,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      )),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: NetworkImage(
                                          'https://via.placeholder.com/150'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  )
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
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 45),
            decoration: new BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/icon1.png",
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Товары Хочу',
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
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    child: FutureBuilder(
                        future: fetchXochuProducts,
                        builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData)
                            return ListView.builder(
                                itemCount: snapshot.data.data.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  XochuProducts dataModel = snapshot.data.data[index];
                                  return Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 1.4,
                                    height: 250,
                                    margin: EdgeInsets.only(top: 21, right: 20),
                                    padding: EdgeInsets.all(20),
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
                                      crossAxisAlignment: CrossAxisAlignment
                                          .baseline,
                                      children: [
                                        Text(
                                          '${dataModel.translation?.title}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color(0xFF1B1D1F),
                                              fontSize: 17,
                                              letterSpacing: 0.02,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '₽ ${dataModel.price}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color(0xFF3B71FE),
                                              fontSize: 17,
                                              fontStyle: FontStyle.italic,
                                              letterSpacing: 0.02,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        SizedBox(height: 32),
                                        Image.network(
                                          "${AppStrings.localUrl}${dataModel.image}",
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            );
                          else
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        }
                    ),
                  ),
                ),
              ],
            )
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
          ),
        ],
      ),
    );
  }
}
