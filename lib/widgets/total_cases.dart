import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LineChartCases extends StatefulWidget {
  @override
  _LineChartCasesState createState() => _LineChartCasesState();
}

class _LineChartCasesState extends State<LineChartCases> {
  int _time;
  List items;
  Map<String, num> _measures;

  final month = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  Future<void> getMonthlyCases() async {
    var url =
        "https://maddintelliguard.azurewebsites.net/api/mobile/GetMonthlyCases";
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

  List<DailyCases> _populateConfirmedCases() {
    List<DailyCases> cases = new List<DailyCases>();
    for (var i in items) {
      int month = i["month"];
      int amount = i["confirmedCases"];

      DailyCases dailyCases = new DailyCases(month, amount, 3);

      cases.add(dailyCases);
    }
    return cases;
  }

  List<DailyCases> _populateRecoveredCases() {
    List<DailyCases> cases = new List<DailyCases>();
    for (var i in items) {
      int month = i["month"];
      int amount = i["recoveredCases"];

      DailyCases dailyCases = new DailyCases(month, amount, 3);

      cases.add(dailyCases);
    }
    return cases;
  }

  List<charts.Series<DailyCases, int>> _sampleData() {
    var totalCases = _populateConfirmedCases();

    var recoveredCases = _populateRecoveredCases();

    final blue = charts.MaterialPalette.blue.makeShades(2);
    final red = charts.MaterialPalette.red.makeShades(2);

    return [
      new charts.Series<DailyCases, int>(
        id: 'Total',
        colorFn: (DailyCases sales, _) => blue[1],
        strokeWidthPxFn: (DailyCases sales, _) => sales.strokeWidthPx,
        domainFn: (DailyCases sales, _) => sales.date,
        measureFn: (DailyCases sales, _) => sales.cases,
        data: totalCases,
      ),
      new charts.Series<DailyCases, int>(
        id: 'Recovered',
        colorFn: (DailyCases sales, _) => red[1],
        strokeWidthPxFn: (DailyCases sales, _) => sales.strokeWidthPx,
        domainFn: (DailyCases sales, _) => sales.date,
        measureFn: (DailyCases sales, _) => sales.cases,
        data: recoveredCases,
      ),
    ];
  }

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    int time;
    final measures = <String, num>{};
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.date;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.cases;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  Widget _buildChart() {
    final children = <Widget>[
      new Padding(
        padding: EdgeInsets.all(32.0),
        child: SizedBox(
          height: 200,
          child: new charts.LineChart(
            _sampleData(),
            defaultRenderer:
                new charts.LineRendererConfig(includeArea: true, stacked: true),
            animate: false,
            selectionModels: [
              new charts.SelectionModelConfig(
                  type: charts.SelectionModelType.info,
                  changedListener: _onSelectionChanged)
            ],
          ),
        ),
      )
    ];

    if (_time != null) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Text(month[_time - 1])));
    }
    _measures?.forEach((String series, num value) {
      children.add(new Text('$series: $value'));
    });

    return new Column(
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMonthlyCases(),
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
  }
}

class DailyCases {
  final int date;
  final int cases;
  final double strokeWidthPx;

  DailyCases(this.date, this.cases, this.strokeWidthPx);
}
