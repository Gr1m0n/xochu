import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:xochuapp/screens/login.dart';
import 'package:xochuapp/strings/strings.dart';

class NewPassword extends StatefulWidget {
  final String? phone;
  const NewPassword({Key? key, required this.phone}) : super(key: key);
  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final password_controller = TextEditingController();
  final password_repeat_controller = TextEditingController();
  void initState() {
    super.initState();
  }

  void dispose() {
    password_controller.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    var queryParams = {
      'password': password_controller.text.toString(),
      'phone': widget.phone.toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}resetpassword" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      Map mapRes = json.decode(response.body);
      if (mapRes['result'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        showToast(
          "Такого пользователя не существует!",
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
    return Scaffold(
        backgroundColor: Color(0xFF1B1D1F),
        body: Container(
          decoration: new BoxDecoration(
            color: Color(0xFF1B1D1F),
          ),
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 2.3,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(width: 1.5, color: Color(0xFFF4F5F6)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
            margin: EdgeInsets.symmetric(horizontal: 26),
            child: Column(children: [
              Text('Смена пароля',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF141416),
                      fontSize: 20,
                      letterSpacing: 0.02,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w800)),
              SizedBox(height: 20),
              TextField(
                controller: password_controller,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xFFE6E8EC)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  hintText: 'Новый пароль',
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: password_repeat_controller,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xFFE6E8EC)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  hintText: 'Подтвердите пароль',
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                  child: Text("Сменить пароль".toUpperCase(),
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
                    if (password_controller.text !=
                        password_repeat_controller.text) {
                      showToast(
                        "Пароли не совпадают!",
                        duration: Duration(seconds: 5),
                        position: ToastPosition.bottom,
                        backgroundColor: Colors.red,
                        radius: 24,
                        textPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        textStyle:
                            TextStyle(fontSize: 14.0, color: Colors.black),
                      );
                    } else {
                      if (password_controller.text.isNotEmpty) {
                        resetPassword();
                      } else {
                        showToast(
                          "Укажите новый пароль",
                          duration: Duration(seconds: 5),
                          position: ToastPosition.bottom,
                          backgroundColor: Colors.red,
                          radius: 24,
                          textPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          textStyle:
                              TextStyle(fontSize: 14.0, color: Colors.black),
                        );
                      }
                    }
                  }),
            ]),
          ),
        ));
  }
}
