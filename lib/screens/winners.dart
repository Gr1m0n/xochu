import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:xochuapp/models/faq_model.dart';
import 'package:xochuapp/models/winners_model.dart';
import 'package:xochuapp/providers/faq.dart';
import 'package:xochuapp/providers/winners.dart';
import 'package:xochuapp/strings/strings.dart';
import 'package:xochuapp/widgets/appbar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:ndialog/ndialog.dart';

class Winners extends StatefulWidget {
  @override
  _WinnersState createState() => _WinnersState();
}
class _WinnersState extends State<Winners> {
  late Future fetchWinners;
  late Future fetchFaq;
  late YoutubePlayerController _controller;
  late YoutubePlayerController _winner;
  void initState() {
    fetchWinners = Provider.of<WinnersProvider>(context, listen: false)
        .getWinners(limit: 8);
    fetchFaq = Provider.of<FaqProvider>(context, listen: false)
        .getBanners(lang: translator.activeLanguageCode);
    _controller = YoutubePlayerController(
      initialVideoId: "https://www.youtube.com/watch?v=Thf4JicIfZc",
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBarWidget(title: 'Победители'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height:450,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: FutureBuilder(
                    future: fetchWinners,
                    builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData)
                        return ListView.builder(
                            itemCount: snapshot.data.data.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              WinnersModel dataModel = snapshot.data.data[index];
                              return Stack(
                                children: [
                                  Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 1.5,
                                    height: 340,
                                    margin: EdgeInsets.only(top: 21, right: 20, bottom:40),
                                    padding: EdgeInsets.all(20),
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          width: 1.5, color: Color(0xFFF4F5F6)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(.3),
                                          blurRadius: 10.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(
                                            0.0,
                                            // Move to right 10  horizontally
                                            10.0, // Move to bottom 10 Vertically
                                          ),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      textBaseline: TextBaseline.alphabetic,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Image.network(
                                          "${AppStrings.localUrl}${dataModel.image}",
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          'Поздравляем!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color(0xFF3B71FE),
                                              fontSize: 15,
                                              letterSpacing: 0.02,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '${dataModel.user} с выигрышем ${dataModel.title}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF1B1D1F),
                                            fontSize: 13,
                                            letterSpacing: 0.02,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Coupon no: ${dataModel.coupon}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF777E91),
                                            fontSize: 11,
                                            letterSpacing: 0.02,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 20,
                                      left: -10,
                                      right: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: OutlinedButton(
                                          onPressed: (){
                                            var videoId = YoutubePlayer.convertUrlToId("${dataModel.youtube.toString()}");
                                            _winner = YoutubePlayerController(
                                              initialVideoId: videoId.toString(),
                                              flags: YoutubePlayerFlags(
                                                autoPlay: true,
                                                mute: false,
                                              ),
                                            );
                                            NDialog(
                                              dialogStyle: DialogStyle(),
                                              content: Padding(
                                                padding: const EdgeInsets.only(top:15),
                                                child: YoutubePlayer(
                                                  controller: _winner,
                                                  showVideoProgressIndicator: true,
                                                ),
                                              ),
                                            ).show(context);
                                            //_launchInBrowser(dataModel.youtube.toString());
                                          },
                                          style: OutlinedButton.styleFrom(
                                              padding:
                                              EdgeInsets.symmetric(
                                                  vertical: 16),
                                              backgroundColor: Colors.white,
                                              side: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(24))),
                                          child: const Text(
                                            "НАГРАЖДЕНИЕ",
                                            style: TextStyle(
                                                color: Color(0xFF101D27),
                                                fontSize: 16,
                                                letterSpacing: 0.02,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      )),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: NetworkImage(
                                          'https://via.placeholder.com/150'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  )
                                ],
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
            ),
            Container(
              decoration: BoxDecoration(color: Color(0xFF1B1D1F)),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 20, bottom:35),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                  ),
                  SizedBox(height:20),
                  Text(
                    'Настоящие люди.\nНастоящие победы.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFFFEDC00),
                        fontSize: 22,
                        letterSpacing: 0.02,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height:10),
                  Text(
                    'Удивительные победители - одна из лучших сторон работы. Ознакомьтесь с некоторыми из наших любимых отзывов о победителях!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: 0.02,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/icon1.png",
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Прошлые победители',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color(0xFF101D27),
                        fontSize: 18,
                        letterSpacing: 0.02,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin:EdgeInsets.only(top:20, left:20, right:20),
              padding:EdgeInsets.symmetric(horizontal: 15,vertical: 20),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    width: 1.5,
                    color: Color(0xFFF4F5F6)),
              ),
              child: Row(
                children: [
                  Text(
                    '2022 г.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color(0xFF101D27),
                        fontSize: 18,
                        letterSpacing: 0.02,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(width:10),
                  SizedBox(
                    width:MediaQuery.of(context).size.width / 1.6,
                    height:16,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children:[
                        Text(
                          'Январь',
                          style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 16,
                              letterSpacing: 0.02,),
                        ),
                        SizedBox(width:10),
                        Text(
                          'Февраль',
                          style: TextStyle(
                            color: Color(0xFF101D27),
                            fontSize: 16,
                            letterSpacing: 0.02,),
                        ),
                        SizedBox(width:10),
                        Text(
                          'Март',
                          style: TextStyle(
                            color: Color(0xFF101D27),
                            fontSize: 16,
                            letterSpacing: 0.02,),
                        ),
                        SizedBox(width:10),
                        Text(
                          'Апрель',
                          style: TextStyle(
                            color: Color(0xFF101D27),
                            fontSize: 16,
                            letterSpacing: 0.02,),
                        ),
                        SizedBox(width:10),
                        Text(
                          'Май',
                          style: TextStyle(
                            color: Color(0xFF101D27),
                            fontSize: 16,
                            letterSpacing: 0.02,),
                        ),
                        SizedBox(width:10),
                        Text(
                          'Июнь',
                          style: TextStyle(
                            color: Color(0xFF101D27),
                            fontSize: 16,
                            letterSpacing: 0.02,),
                        ),
                        SizedBox(width:10),
                        Text(
                          'Июль',
                          style: TextStyle(
                            color: Color(0xFF101D27),
                            fontSize: 16,
                            letterSpacing: 0.02,),
                        ),
                        SizedBox(width:10),
                        Text(
                          'Август',
                          style: TextStyle(
                            color: Color(0xFF101D27),
                            fontSize: 16,
                            letterSpacing: 0.02,),
                        ),
                        SizedBox(width:10),
                        Text(
                          'Сентябрь',
                          style: TextStyle(
                            color: Color(0xFF101D27),
                            fontSize: 16,
                            letterSpacing: 0.02,),
                        ),
                        SizedBox(width:10),
                        Text(
                          'Октябрь',
                          style: TextStyle(
                            color: Color(0xFF101D27),
                            fontSize: 16,
                            letterSpacing: 0.02,),
                        ),
                        SizedBox(width:10),
                        Text(
                          'Ноябрь',
                          style: TextStyle(
                            color: Color(0xFF101D27),
                            fontSize: 16,
                            letterSpacing: 0.02,),
                        ),
                        SizedBox(width:10),
                        Text(
                          'Декабрь',
                          style: TextStyle(
                            color: Color(0xFF101D27),
                            fontSize: 16,
                            letterSpacing: 0.02,),
                        ),
                      ]
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin:EdgeInsets.only(top:20, left:20, right:20, bottom:35),
              padding:EdgeInsets.symmetric(horizontal: 15,vertical: 20),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    width: 1.5,
                    color: Color(0xFFF4F5F6)),
              ),
              child: Row(
                children: [
                  Text(
                    '2021 г.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color(0xFF101D27),
                        fontSize: 18,
                        letterSpacing: 0.02,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(width:10),
                  SizedBox(
                    width:MediaQuery.of(context).size.width / 1.6,
                    height:16,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children:[
                          Text(
                            'Январь',
                            style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 16,
                              letterSpacing: 0.02,),
                          ),
                          SizedBox(width:10),
                          Text(
                            'Февраль',
                            style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 16,
                              letterSpacing: 0.02,),
                          ),
                          SizedBox(width:10),
                          Text(
                            'Март',
                            style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 16,
                              letterSpacing: 0.02,),
                          ),
                          SizedBox(width:10),
                          Text(
                            'Апрель',
                            style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 16,
                              letterSpacing: 0.02,),
                          ),
                          SizedBox(width:10),
                          Text(
                            'Май',
                            style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 16,
                              letterSpacing: 0.02,),
                          ),
                          SizedBox(width:10),
                          Text(
                            'Июнь',
                            style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 16,
                              letterSpacing: 0.02,),
                          ),
                          SizedBox(width:10),
                          Text(
                            'Июль',
                            style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 16,
                              letterSpacing: 0.02,),
                          ),
                          SizedBox(width:10),
                          Text(
                            'Август',
                            style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 16,
                              letterSpacing: 0.02,),
                          ),
                          SizedBox(width:10),
                          Text(
                            'Сентябрь',
                            style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 16,
                              letterSpacing: 0.02,),
                          ),
                          SizedBox(width:10),
                          Text(
                            'Октябрь',
                            style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 16,
                              letterSpacing: 0.02,),
                          ),
                          SizedBox(width:10),
                          Text(
                            'Ноябрь',
                            style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 16,
                              letterSpacing: 0.02,),
                          ),
                          SizedBox(width:10),
                          Text(
                            'Декабрь',
                            style: TextStyle(
                              color: Color(0xFF101D27),
                              fontSize: 16,
                              letterSpacing: 0.02,),
                          ),
                        ]
                    ),
                  )
                ],
              ),
            ),
            Text(
              'Часто задаваемые вопросы 🤔',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color(0xFF101D27),
                  fontSize: 18,
                  letterSpacing: 0.02,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height:16),
            FutureBuilder(
                future: fetchFaq,
                builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData)
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(width: 1.5, color: Color(0xFFE6E8EC)),
                      ),
                      child: ListView.builder(
                          itemCount: snapshot.data.data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            FaqModel faqModel = snapshot.data.data[index];
                            return ExpansionWidget(
                                initiallyExpanded: false,
                                titleBuilder: (double animationValue, _, bool isExpaned, toogleFunction) {
                                  return InkWell(
                                      onTap: () => toogleFunction(animated: true),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: Row(
                                                  children: [
                                                    Text('${index.toString()}',
                                                        style: TextStyle(
                                                            color: Color(0xFF3B71FE),
                                                            fontSize: 18,
                                                            letterSpacing: 0.02,
                                                            fontStyle: FontStyle.italic,
                                                            fontWeight: FontWeight.w800)
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text('${faqModel.translation?.title.toString()}',
                                                        style: TextStyle(
                                                            color: Color(0xFF1B1D1F),
                                                            fontSize: 14,
                                                            letterSpacing: 0.02,
                                                            fontWeight: FontWeight.w600)
                                                    ),
                                                  ],
                                                )
                                            ),
                                            SizedBox(width: 10),
                                            Transform.rotate(
                                              angle: math.pi * animationValue / 2,
                                              child: Icon(Icons.keyboard_arrow_right, size: 20),
                                              alignment: Alignment.center,
                                            )
                                          ],
                                        ),
                                      ));
                                },
                                content: Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  padding: EdgeInsets.all(20),
                                  child: HtmlWidget('${faqModel.translation?.body.toString()}'),
                                )
                            );
                          }
                      ),
                    );
                  else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                }
            ),
          ],
        ),
      )
    );
  }
}