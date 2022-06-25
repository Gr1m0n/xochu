import 'package:flutter/material.dart';
import 'dart:math';
import 'package:xochuapp/screens/code.dart';
import 'package:xochuapp/screens/login.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  final firstName_controller = TextEditingController();
  final lastName_controller = TextEditingController();
  final phone_controller = TextEditingController();
  late Random rnd = new Random();
  late int min = 1000;
  late int max = 10000;
  late int code = min + rnd.nextInt(max - min);
  void dispose() {
    email_controller.dispose();
    password_controller.dispose();
    firstName_controller.dispose();
    lastName_controller.dispose();
    phone_controller.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1B1D1F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1B1D1F),
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Регистрация',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 0.02,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w800)),
                    SizedBox(height: 20),
                    TextField(
                      controller: email_controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF1B1D1F),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 1.2),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          hintText: 'Электронный адрес',
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
                    SizedBox(height: 15),
                    TextField(
                      controller: firstName_controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF1B1D1F),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 1.2),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          hintText: 'Имя',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          )
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: lastName_controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF1B1D1F),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 1.2),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          hintText: 'Фамилия',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          )
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: phone_controller,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Code(
                                code:code,
                                email:email_controller.text,
                                password:password_controller.text,
                                firstName:firstName_controller.text,
                                lastName:lastName_controller.text,
                                phone:phone_controller.text,
                            )),
                          );
                        }),
                  ],
                ),
              ),
            )));
  }
}
