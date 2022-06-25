import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xochuapp/providers/notifications.dart';
import 'package:xochuapp/widgets/appbar.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}
class _NotificationsState extends State<Notifications> {
  late Future fetchNotifications;
  void initState() {
    fetchNotifications = Provider.of<NotificationsProvider>(context, listen: false)
        .getNotifications();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBarWidget(title: 'Уведомления'),
        ),
        body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                FutureBuilder(
                  future: fetchNotifications,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData)
                      return ListView.builder(
                        itemCount: snapshot.data.data.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    width: 1.5,
                                    color: Color(0xFFF4F5F6)),
                              ),
                              margin: EdgeInsets.only(bottom: 15),
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.notification_important,
                                    color: Color(0xFF1B1D1F),
                                    size: 30,
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
                                      Text('${snapshot.data.data[index].title
                                          .toString()}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color(0xFF1B1D1F),
                                              fontSize: 17,
                                              letterSpacing: 0.02,
                                              fontStyle: FontStyle.italic,
                                              fontWeight:
                                              FontWeight.w800)),
                                      SizedBox(height: 5),
                                      Text('${snapshot.data.data[index].message
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
                              )
                          );
                        }
                      );
                    else
                      return Container(
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
                              'У вас пока нет уведомлений',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0xFF1B1D1F),
                                  fontSize: 17,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 0.02,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      );
                  }
                ),
              ],
            ),
          ),
        )
    );
  }
}