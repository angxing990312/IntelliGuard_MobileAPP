import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'package:http/http.dart' as http;

class BarChart extends StatefulWidget {
  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {

  List items;

  Future<void> getDailyCases() async {
    var url = "https://maddintelliguard.azurewebsites.net/api/mobile/GetPastWeekCases";
    var response = await http.get(url, headers: {
      "Accept": "application/json",
    });

    print(response.body);

    if (response.statusCode == 200) {
        items = json.decode(response.body);
        print(response.body);

        return "Success";
    }

  }

  List<Cases> _populateData(){
    List<Cases> cases = new List<Cases>();
    for(var i in items){
      List<String> date = i["date"].split("/");
      String month = "${date[0]} ${date[1]}";
      int amount = i["cases"];

      Cases newCase = new Cases(month, amount, Colors.lightBlue);

      cases.add(newCase);
    }
    return cases;
  }

  Widget _buildChart(){

    var data = _populateData();


    var series = [
      charts.Series(
        domainFn: (Cases data, _) => data.month,
        measureFn: (Cases data, _) => data.amount,
        colorFn: (Cases data, _) => data.color,
        labelAccessorFn: (Cases data, _) => '${data.amount}',
        id: 'Spending',
        data: data,
      ),
    ];

    var chart = charts.BarChart(
      series,
      animate: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(),
    );

    return Padding(
      padding: EdgeInsets.all(32.0),
      child: SizedBox(
        height: 200.0,
        child: chart,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var chartWidget =
      FutureBuilder(
        future: getDailyCases(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildChart();
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner
          return CircularProgressIndicator();
        },
      );

    return chartWidget;
  }
}

class Cases {
  final String month;
  final int amount;
  final charts.Color color;

  Cases(this.month, this.amount, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
