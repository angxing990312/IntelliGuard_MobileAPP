import 'package:flutter/material.dart';

class Verified with ChangeNotifier{
  String id;
  String token;

  Verified({
    this.id,
    this.token
  });
}

class VerifiedUser with ChangeNotifier{
  Verified user = new Verified();

  Verified getUser(){
    return user;
  }

  void assignUser(id, token){
    user.id = id;
    user.token = token;
  }
}