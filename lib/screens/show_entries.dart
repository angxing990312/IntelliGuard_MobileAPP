import 'package:flutter/material.dart';

import '../widgets/display_entry.dart';

class ShowEntries extends StatefulWidget {
  static const routeName = '/showEntries';

  @override
  _ShowEntriesState createState() => _ShowEntriesState();
}

class _ShowEntriesState extends State<ShowEntries> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Display(),
        ),
      ],
    );
  }
}
