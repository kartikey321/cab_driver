import 'package:cab_driver/datamodels/History.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier {
  String earnings = '0';
  String tripCount = '0';
  List<String> tripHistoryKeys = [];
  List<History> tripHistory = [];

  void updateEarnings(String newEarnings) {
    earnings = newEarnings;
    notifyListeners();
  }

  void updateTripCount(String newTripCount) {
    tripCount = newTripCount;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys) {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTrpHistory(History historyItem) {
    tripHistory.add(historyItem);
    notifyListeners();
  }
}
