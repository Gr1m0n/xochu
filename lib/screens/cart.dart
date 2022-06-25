import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xochuapp/models/cart_model.dart';
import 'package:xochuapp/providers/cart.dart';
import 'package:xochuapp/screens/checkout.dart';
import 'package:xochuapp/screens/homepage.dart';
import 'package:xochuapp/strings/strings.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';

class Cart extends StatefulWidget {
  Function updateCartCounter;
  Cart(this.updateCartCounter);
  @override
  _CartState createState() => _CartState();
}
class _CartState extends State<Cart> {
  late Future fetchCart;
  late SharedPreferences logindata;
  String totalPrice = '0';
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_){
      getTotalPrice();
    });
    fetch();
    super.initState();
  }
  void didUpdateWidget(Widget oldWidget) {
    setState(() {
      fetch();
      getTotalPrice();
    });
  }
  void fetch() async {
    logindata = await SharedPreferences.getInstance();
    fetchCart = Provider.of<CartProvider>(context, listen: false).getCart(id: logindata.getInt('user_id').toString(), lang: translator.activeLanguageCode);
  }
  Future getTotalPrice() async {
    logindata = await SharedPreferences.getInstance();
    var queryParams = {
      'id': logindata.getInt('user_id').toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}gettotalprice" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      Map mapRes = json.decode(response.body);
      print(mapRes['totalPrice']);
      setState(() {
        totalPrice = mapRes['totalPrice'].toString();
      });
    }
  }
  Future<void> addToCart(String id, String qty) async {
    logindata = await SharedPreferences.getInstance();
    var queryParams = {
      'id': logindata.getInt('user_id').toString(),
      'qty': qty.toString(),
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
          "Количество товара обновлено!",
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
  Future<void> remove(String id) async {
    logindata = await SharedPreferences.getInstance();
    var queryParams = {
      'product': id.toString(),
      'id': logindata.getInt('user_id').toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}removecartitem" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      Map mapRes = json.decode(response.body);
      setState(() {
        this.widget.updateCartCounter(mapRes['total']);
      });
      if (mapRes['result'] == true) {
        setState(() {
          fetchCart = Provider.of<CartProvider>(context, listen: false).getCart(id: logindata.getInt('user_id').toString(), lang: translator.activeLanguageCode);
        });
        showToast(
          "Товар удален из корзины!",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/images/cart-heading.png",
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Корзина',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color(0xFF23262F),
                          fontSize: 20,
                          letterSpacing: 0.02,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(height:20),
                FutureBuilder(
                  future: fetchCart,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData)
                      return Column(
                        children: [
                          ListView.builder(
                            itemCount: snapshot.data.data.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              CartModel dataModel = snapshot.data.data[index];
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
                                    ),
                                    child: Image.network(
                                      "${AppStrings.localUrl}${dataModel.buyImage}",
                                      fit: BoxFit.contain,
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
                                          Container(
                                            decoration: new BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(50),
                                              border: Border.all(
                                                  width: 1.5,
                                                  color: Color(0xFFE6E8EC)),
                                            ),
                                            margin:EdgeInsets.only(right:20),
                                            child: TouchSpin(
                                              min: 1,
                                              max: 100,
                                              step: 1,
                                              value: num.parse(dataModel.quantity.toString()),
                                              textStyle: const TextStyle(fontSize: 17),
                                              iconSize: 30,
                                              addIcon: const Icon(Icons.add),
                                              subtractIcon: const Icon(Icons.remove),
                                              iconActiveColor: Color(0xFFB1B5C4),
                                              iconDisabledColor: Color(0xFFB1B5C4),
                                              onChanged: (val){
                                                addToCart(dataModel.id.toString(), val.toString());
                                                getTotalPrice();
                                              },
                                            ),
                                          ),
                                          FavoriteButton(
                                            isFavorite: false,
                                            iconSize: 40,
                                            iconDisabledColor: Colors.black12,
                                            valueChanged: (_isFavorite) {
                                              if(_isFavorite == true) {
                                                setWishlist(dataModel.id.toString());
                                              } else {
                                                removeWishlist(dataModel.id.toString());
                                              }
                                            },
                                          ),
                                          SizedBox(width: 10),
                                          IconButton(
                                            iconSize: 30,
                                            color: Color(0xFFB1B5C4),
                                            icon: Icon(Icons.delete),
                                            onPressed: (){
                                              remove(dataModel.id.toString());
                                            },
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ],
                              );
                            }
                          ),
                          Container(
                            width:MediaQuery.of(context).size.width,
                            padding:EdgeInsets.all(15),
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  width: 1.5, color: Color(0xFFF4F5F6)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Итого',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color(0xFF23262F),
                                      fontSize: 20,
                                      letterSpacing: 0.02,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${totalPrice.toString()} ₽',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color(0xFFFEDC00),
                                      fontSize: 20,
                                      letterSpacing: 0.02,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                              'В вашей корзине пусто? 😔',
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FutureBuilder(
        future: fetchCart,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData){
            return Container(
              width:MediaQuery.of(context).size.width,
              margin:EdgeInsets.symmetric(horizontal: 15),
              child: FloatingActionButton.extended(
                backgroundColor:Color(0xFFFEDC00),
                extendedPadding:EdgeInsets.symmetric(horizontal: 46,vertical: 11),
                label:Text(
                  "Продолжить".toUpperCase(),
                  style: TextStyle(
                      color: Color(0xFF101D27),
                      fontSize: 15,
                      letterSpacing: 0.02,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w800),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Checkout()),
                  );
                },
                heroTag: null,
              ),
            );
          } else {
            return Container();
          }
        }
      )
    );
  }
}