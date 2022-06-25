import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xochuapp/screens/about.dart';
import 'package:xochuapp/screens/contacts.dart';
import 'package:xochuapp/screens/home.dart';
import 'package:xochuapp/screens/login.dart';
import 'package:xochuapp/screens/notifications.dart';
import 'package:xochuapp/screens/winners.dart';
import 'package:xochuapp/screens/wishlist.dart';
import 'package:xochuapp/screens/cart.dart';
import 'package:xochuapp/screens/profile.dart';
import 'package:xochuapp/screens/coupons.dart';
import 'package:xochuapp/screens/faq.dart';
import 'package:xochuapp/screens/catalog_travels.dart';
import 'package:xochuapp/screens/catalog_xochu.dart';
import 'package:bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:xochuapp/strings/strings.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _advancedDrawerController = AdvancedDrawerController();
  late SharedPreferences logindata;
  late Coupons couponsPage;
  late Cart cartPage;
  int totalCartItems = 0;
  int currentIndex = 0;

  void initState() {
    preAuth();
    couponsPage = Coupons(this.callback);
    cartPage = Cart(this.updateCart);
    super.initState();
  }

  void updateCart(int changeQty) {
    setState(() {
      this.totalCartItems = changeQty;
    });
  }
  void callback(int changeIndex) {
    setState(() {
      this.currentIndex = changeIndex;
    });
  }

  Future<void> preAuth() async {
    logindata = await SharedPreferences.getInstance();
    var queryParams = {
      'id': logindata.getInt('user_id').toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}gettotal" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      Map mapRes = json.decode(response.body);
      setState(() {
        this.totalCartItems = mapRes['total'];
      });
    }
  }

  void logout() async {
    logindata = await SharedPreferences.getInstance();
    logindata.setBool('login', true);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }


  Widget _body() =>
      SizedBox.expand(
        child: IndexedStack(
          index: currentIndex,
          children: <Widget>[
            Home(this.updateCart),
            Coupons(this.callback),
            Wishlist(),
            Cart(this.updateCart),
            Profile(),
          ],
        ),
      );

  Widget _bottomNavBar() =>
      BottomNavBar(
        showElevation: false,
        backgroundColor: Color.fromRGBO(245, 246, 251, 0.9),
        containerHeight: 65,
        itemCornerRadius: 16,
        containerPadding: EdgeInsets.only(top: 5, bottom: 5),
        selectedIndex: currentIndex,
        onItemSelected: (index) {
          setState(() => currentIndex = index);
        },
        items: <BottomNavBarItem>[
          BottomNavBarItem(
            title: 'Главная',
            icon: Image.asset(
              "assets/images/home.png",
              fit: BoxFit.cover,
            ),
            activeColor: Color(0xFF1B1D1F),
            inactiveColor: Color(0xFF777E90),
            activeBackgroundColor: Color.fromRGBO(254, 220, 0, 0.4),
          ),
          BottomNavBarItem(
            title: 'Купоны',
            icon: Image.asset(
              "assets/images/coupons.png",
              fit: BoxFit.cover,
            ),
            activeColor: Color(0xFF1B1D1F),
            inactiveColor: Color(0xFF777E90),
            activeBackgroundColor: Color.fromRGBO(254, 220, 0, 0.4),
          ),
          BottomNavBarItem(
            title: 'Избранное',
            icon: Image.asset(
              "assets/images/wishlist.png",
              fit: BoxFit.cover,
            ),
            activeColor: Color(0xFF1B1D1F),
            inactiveColor: Color(0xFF777E90),
            activeBackgroundColor: Color.fromRGBO(254, 220, 0, 0.4),
          ),
          BottomNavBarItem(
            title: 'Корзина',
            icon: Stack(
              children: <Widget>[
                Image.asset(
                  "assets/images/cart.png",
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 0,
                  child: new Container(
                    padding: EdgeInsets.all(1),
                    decoration: new BoxDecoration(
                      color: Color(0xFFFEDC00),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: new Text(
                      totalCartItems.toString(),
                      style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            activeColor: Color(0xFF1B1D1F),
            inactiveColor: Color(0xFF777E90),
            activeBackgroundColor: Color.fromRGBO(254, 220, 0, 0.4),
          ),
          BottomNavBarItem(
            title: 'Профиль',
            icon: Image.asset(
              "assets/images/profile.png",
              fit: BoxFit.cover,
            ),
            activeColor: Color(0xFF1B1D1F),
            inactiveColor: Color(0xFF777E90),
            activeBackgroundColor: Color.fromRGBO(254, 220, 0, 0.4),
          ),
        ],
      );

  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Color(0xFF1B1D1F),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Container(
            color: const Color(0xFF1B1D1F),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppBar(
                  backgroundColor: const Color(0xFF1B1D1F),
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          width:100
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: IconButton(
                        icon: Image.asset(
                          "assets/images/notification.png",
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Notifications()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: IconButton(
                        icon: ValueListenableBuilder<AdvancedDrawerValue>(
                          valueListenable: _advancedDrawerController,
                          builder: (_, value, __) {
                            return AnimatedSwitcher(
                              duration: Duration(milliseconds: 250),
                              child: Icon(
                                value.visible ? Icons.clear : Icons.menu,
                                key: ValueKey<bool>(value.visible),
                              ),
                            );
                          },
                        ),
                        onPressed: _handleMenuButtonPressed,
                      ),
                    ),
                    // add more IconButton
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0)),
                    color: Colors.white,
                  ),
                  height: 15,
                )
              ],
            ),
          ),
        ),
        body: _body(),
        bottomNavigationBar: _bottomNavBar(),
      ),
      drawer: SafeArea(
        child: Container(
          padding:EdgeInsets.only(top: 50, bottom:45),
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width:200
                  ),
                  SizedBox(height:50),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CatalogXochu()),
                      );
                    },
                    title: Text('Хочу купить',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CatalogTravels()),
                      );
                    },
                    title: Text('Путешествия',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      showToast(
                        "Раздел в разработке",
                        duration: Duration(seconds: 5),
                        position: ToastPosition.center,
                        backgroundColor: Colors.red,
                        radius: 24,
                        textPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        textStyle: TextStyle(fontSize: 18.0, color: Colors.black),
                      );
                    },
                    title: Text('Благотворительность',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Winners()),
                      );
                    },
                    title: Text('Победители',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Faq()),
                      );
                    },
                    title: Text('Вопрос - ответ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => About()),
                      );
                    },
                    title: Text('О нас',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Contacts()),
                      );
                    },
                    title: Text('Контакты',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Spacer(),
                  ListTile(
                    onTap: logout,
                    title: Text('Выход',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}