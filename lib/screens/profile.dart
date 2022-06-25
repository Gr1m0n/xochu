import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xochuapp/strings/strings.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  late SharedPreferences logindata;
  late int? id;
  late String? email;
  late String? phone;
  late String? firstname;
  late String? lastname;
  late String? birthday;
  late String? password;
  late String? avatar;
  final picker = ImagePicker();
  final firstname_controller = TextEditingController();
  final lastname_controller = TextEditingController();
  final birthday_controller = TextEditingController();
  final phone_controller = TextEditingController();
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  bool step1 = true;
  bool step2 = false;
  late Random rnd = new Random();
  late int min = 1000;
  late int max = 10000;
  late int code = min + rnd.nextInt(max - min);
  List<XFile>? _imageFileList;
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  void initState() {
    getProfile();
    super.initState();
  }
  void dispose() {
    super.dispose();
  }
  Future _getImage(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    logindata = await SharedPreferences.getInstance();
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 200,
        maxHeight: 200,
        imageQuality: 100,
      );
      setState(() {
        _imageFile = pickedFile;
        avatar = _imageFileList![0].path;
        logindata.setString('avatar', _imageFileList![0].path) as String?;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }
  Future<void> sendSMS(String phone) async {
    var queryParams = {'api_id': 'D196ADE6-4A53-4C7C-2EB6-D991B0F69D9E', 'to': '${phone.toString()}', 'msg': '${code.toString()}', 'json':'1'};
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
  void showProfileSettings() {
    showStickyFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: .8,
      headerHeight: 70,
      context: context,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      headerBuilder: (context, offset) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: Color(0xFFFEDC00),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(offset == 0.8 ? 0 : 40),
              topRight: Radius.circular(offset == 0.8 ? 0 : 40),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Управление аккаунтом',
                    style: TextStyle(
                        color: Color(0xFF101D27),
                        fontSize: 20,
                        letterSpacing: 0.04,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w800)
                  ),
                ),
              ),
            ],
          ),
        );
      },
      bodyBuilder: (context, offset) {
        return SliverChildListDelegate(
          [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom:100),
              child: Column(
                textBaseline: TextBaseline.alphabetic,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  TextField(
                    controller: firstname_controller,
                    decoration: InputDecoration(
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
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.2, color: Color(0xFFE6E8EC)),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      hintText: 'Фамилия',
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: birthday_controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.2, color: Color(0xFFE6E8EC)),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      hintText: 'Дата рождения',
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: email_controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.2, color: Color(0xFFE6E8EC)),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      hintText: 'Электронный адрес',
                    ),
                  ),
                  SizedBox(height: 40),
                  TextField(
                    controller: password_controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.2, color: Color(0xFFE6E8EC)),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      hintText: 'Новый пароль',
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: <Widget>[
                      Expanded(child: Text("Получать уведомления по электронной почте")),
                      Switch(
                        value: true,
                        onChanged: null,
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Expanded(child: Text("Уведомления о получении на мобильный телефон")),
                      Switch(
                        value: true,
                        onChanged: null,
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: TextButton(
                        child: Text("Сохранить".toUpperCase(),
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
                          saveProfile();
                        }
                    ),
                  ),
                ],
              ),
            ),
          ]
        );
      },
      anchors: [.2, 0.5, .8],
    );
  }
  void showChangePhone() {
    TextEditingController textEditingController = new TextEditingController();
    StreamController<ErrorAnimationType>? errorController;
    bool hasError = false;
    String currentText = "";
    final formKey = GlobalKey<FormState>();
    showStickyFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: .8,
      headerHeight: 70,
      context: context,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      headerBuilder: (context, offset) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: Color(0xFFFEDC00),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(offset == 0.8 ? 0 : 40),
              topRight: Radius.circular(offset == 0.8 ? 0 : 40),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                      'Смена номера телефона',
                      style: TextStyle(
                          color: Color(0xFF101D27),
                          fontSize: 20,
                          letterSpacing: 0.04,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w800)
                  ),
                ),
              ),
            ],
          ),
        );
      },
      bodyBuilder: (context, offset) {
        return SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom:20),
                child: Column(
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Visibility(
                      visible: step1,
                      child: Column(
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          TextField(
                            controller: phone_controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.2, color: Color(0xFFE6E8EC)),
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                              hintText: 'Новый номер телефона',
                            ),
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: TextButton(
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
                                    if (phone_controller.text.length != 0) {
                                      setState(() {
                                        sendSMS(phone_controller.text.toString());
                                        step1 = false;
                                        step2 = true;
                                      });
                                    }
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: step2,
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
                          Text('Мы отпраили код на ${phone_controller.text.toString()}',
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
                                if (currentText.length != 4 || currentText != code.toString()) {
                                  errorController!.add(ErrorAnimationType.shake);
                                  showToast(
                                    "Неверный защитный код!",
                                    duration: Duration(seconds: 5),
                                    position: ToastPosition.bottom,
                                    backgroundColor: Colors.red,
                                    radius: 24,
                                    textPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    textStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                                  );
                                  setState(() => hasError = true);
                                } else {
                                  setState(() {
                                    hasError = false;
                                  });
                                  saveProfile();
                                }
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]
        );
      },
      anchors: [.2, 0.5, .8],
    );
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
    avatar = logindata.getString('avatar');
    if(avatar == null){
      avatar = logindata.setString('avatar', 'assets/images/noavatar.jpg') as String?;
    }

    firstname_controller.text = firstname!;
    lastname_controller.text = lastname!;
    //phone_controller.text = phone!;
    email_controller.text = email!;
    birthday_controller.text = birthday!;
  }
  Future<void> saveProfile() async {
    logindata = await SharedPreferences.getInstance();
    var queryParams = {
      'email': email_controller.text.toString(),
      'password': password_controller.text.toString(),
      'firstname': firstname_controller.text.toString(),
      'lastname': lastname_controller.text.toString(),
      'birthday': birthday_controller.text.toString(),
      'phone': phone_controller.text.toString(),
      'user_id': logindata.getInt('user_id').toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}update-profile" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      Map mapRes = json.decode(response.body);
      if (mapRes['result'] == true) {
        if(password_controller.text.isNotEmpty) {
          logindata.setString('password', password_controller.text.toString());
        }
        logindata.setString('email', email_controller.text.toString());
        logindata.setString('phone', phone_controller.text.toString());
        logindata.setString('firstname', firstname_controller.text.toString());
        logindata.setString('lastname', lastname_controller.text.toString());
        logindata.setString('birthday', birthday_controller.text.toString());
        showToast(
          "Профиль обновлен!",
          duration: Duration(seconds: 5),
          position: ToastPosition.top,
          backgroundColor: Colors.green,
          radius: 24,
          textPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          textStyle: TextStyle(fontSize: 14.0, color: Colors.white),
        );
      }
    }
  }
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        textBaseline: TextBaseline.alphabetic,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: new BoxDecoration(
                color: Color(0xFFFEDC00),
              ),
              child: Center(
                  child:GestureDetector(
                    onTap: (){
                      _getImage(ImageSource.gallery, context: context);
                    },
                    child: CircleAvatar(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        radius: 70.0,
                        child: ClipOval(
                          child: avatar == "assets/images/noavatar.jpg" ? Image.asset(
                              'assets/images/noavatar.png',
                              fit: BoxFit.cover,
                              width: 120.0,
                              height: 120.0,
                            ) : Image.file(File(avatar.toString()))
                        )),
                  )
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_box_outlined),
              title: Text("Управление аккаунтом"),
              onTap: () => showProfileSettings(),
            ),
            ListTile(
              leading: Icon(Icons.phone_android),
              title: Text("Смена номера телефона"),
              onTap: () => showChangePhone(),
            ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text("Смена языка"),
            onTap: () {
              showAdaptiveActionSheet(
                context: context,
                actions: <BottomSheetAction>[
                  BottomSheetAction(
                    title: const Text('Русский'),
                    onPressed: () {
                      translator.setNewLanguage(
                        context,
                        newLanguage: 'ru',
                        remember: true,
                        restart: true,
                      );
                    },
                  ),
                  BottomSheetAction(
                    title: const Text('English'),
                    onPressed: () {
                      translator.setNewLanguage(
                        context,
                        newLanguage: 'en',
                        remember: true,
                        restart: true,
                      );
                    },
                  ),
                ],
                cancelAction: CancelAction(title: const Text('Отмена')),
              );
            },
          ),
        ],
      ),
    );
  }
}
typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);