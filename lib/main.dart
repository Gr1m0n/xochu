import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xochuapp/providers/notifications.dart';
import 'package:xochuapp/providers/points.dart';
import 'package:xochuapp/providers/wishlist.dart';
import 'package:xochuapp/screens/login.dart';
import 'package:xochuapp/screens/homepage.dart';
import 'package:xochuapp/providers/xochu.dart';
import 'package:xochuapp/providers/banners.dart';
import 'package:xochuapp/providers/products.dart';
import 'package:xochuapp/providers/winners.dart';
import 'package:xochuapp/providers/page.dart';
import 'package:xochuapp/providers/faq.dart';
import 'package:xochuapp/providers/cart.dart';
import 'package:oktoast/oktoast.dart';


bool? login;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: const Color(0xFF1B1D1F),
  ));
  SharedPreferences logindata;
  logindata = await SharedPreferences.getInstance();
  login = logindata.getBool('login');
  await translator.init(
    localeType: LocalizationDefaultType.device,
    languagesList: <String>['ru', 'en'],
    assetsDirectory: 'assets/lang/',
  );
  Provider.debugCheckInvalidValueType = null;
  runApp(
    LocalizedApp(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (context) => BannersProvider()),
          Provider(create: (context) => ProductsProvider()),
          Provider(create: (context) => XochuProvider()),
          Provider(create: (context) => WinnersProvider()),
          Provider(create: (context) => PageProvider()),
          Provider(create: (context) => FaqProvider()),
          Provider(create: (context) => WishlistProvider()),
          Provider(create: (context) => CartProvider()),
          Provider(create: (context) => PointsProvider()),
          Provider(create: (context) => NotificationsProvider()),
        ],
        child: OKToast(
          child: MaterialApp(
            title: 'Xochu.ru',
            debugShowCheckedModeBanner: false,
            theme:
                new ThemeData(scaffoldBackgroundColor: const Color(0xFFFFFFFF)),
            home:
                login == true || login == null ? new Login() : new MyHomePage(),
          ),
        ));
  }
}
