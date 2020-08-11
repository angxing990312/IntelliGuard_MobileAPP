import 'package:flutter/material.dart';

class EntryItem extends StatelessWidget {
  final num temperature;
  final String entryDateTime;
  final String location;

  EntryItem({this.temperature, this.entryDateTime, this.location});

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = const TextStyle(fontFamily: 'Poppins');

    final headerTextStyle = baseTextStyle.copyWith(
        color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600);

    final subHeaderTextStyle = baseTextStyle.copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );

    Color getTemperatureStatus(temperature) {
      if (temperature >= 38.0) {
        return Colors.red[400];
      } else if (temperature >= 37.5) {
        return Colors.orange[300];
      } else {
        return Colors.green;
      }
    }

    String getDateTime() {
      String result = entryDateTime.replaceAll("-", "/");
      result = entryDateTime.replaceFirst('T', ' ');
      return (result);
    }

    return Material(
      borderRadius: BorderRadius.circular(15),
      color: Color(0xFF79A7D3),
      child: Stack(
        children: <Widget>[
          Container(
            margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(height: 3.0),
                new Text("Entry Date/Time: ", style: headerTextStyle),
                new Container(height: 3.0),
                new Text(getDateTime(), style: headerTextStyle),
                new Container(height: 7.0),
                new Text("Temperature: $temperature Degrees",
                    style: subHeaderTextStyle),
                new Text("Location: $location",
                    style: subHeaderTextStyle)
              ],
            ),
          ),
          Container(
            child: CircleAvatar(
              backgroundColor: getTemperatureStatus(temperature),
            ),
            alignment: FractionalOffset.centerLeft,
            margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
          )
        ],
      ),
    );
  }
}
