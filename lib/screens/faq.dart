import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:xochuapp/models/faq_model.dart';
import 'package:xochuapp/providers/faq.dart';
import 'package:xochuapp/widgets/appbar.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class Faq extends StatefulWidget {
  @override
  _FaqState createState() => _FaqState();
}
class _FaqState extends State<Faq> {
  late Future fetchFaq;
  void initState() {
    fetchFaq = Provider.of<FaqProvider>(context, listen: false)
        .getBanners(lang: translator.activeLanguageCode);
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBarWidget(title: 'Вопрос - ответ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(
                  color: Color(0xFFF4F5F6),
                  borderRadius: BorderRadius.circular(40),
                ),
                child:Column(
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                        child: Text("О нас",
                            style: TextStyle(
                                color: Color(0xFF1B1D1F),
                                fontSize: 13,
                                letterSpacing: 0.04,
                          )),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 15)),
                            foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))))
                        ),
                        onPressed: () {
                        }
                    ),
                    TextButton(
                        child: Text("Аккаунт",
                            style: TextStyle(
                              color: Color(0xFF1B1D1F),
                              fontSize: 13,
                              letterSpacing: 0.04,
                            )),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 15)),
                            foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFFF4F5F6)),
                        ),
                        onPressed: () {
                        }
                    ),
                    TextButton(
                        child: Text("Кампании",
                            style: TextStyle(
                              color: Color(0xFF1B1D1F),
                              fontSize: 13,
                              letterSpacing: 0.04,
                            )),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 15)),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFF4F5F6)),
                        ),
                        onPressed: () {
                        }
                    ),
                    TextButton(
                        child: Text("Совершение покупки",
                            style: TextStyle(
                              color: Color(0xFF1B1D1F),
                              fontSize: 13,
                              letterSpacing: 0.04,
                            )),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 15)),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFF4F5F6)),
                        ),
                        onPressed: () {
                        }
                    ),
                    TextButton(
                        child: Text("Продукты Хочу",
                            style: TextStyle(
                              color: Color(0xFF1B1D1F),
                              fontSize: 13,
                              letterSpacing: 0.04,
                            )),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 15)),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFF4F5F6)),
                        ),
                        onPressed: () {
                        }
                    ),
                    TextButton(
                        child: Text("Призы Хочу",
                            style: TextStyle(
                              color: Color(0xFF1B1D1F),
                              fontSize: 13,
                              letterSpacing: 0.04,
                            )),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 15)),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFF4F5F6)),
                        ),
                        onPressed: () {
                        }
                    ),
                    TextButton(
                        child: Text("Безопасность",
                            style: TextStyle(
                              color: Color(0xFF1B1D1F),
                              fontSize: 13,
                              letterSpacing: 0.04,
                            )),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 15)),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFF4F5F6)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: Radius.circular(40))))
                        ),
                        onPressed: () {
                        }
                    ),
                  ],
                )
              ),
              SizedBox(height:16),
              FutureBuilder(
                  future: fetchFaq,
                  builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData)
                        return Container(
                          padding: EdgeInsets.all(16),
                          margin:EdgeInsets.symmetric(horizontal: 20),
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
          )
        )
      )
    );
  }
}