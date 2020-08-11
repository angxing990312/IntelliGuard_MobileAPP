import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/entry.dart';
import '../widgets/entry_item.dart';
import '../models/user.dart';

class Display extends StatefulWidget {
  static const routeName = '/display';
  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  List data;
  String status = "";

  Future<String> getEntries() async {
    final provider = Provider.of<Users>(context, listen: false);
    User user = provider.getUser();

    var response = await http.get(
        ("http://maddintelliguard.azurewebsites.net/api/entryrecords/${user.userName}"),
        headers: {
          "Accept": "application/json",
        });

    print("GET Entry Records Response Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      this.setState(() {
        data = json.decode(response.body);
      });

      final entryData = Provider.of<EntryHistory>(context, listen: false);
      for (int i = 0; i < data.length; i++) {
        Entry e = Entry(
          entryID: data[i]['entryID'],
          temperature: data[i]['temperature'],
          entryDateTime: data[i]['entryTime'],
          location: data[i]['location'],
        );

        entryData.addEntry(e);
      }
      print(entryData.entry[0].entryID);
      print(entryData.entry[0].temperature);
      print(entryData.entry[0].entryDateTime);

      return 'Success!';
    } else {
      return 'Empty';
    }
  }

  Widget _printGrid() {
    final entryProvider = Provider.of<EntryHistory>(context, listen: false);
    if (entryProvider.entry.length != 0) {
      return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: entryProvider.entry == null ? 0 : entryProvider.entry.length,
        itemBuilder: (BuildContext context, int i) =>
            ChangeNotifierProvider.value(
                value: entryProvider,
                child: EntryItem(
                  temperature: entryProvider.entry[i].temperature,
                  entryDateTime: entryProvider.entry[i].entryDateTime,
                  location: entryProvider.entry[i].location,
                )),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 5 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      );
    } else {
      return Center(
        child: Text("You have no records yet!"),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getEntries().then((value) => status = value);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
        ),
        _printGrid(),
      ],
    );
  }
}
