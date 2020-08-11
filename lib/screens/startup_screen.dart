import 'package:flutter/material.dart';

class Startup extends StatelessWidget {
  static const routeName = '/startup';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF79A7D3),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Image.asset(
              'images/white_logo.png',
              height: 200.0,
              width: 200.0,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
