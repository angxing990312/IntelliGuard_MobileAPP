import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import 'take_photo.dart';
import '../models/user.dart';

class GuestSU extends StatefulWidget {
  static const routeName = '/guest_signup';
  @override
  _GuestSUState createState() => _GuestSUState();
}

class _GuestSUState extends State<GuestSU> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final userId = TextEditingController();
  final userPw = TextEditingController();
  final fullName = TextEditingController();
  final contact = TextEditingController();

  List<String> fileName = new List<String>();

  bool checkFields() {
    print("Checking Fields...");
    print(userId.text);
    print(userPw.text);
    print(contact.text);
    if (userId.text.isEmpty || userPw.text.isEmpty || contact.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<String> createUser(String file) async {
    var url = 'http://maddintelliguard.azurewebsites.net/api/Data/Users';
    final response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: convert.jsonEncode({
          "UserName": userId.text,
          "FullName": fullName.text,
          "UserPw": userPw.text,
          "UPhotoPath": file,
          "UserContact": int.parse(contact.text),
        }));
    print("Create User Status: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return (response.body);
  }

  Future<String> uploadPhoto(String path) async {
    var url = 'https://maddintelliguard.azurewebsites.net/api/UploadOnePhoto';
    List<int> byteData = await File(path).readAsBytes();
    FormData data = FormData.fromMap({
      'photo': MultipartFile.fromBytes(
        byteData,
        filename: "image.jpeg",
        contentType: MediaType("image", "jpeg"),
      ),
    });

    Dio dio = new Dio();
    Response response = await dio.post(url, data: data);
    print("Response: ${response.toString()}");

    return response.data["filename"];
  }

  Future<bool> multiFaceSignup(String id) async {
    String path = fileName[0];
    for (int i = 1; i < fileName.length; i++) {
      path += ",${fileName[i]}";
    }
    print(path);

    var url =
        'http://maddintelliguard.azurewebsites.net/api/multifacesignup?id=$id&PathInURL=$path';
    print(url);
    Dio dio = new Dio();
    Response response = await dio.post(url);
    if (response.statusCode == 200) {
      print(response.statusCode);
      print("Face Added!");
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register() async {
    final provider = Provider.of<CreateUser>(context, listen: false);
    User user = provider.getUser();
    print(user.paths);

    if (user.paths == null) {
      return false;
    } else {
      String id = await createUser(user.paths[0]);

      for (String path in user.paths) {
        String guid = await uploadPhoto(path);
        fileName.add(guid);
      }

      bool faceSignup = await multiFaceSignup(id);
      return faceSignup;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
          ),
          Center(
              child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 30, right: 30),
            children: <Widget>[
              Image.asset(
                'images/Intelliguard.jpg',
                height: 350,
                width: 200,
              ),
              RaisedButton(
                child: Text("Register Face"),
                onPressed: () async {
                  final provider =
                      Provider.of<CreateUser>(context, listen: false);
                  if (provider.getUser().paths != null) {
                    provider.disposePhotos();
                  }
                  Navigator.of(context).pushNamed(CameraScreen.routeName);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Colors.blueGrey[200],
              ),
              SizedBox(height: 36.0),
              TextFormField(
                controller: userId,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'User ID',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: userPw,
                autofocus: false,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
              SizedBox(height: 24.0),
              TextFormField(
                controller: fullName,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: contact,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Contact No.',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    if (!checkFields()) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Please fill in all fields'),
                      ));
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('Registering...')));
                      register().then((value) {
                        if (value) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Register Complete!'),
                          ));
                          Navigator.pop(context);
                        } else {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Please re-take the photos'),
                          ));
                        }
                      });
                    }
                  },
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                  color: Colors.blueAccent,
                  child:
                      Text('Sign Up!', style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}
