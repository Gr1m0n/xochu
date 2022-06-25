import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xochuapp/models/points_model.dart';
import 'package:xochuapp/providers/points.dart';
import 'package:xochuapp/screens/payment.dart';
import 'package:xochuapp/strings/strings.dart';
import 'package:xochuapp/widgets/appbar.dart';
import 'package:selectable_container/selectable_container.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}
class _CheckoutState extends State<Checkout> {
  late SharedPreferences logindata;
  late Future fetchPoints;
  late int? id;
  late String? email;
  late String? phone;
  late String? firstname;
  late String? lastname;
  late String? birthday;
  late String? password;
  final firstname_controller = TextEditingController();
  final lastname_controller = TextEditingController();
  final birthday_controller = TextEditingController();
  final phone_controller = TextEditingController();
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  bool isSwitched = false;
  bool _address = true;
  final List<bool> _selectedItems = [];
  void initState() {
    fetchPoints = Provider.of<PointsProvider>(context, listen: false).getPoints(lang: translator.activeLanguageCode);
    getProfile();
    super.initState();
  }
  void getProfile() async {
    logindata = await SharedPreferences.getInstance();
    id = logindata.getInt('user_id');
    password = logindata.getString('password');
    email = logindata.getString('email');
    phone = logindata.getString('phone');
    firstname = logindata.getString('firstname');
    lastname = logindata.getString('lastname');
    birthday = logindata.getString('birthday');

    firstname_controller.text = firstname!;
    lastname_controller.text = lastname!;
    phone_controller.text = phone!;
    email_controller.text = email!;
    birthday_controller.text = birthday!;
  }
  Future<void> checkout() async {
    logindata = await SharedPreferences.getInstance();
    var queryParams = {
      'first_name': firstname_controller.text.toString(),
      'last_name': lastname_controller.text.toString(),
      'phone': phone_controller.text.toString(),
      'email': email_controller.text.toString(),
      'courier_delivery': '1',
      'user_address_id': '1',
      'point_of_issue_id': '1',
      'cart_items': '1',
      'total': '70000',
      'user_id': logindata.getInt('user_id').toString(),
    };
    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}checkout"/* + '?' + queryString*/;
    var response = await http.post(
        Uri.parse(requestUrl),
        headers: headers,
        body: queryParams
    );
    if (response.statusCode == 200) {
      Map mapRes = json.decode(response.body);
      if (mapRes['url'] != 'null') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Payment(url:mapRes['url'].toString())),
        );
      }
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBarWidget(title: 'Оформление заказа'),
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24,right: 24,bottom:100),
          child: Column(
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text('Вписывайте свои реальные контактные данные, чтобы мы смогли отправить к вам ваш заказ.\nПокупай, получай купон и учавствуй в розыгрыше!',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color(0xFF23262F),
                      fontSize: 13,
                      letterSpacing: 0.02,
                  )),
              Divider(
                height: 30,
                thickness: 1.5,
                endIndent: 0,
                color: Color(0xFF25252D).withOpacity(0.2),
              ),
              TextField(
                controller: firstname_controller,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.2, color: Color(0xFFE6E8EC)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  hintText: 'Имя',
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: lastname_controller,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.2, color: Color(0xFFE6E8EC)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  hintText: 'Фамилия',
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: phone_controller,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.2, color: Color(0xFFE6E8EC)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  hintText: 'Номер телефона',
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: email_controller,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.2, color: Color(0xFFE6E8EC)),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  hintText: 'Электронный адрес',
                ),
              ),
              SizedBox(height: 25),
              Text('Адрес доставки',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF23262F),
                      fontSize: 17,
                      letterSpacing: 0.02,
                      fontWeight: FontWeight.w600)),
              Row(
                children: <Widget>[
                  Expanded(child: Text("Я хочу отказаться от доставки продукта")),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        if(isSwitched == true){
                          _address = false;
                        } else {
                          _address = true;
                        }
                      });
                    },
                  ),
                ],
              ),
              Text('При отказе от товара, вы не теряете приобретенные купоны от покупки ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF777E91),
                    fontSize: 11,
                    letterSpacing: 0.02,
                  )),
              Divider(
                height: 30,
                thickness: 1.5,
                endIndent: 0,
                color: Color(0xFF25252D).withOpacity(0.2),
              ),
              Visibility(
                visible: _address,
                child: FutureBuilder(
                  future: fetchPoints,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData)
                      return ListView.builder(
                        itemCount: snapshot.data.data.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          PointsModel dataModel = snapshot.data.data[index];
                          _selectedItems.add(false);
                          return SelectableContainer(
                              selectedBorderColor: Colors.grey.shade600,
                              selectedBackgroundColor: Colors.grey.shade100,
                              unselectedBorderColor: Color(0xFFE6E8EC),
                              unselectedBackgroundColor: Colors.grey.shade200,
                              iconSize: 24,
                              unselectedOpacity: 1,
                              selectedOpacity: 0.8,
                              selected: _selectedItems[index],
                              onValueChanged: (newValue) {
                                setState(() {
                                  _selectedItems[index] = newValue;
                                });
                              },
                              child: Column(
                                textBaseline: TextBaseline.alphabetic,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                children: <Widget>[
                                  Text('${dataModel.translation!.title.toString()}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF1B1D1F),
                                          fontSize: 13,
                                          letterSpacing: 0.02,
                                          fontWeight: FontWeight.w600
                                      ),
                                  ),
                                  SizedBox(height:8),
                                  HtmlWidget('${dataModel.translation!.body.toString()}')
                                ],
                              ),
                              padding: 16.0,
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
        )
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor:Color(0xFFFEDC00),
          extendedPadding:EdgeInsets.symmetric(horizontal: 46,vertical: 11),
          label:Text(
            "Оплатить".toUpperCase(),
            style: TextStyle(
                color: Color(0xFF101D27),
                fontSize: 15,
                letterSpacing: 0.02,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w800),
          ),
          onPressed: () {
            checkout();
          },
          heroTag: null,
        )
    );
  }
}