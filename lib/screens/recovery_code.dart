import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:xochuapp/screens/login.dart';
import 'package:xochuapp/screens/new_password.dart';
import 'package:xochuapp/strings/strings.dart';

class RecoveryCode extends StatefulWidget {
  final int? code;
  final String? phone;
  const RecoveryCode({Key? key, required this.code, required this.phone})
      : super(key: key);
  @override
  _RecoveryCodeState createState() => _RecoveryCodeState();
}

class _RecoveryCodeState extends State<RecoveryCode> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  final password_controller = TextEditingController();

  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    sendSMS();
    super.initState();
  }

  Future<void> sendSMS() async {
    var queryParams = {
      'api_id': 'D196ADE6-4A53-4C7C-2EB6-D991B0F69D9E',
      'to': '${widget.phone.toString()}',
      'msg': '${widget.code.toString()}',
      'json': '1'
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "https://sms.ru/sms/send" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    print(requestUrl);
    if (response.statusCode == 200) {
      Map mapRes = json.decode(response.body);
      if (mapRes['status'] != "OK") {
        showToast(
          "Не получилось отправить SMS!",
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

  void dispose() {
    errorController!.close();
    password_controller.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 2),
      ),
    );
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
                Text('Введите защитный код',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 0.02,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 10),
                Text('Мы отпраили код на ${widget.phone}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      letterSpacing: 0.02,
                    )),
                SizedBox(height: 20),
                Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: TextStyle(
                          color: Color(0xFF1B1D1F),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                        length: 4,
                        obscureText: false,
                        obscuringCharacter: '*',
                        blinkWhenObscuring: true,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(8),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                        ),
                        cursorColor: Colors.black,
                        animationDuration: Duration(milliseconds: 300),
                        enableActiveFill: false,
                        errorAnimationController: errorController,
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            currentText = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                    )),
                SizedBox(height: 20),
                TextButton(
                    child: Text("Продолжить".toUpperCase(),
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
                      if (currentText.length != 4 ||
                          currentText != widget.code.toString()) {
                        errorController!.add(ErrorAnimationType.shake);
                        showToast(
                          "Неверный защитный код!",
                          duration: Duration(seconds: 5),
                          position: ToastPosition.bottom,
                          backgroundColor: Colors.red,
                          radius: 24,
                          textPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          textStyle: TextStyle(
                              fontSize: 14.0, color: Colors.black),
                        );
                        setState(() => hasError = true);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewPassword(
                                  phone: widget.phone.toString())),
                        );
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
