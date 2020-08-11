import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intelliguard/screens/news_display.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  List data;

  Future<String> _getNews() async {
    String url =
        "https://maddintelliguard.azurewebsites.net/api/mobile/GetTop20News";

    var response = await http.get(url, headers: {
      "Accept": "application/json",
    });

    print("News Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      print(response.body);

      data = json.decode(response.body);

      return "Success";
    }
  }

  Widget _printGrid() {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.lightBlue,
                elevation: 10,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Image.network(data[index]['by']),
                    ),
                    ListTile(
                      title: Text(data[index]['title']),
                      trailing: FlatButton(
                        child: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewNews(
                                  title: data[index]['title'],
                                  url: data[index]['link'],
                                ),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        FutureBuilder(
          future: _getNews(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _printGrid();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
        ),
      ],
    );
  }
}
