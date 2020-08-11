import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewNews extends StatelessWidget {

  final String title;
  final String url;

  WebViewNews({this.title, this.url});

  static const routeName = '/webviewNews';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.lightBlue,
      title: Text(title),
    ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
