

import 'package:bluff_brain/storage/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';




class StorageUtils {


  static Future<bool> isAvailable(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  // set String values in shared pref
  static Future<void> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // get String values in shared pref
  static Future<String> getString(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key) ?? "";
  }

  // set int values in shared pref
  static Future<void> setInt(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  // get int values in shared pref
  static Future<int> getInt(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(key) ?? 0;
  }

  // set bool values in shared pref
  static Future<void> setBool(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  // get bool values in shared pref
  static Future<bool> getBool(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key) ?? false;
  }


  // set long values in shared pref
  static Future<void> setDouble(String key, double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  // get long values in shared pref
  static Future<double> getDouble(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble(key) ?? 0.0;
  }


  static Future<bool> deleteAllKeyData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<bool> cleanData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }


  static Future<int> addCoin({required int pointsCoin}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    int totalPointsCoin = pref.getInt(kPointsCoin) ?? 0;
    totalPointsCoin = totalPointsCoin + pointsCoin;
    pref.setInt(kPointsCoin, totalPointsCoin);
    return totalPointsCoin;
  }


  static Future<int> removeCoin({required int pointsCoin}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    int totalPointsCoin = pref.getInt(kPointsCoin) ?? 0;
    totalPointsCoin = totalPointsCoin - pointsCoin;
    pref.setInt(kPointsCoin, totalPointsCoin);
    return totalPointsCoin;
  }



}
