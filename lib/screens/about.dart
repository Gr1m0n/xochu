import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:xochuapp/providers/page.dart';
import 'package:xochuapp/widgets/appbar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}
class _AboutState extends State<About> {
  late Future fetchPage;
  void initState() {
    fetchPage = Provider.of<PageProvider>(context, listen: false)
        .getPage(id: 2, lang: translator.activeLanguageCode);
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBarWidget(title: 'О нас'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                  FutureBuilder(
                    future: fetchPage,
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData)
                        return Column(
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                  "assets/images/about.jpg",
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top:20,
                                  left:0,
                                  right:0,
                                  bottom:0,
                                  child: Column(
                                    children: [
                                      Center(
                                          child: Image.asset(
                                            "assets/images/about-logo.png",
                                            fit: BoxFit.cover,
                                          )
                                      ),
                                      SizedBox(height:15),
                                      Text(
                                        'КТО МЫ ТАКИЕ?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFFFEDC00),
                                            fontSize: 28,
                                            letterSpacing: 0.02,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        'ДАВАЙТЕ ЗНАКОМИТЬСЯ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            letterSpacing: 0.02,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height:30),
                            HtmlWidget('${snapshot.data.data[0].translation?.body.toString()}')
                          ],
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