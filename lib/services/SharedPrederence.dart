import 'dart:convert';

import 'package:agtech_farmer/constants/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference{
  static String CHATLISTY="CHATLIST";
  static String ISUSERLOGIN="ISUSERLOGIN";
  static String FARMERID="FARMERID";
  static String NUMBER="NUMBER";
  static String REGION="REGION";
  static String USERTOKEN="USERTOKEN";
  static String LANGUAGE="LANGUAGE";
  static String FARMERNAME="FARMERNAME";
  static String KAIRONTOKEN="KAIRONTOKEN";


  static Future<void> savefarmerId(farmerid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(FARMERID , farmerid);
  }

  static Future<String> getFarmerId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(FARMERID );
  }

  static Future<void> saveNumber(number) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(NUMBER , number);
  }

  static Future<String> getNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(NUMBER );
  }

  static Future<void> saveRegion(region) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(REGION , region);
  }

  static Future<String> getRegion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(REGION );
  }


  static Future<void> saveUserToken(usertoken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(USERTOKEN , usertoken);
  }

  static Future<String> getUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERTOKEN );
  }


  static Future<bool> saveIsUserLogin(isuserlogin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(ISUSERLOGIN, isuserlogin);
  }

  static Future<bool> getIsUserLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(ISUSERLOGIN);
  }

  static Future<void> saveLanguage(language) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(LANGUAGE, language);
  }

  static Future<String> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LANGUAGE);
  }

  static Future<void> saveFarmerName(language) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(FARMERNAME, language);
  }

  static  Future<String> getFarmerName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(FARMERNAME);
  }

  static Future<void> saveKaironToken(kairontoken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(KAIRONTOKEN, kairontoken);
  }

  static  Future<String> getKaironToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KAIRONTOKEN);
  }
}