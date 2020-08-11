import 'package:flutter/material.dart';
import 'package:intelliguard/screens/show_entries.dart';
import '../screens/news.dart';
import '../screens/chart.dart';

class Choice {
  Choice({this.title, this.icon, this.page});

  final String title;
  final IconData icon;
  final Widget page;
}

 List<Choice> choices =  <Choice>[
   Choice(title: 'HISTORY', icon: Icons.list, page: ShowEntries()),
   Choice(title: 'NEWS', icon: Icons.chrome_reader_mode, page: News()),
   Choice(title: 'INFORMATION', icon: Icons.insert_chart, page: Chart()),
   Choice(title: 'SCAN', icon: Icons.settings_input_antenna, page: Chart()),
];

