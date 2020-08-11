import 'package:flutter/material.dart';
import 'package:intelliguard/widgets/daily_cases.dart';

import 'package:intelliguard/widgets/total_cases.dart';

class Chart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Card(
            elevation: 5,
            shadowColor: Colors.grey,
            child: Column(
              children: <Widget>[
                Text("Total Confirmed Cases - By Month"),
                SizedBox(
                  height: 10,
                ),
                Container(child: LineChartCases(),margin: EdgeInsets.symmetric(vertical: 40),),
              ],
            ),
          ),
          SizedBox(),
          Card(
            elevation: 5,
            shadowColor: Colors.grey,
            child: Column(
              children: <Widget>[
                Text("Cases within the past week"),
                SizedBox(
                  height: 10,
                ),
                Container(child: BarChart()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
