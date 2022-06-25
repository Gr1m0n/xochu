import 'package:flutter/material.dart';
import 'dart:math';
import 'package:xochuapp/screens/recovery_code.dart';

class Recovery extends StatefulWidget {
  @override
  _RecoveryState createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  final phone_controller = TextEditingController();
  late Random rnd = new Random();
  late int min = 1000;
  late int max = 10000;
  late int code = min + rnd.nextInt(max - min);
  void dispose() {
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
      body:Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Давайте подтвердим, что это действительно вы',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 0.02,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w800)),
              SizedBox(height: 20),
              Text('Помогите нам защитить вашу учетную запись.\nПожалуйста, заполните проверку ниже',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    letterSpacing: 0.02,
              )),
              SizedBox(height: 20),
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
              SizedBox(height: 15),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecoveryCode(
                        code:code,
                        phone:phone_controller.text,
                      )),
                    );
                  }),
            ],
          ),
        ),
      )
    );
  }
}