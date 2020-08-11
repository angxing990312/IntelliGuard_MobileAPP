import 'package:flutter/material.dart';

class Entry with ChangeNotifier {
  final int entryID;
  final int userId;
  final String name;
  final num temperature;
  final String entryDateTime;
  final String location;

  Entry(
      {this.entryID,
        this.userId,
        this.name,
        this.temperature,
        this.entryDateTime, this.location});
}

class EntryHistory extends ChangeNotifier{
  List<Entry> _entry = [];

  List<Entry> get entry {
    return [..._entry];
  }

  Entry findById(int itemId){
    return _entry.firstWhere((item) => item.entryID == itemId);
  }

  void clearEntries(){
    _entry.clear();
  }

  void addEntry(Entry e){
    _entry.add(e);
  }

}
