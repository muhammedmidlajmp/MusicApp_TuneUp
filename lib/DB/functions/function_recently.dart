import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:project_one_tuneup/songlist/all_songs.dart';

class Recentfunctions {
  static ValueNotifier<List<SongModel>> recenlylistnotifier = ValueNotifier([]);
  static List<dynamic> recentlyplayedsong = [];

  static Future<void> addrecentlyplayed(item) async {
    final recentdatabase = await Hive.openBox('recenlylistnotifier');
    recentdatabase.add(item);

    getallrecently();
    recenlylistnotifier.notifyListeners();
  }

  static Future<void> getallrecently() async {
    final recentdatabase = await Hive.openBox('recenlylistnotifier');
    final recentlyplayedsong = recentdatabase.values.toList();
    displaydrecent();

    recenlylistnotifier.notifyListeners();
  }

  static Future<void> displaydrecent() async {
    final recentdatabase = await Hive.openBox('recenlylistnotifier');
    final recentitems = recentdatabase.values.toList();
    recenlylistnotifier.value.clear();
    recentlyplayedsong.clear();
  
    for (int i = 0; i < recentitems.length; i++) {
      for (int j = 0; j < startsong.length; j++) {
        if (recentitems[i] == startsong[j].id) {
          recenlylistnotifier.value.add(startsong[j]);
          recentlyplayedsong.add(startsong[j]);
        }
      }
    }
  }
}
