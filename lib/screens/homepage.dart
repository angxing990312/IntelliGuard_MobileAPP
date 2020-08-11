import 'package:flutter/material.dart';
import 'package:intelliguard/screens/scan.dart';
import 'package:intelliguard/screens/show_entries.dart';
import '../models/titles.dart';
import '../screens/news.dart';
import '../screens/chart.dart';

class Homepage extends StatefulWidget {
  static const routeName = '/homepage';
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text('Intelliguard'),
          bottom: TabBar(
            tabs: choices.map((Choice choice){
              return Tab(
                  text: choice.title,
                  icon: Icon(choice.icon),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: <Widget>[ShowEntries(), News(), Chart(), ScanBeacon()],
        )
      ),
    );
  }
}
