import 'dart:convert';
import 'package:flutter/services.dart';
import 'models/play.dart';

class PlayRepository {
  static final PlayRepository _instance = PlayRepository._internal();

  factory PlayRepository() {
    return _instance;
  }

  PlayRepository._internal();

  List<Play> plays = [];

  Future<void> loadPlays() async {
    final String response = await rootBundle.loadString('assets/plays.json');
    final data = json.decode(response) as List;

    plays = data.map((item) => Play.fromJson(item)).toList();
  }
}
