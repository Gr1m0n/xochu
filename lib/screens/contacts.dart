import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:xochuapp/models/banners_model.dart';
import 'package:xochuapp/providers/banners.dart';
import 'package:xochuapp/providers/page.dart';
import 'package:xochuapp/strings/strings.dart';
import 'package:xochuapp/widgets/appbar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> with WidgetsBindingObserver {
  late Future fetchPage;
  late Future fetchCharityBanners;
  final name_controller = TextEditingController();
  final email_controller = TextEditingController();
  final message_controller = TextEditingController();
  late BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  String dropdownValue = 'Общие вопросы';
  void initState() {
    fetchPage = Provider.of<PageProvider>(context, listen: false)
        .getPage(id: 3, lang: translator.activeLanguageCode);
    fetchCharityBanners = Provider.of<BannersProvider>(context, listen: false)
        .getBanners(position: 4, lang: translator.activeLanguageCode);
    setCustomMapPin();
    super.initState();
  }
  void dispose() {
    name_controller.dispose();
    email_controller.dispose();
    message_controller.dispose();
    super.dispose();
  }
  late Set<Marker> markers;

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/pin.png');
  }
  Future<void> send() async {
    var queryParams = {
      'name': name_controller.text.toString(),
      'email': email_controller.text.toString(),
      'message': message_controller.toString(),
      'subject': dropdownValue.toString(),
    };
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = "${AppStrings.api}send-mail" + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: headers);
    if (response.statusCode == 200) {
      Map mapRes = json.decode(response.body);
      if (mapRes['result'] == true) {
        showToast(
          "Спасибо! Сообщение отправлено!",
          duration: Duration(seconds: 5),
          position: ToastPosition.bottom,
          backgroundColor: Colors.green,
          radius: 24,
          textPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          textStyle: TextStyle(fontSize: 14.0, color: Colors.white),
        );
      } else {
        showToast(
          "Не удалось отправить сообщение!",
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBarWidget(title: 'Контакты'),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    FutureBuilder(
                        future: fetchPage,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            LatLng pinPosition = LatLng(double.parse('${snapshot.data.data[0].latitude}'), double.parse('${snapshot.data.data[0].longitude}'));
                            CameraPosition initialLocation = CameraPosition(
                                zoom: 16,
                                bearing: 30,
                                target: pinPosition
                            );
                            return Column(
                              textBaseline: TextBaseline.alphabetic,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  height: 150,
                                  child: GoogleMap(
                                      myLocationEnabled: true,
                                      compassEnabled: true,
                                      markers: _markers,
                                      initialCameraPosition: initialLocation,
                                      onMapCreated: (
                                          GoogleMapController controller) {
                                        controller.setMapStyle(Utils.mapStyles);
                                        _controller.complete(controller);
                                        setState(() {
                                          _markers.add(
                                              Marker(
                                                  markerId: MarkerId(
                                                      '<MARKER_ID>'),
                                                  position: pinPosition,
                                                  icon: pinLocationIcon
                                              )
                                          );
                                        });
                                      }
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          width: 1.5,
                                          color: Color(0xFFF4F5F6)),
                                    ),
                                    margin: EdgeInsets.only(bottom: 25),
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/contacts0.png",
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(width: 20),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Text('Email',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color(0xFF1B1D1F),
                                                    fontSize: 17,
                                                    letterSpacing: 0.02,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                    FontWeight.w800)),
                                            SizedBox(height: 5),
                                            Text('${snapshot.data.data[0].email
                                                .toString()}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color(0xFF1B1D1F),
                                                    fontSize: 11,
                                                    letterSpacing: 0.02,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                    FontWeight.w600))
                                          ],
                                        ),
                                      ],
                                    )),
                                Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          width: 1.5,
                                          color: Color(0xFFF4F5F6)),
                                    ),
                                    margin: EdgeInsets.only(bottom: 25),
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/contacts1.png",
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(width: 20),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Text('Адрес',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color(0xFF1B1D1F),
                                                    fontSize: 17,
                                                    letterSpacing: 0.02,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                    FontWeight.w800)),
                                            SizedBox(height: 5),
                                            Text(
                                                '${snapshot.data.data[0]
                                                    .translation?.address
                                                    .toString()}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Color(0xFF1B1D1F),
                                                  fontSize: 11,
                                                  letterSpacing: 0.02,
                                                ))
                                          ],
                                        ),
                                      ],
                                    )),
                                Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          width: 1.5,
                                          color: Color(0xFFF4F5F6)),
                                    ),
                                    margin: EdgeInsets.only(bottom: 25),
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/contacts2.png",
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(width: 20),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Text('Телефон',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color(0xFF1B1D1F),
                                                    fontSize: 17,
                                                    letterSpacing: 0.02,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                    FontWeight.w800)),
                                            SizedBox(height: 5),
                                            Text('${snapshot.data.data[0].phone
                                                .toString()}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Color(0xFF1B1D1F),
                                                  fontSize: 11,
                                                  letterSpacing: 0.02,
                                                )),
                                            SizedBox(height: 3),
                                            Text('Бесплатные звонки',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Color(0xFF777E91),
                                                  fontSize: 10,
                                                  letterSpacing: 0.02,
                                                ))
                                          ],
                                        ),
                                      ],
                                    )),
                                SizedBox(height: 35),
                                Text(
                                  'О НАС',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color(0xFF3B71FE),
                                      fontSize: 17,
                                      letterSpacing: 0.02,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w800),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Давайте пообщаемся !\nНе стесняйся обращаться к нам !',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color(0xFF1B1D1F),
                                      fontSize: 20,
                                      letterSpacing: 0.02,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 12),
                                HtmlWidget('${snapshot.data.data[0].translation
                                    ?.body.toString()}'),
                                SizedBox(height: 16),
                                TextField(
                                  controller: name_controller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(
                                          width: 1.2, color: Color(0xFFE6E8EC)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)),
                                    ),
                                    hintText: 'Имя, Фамилия',
                                  ),
                                ),
                                SizedBox(height: 16),
                                TextField(
                                  controller: email_controller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(
                                          width: 1.2, color: Color(0xFFE6E8EC)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)),
                                    ),
                                    hintText: 'Ваш эмэил адрес',
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  decoration: new BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(width: 1.2,
                                        color: Colors.black.withOpacity(0.4)),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 5,
                                      vertical: 8),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: dropdownValue,
                                      items: ['Общие вопросы', 'Партнерство']
                                          .map<DropdownMenuItem<String>>((
                                          String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValue = newValue!;
                                        });
                                      },
                                      hint: Text("Select item"),
                                      disabledHint: Text("Disabled"),
                                      elevation: 8,
                                      style: TextStyle(color: Color(0xFF1B1D1F),
                                          fontSize: 16),
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconEnabledColor: Color(0xFF1B1D1F),
                                      isExpanded: true,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                TextField(
                                  controller: message_controller,
                                  minLines: 1,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(
                                          width: 1.2, color: Color(0xFFE6E8EC)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)),
                                    ),
                                    hintText: 'Ваше сообщение',
                                  ),
                                ),
                                SizedBox(height: 25),
                                Center(
                                  child: TextButton(
                                      child: Text("Отправить".toUpperCase(),
                                          style: TextStyle(
                                              color: Color(0xFF101D27),
                                              fontSize: 13,
                                              letterSpacing: 0.04,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w800)),
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all<
                                              EdgeInsets>(
                                              EdgeInsets.symmetric(
                                                  horizontal: 75,
                                                  vertical: 12)),
                                          foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                          backgroundColor: MaterialStateProperty
                                              .all<Color>(
                                              Color(0xFFFEDC00)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(24.0),
                                                  side:
                                                  BorderSide(color: Color(
                                                      0xFFFEDC00))))),
                                      onPressed: () {
                                        send();
                                      }),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Филиалы и благотворительные организации',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF101D27),
                                            fontSize: 17,
                                            letterSpacing: 0.02,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      SizedBox(height: 16),
                                      FutureBuilder(
                                          future: fetchCharityBanners,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<dynamic> snapshot) {
                                            if (snapshot.hasData)
                                              return CarouselSlider.builder(
                                                  itemCount: snapshot.data.data
                                                      .length,
                                                  options: CarouselOptions(
                                                    autoPlay: true,
                                                    aspectRatio: 2.0,
                                                    enlargeCenterPage: true,
                                                  ),
                                                  itemBuilder: (
                                                      BuildContext context,
                                                      int itemIndex,
                                                      int pageViewIndex) {
                                                    BannersModel bannersData = snapshot
                                                        .data.data[itemIndex];
                                                    return Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(
                                                                18)),
                                                        child: Image.network(
                                                          "${AppStrings
                                                              .localUrl}${bannersData
                                                              .translation
                                                              ?.mobile}",
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                              );
                                            else
                                              return Center(
                                                child: CircularProgressIndicator(),
                                              );
                                          }
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ],
                ))));
  }
}
class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}