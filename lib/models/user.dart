import 'package:flutter/material.dart';


class User with ChangeNotifier{
  String userName;
  String fullName;
  List<String> paths;
  int contact;
  String role;


  User({
    this.userName,
    this.fullName,
    this.paths,
    this.contact,
    this.role
  });

}

class Users with ChangeNotifier{
  User newUser = new User();

  User create(){
    newUser = new User();
    return newUser;
  }

  String add(String userName, String fullName, int userContact, String role){
    newUser.userName = userName;
    newUser.fullName = fullName;
    newUser.contact = userContact;
    newUser.role = role;
    return "User Logged In";
  }

  User getUser(){
    return newUser;
  }

  void dispose(){
    newUser.dispose();
  }
}

class CreateUser with ChangeNotifier{
  User newUser = new User();

  User getUser(){
    return newUser;
  }

  bool addPaths(List<String> paths){
    newUser.paths = new List<String>();
    newUser.paths.addAll(paths);
    return true;
  }

  void disposePhotos(){
    newUser.paths.clear();
  }

  void dispose(){
    newUser.dispose();
  }

}

