import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xochuapp/screens/recovery.dart';
import 'package:xochuapp/screens/registration.dart';
import 'package:xochuapp/screens/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:xochuapp/strings/strings.dart';
import 'package:oktoast/oktoast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final username_controller = TextEditingController();
  final password_controller = TextEditingController();
  late SharedPreferences logindata;
  late bool login;
  void initState() {
    super.initState();
    check_if_already_login();
  }

  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    login = (logindata.getBool('login') ?? true);
    if (login == false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }

  void dispose() {
    username_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  Future<void> setUserId() async {
    String username = username_controller.text;
    String password = password_controller.text;
    if (username != '' && password != '') {
      var queryParams = {'login': username, 'password': password};
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = "${AppStrings.api}login" + '?' + queryString;
      var response = await http.get(Uri.parse(requestUrl), headers: headers);
      if (response.statusCode == 200) {
        Map mapRes = json.decode(response.body);
        if (mapRes['result'] == true) {
          logindata.setBool('login', false);
          logindata.setInt('user_id', mapRes['id']);
          logindata.setString('password', mapRes['password']);
          logindata.setString('email', mapRes['email']);
          logindata.setString('phone', mapRes['phone']);
          logindata.setString('firstname', mapRes['firstname']);
          logindata.setString('lastname', mapRes['lastname']);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        } else {
          showToast(
            "Не верный логин или пароль",
            duration: Duration(seconds: 5),
            position: ToastPosition.bottom,
            backgroundColor: Colors.red,
            radius: 24,
            textPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            textStyle: TextStyle(fontSize: 14.0, color: Colors.black),
          );
        }
      }
    } else {
      showToast(
        "Заполните все поля!",
        duration: Duration(seconds: 5),
        position: ToastPosition.bottom,
        backgroundColor: Colors.red,
        radius: 24,
        textPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        textStyle: TextStyle(fontSize: 14.0, color: Colors.black),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1B1D1F),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.scaleDown,
                  scale: 4.1,
                ),
                SizedBox(height: 40),
                TextField(
                  controller: username_controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF1B1D1F),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 1.2),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: 'Номер телефона',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    )
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: password_controller,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF1B1D1F),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 1.2),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: 'Пароль',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    )
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFEDC00)),
                    padding:
                        MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Recovery()),
                    );
                  },
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('Забыли пароль?')),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                      child: Text("Войти".toUpperCase(),
                          style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 13,
                              letterSpacing: 0.04,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w800)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 75, vertical: 12)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Color(0xFFFEDC00)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  side: BorderSide(color: Color(0xFFFEDC00))))),
                      onPressed: () {
                        setUserId();
                      }),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Еще нет профиля?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        letterSpacing: 0.02,
                      )),
                    SizedBox(width:15),
                    TextButton(
                        child: Text("Регистрация"),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFFEDC00)),
                          padding:
                          MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Registration()),
                          );
                        }),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class Int {}
