import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xochuapp/strings/strings.dart';
import 'package:xochuapp/widgets/appbar.dart';
class Payment extends StatefulWidget {
  final String? url;
  const Payment(
      {Key? key, required this.url})
      : super(key: key);
  @override
  _PaymentState createState() => _PaymentState();
}
class _PaymentState extends State<Payment> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBarWidget(title: 'Оплата'),
      ),
      body:WebView(
        initialUrl: '${AppStrings.localUrl}/${widget.url.toString()}',
        javascriptMode: JavascriptMode.unrestricted,
      )
    );
  }
}