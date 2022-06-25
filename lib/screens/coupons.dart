import 'package:flutter/material.dart';
import 'package:xochuapp/screens/homepage.dart';

class Coupons extends StatefulWidget {
  Function callback;
  Coupons(this.callback);
  @override
  _CouponsState createState() => _CouponsState();
}
class _CouponsState extends State<Coupons> {
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          textBaseline: TextBaseline.alphabetic,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Text(
              'Купоны',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color(0xFF23262F),
                  fontSize: 20,
                  letterSpacing: 0.02,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height:20),
            Container(
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
                    'В купонах пусто? 😔',
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
                    'Это не страшно! Вы всегда можете их купить',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xFF777E91),
                      fontSize: 13,
                      letterSpacing: 0.02,
                    ),
                  ),
                  SizedBox(height:10),
                  TextButton(
                      child: Text("К покупкам".toUpperCase(),
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
                        setState(() {
                          this.widget.callback(0);
                        });
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}