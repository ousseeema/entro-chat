import 'package:shared_preferences/shared_preferences.dart';

//this page will verifie if the userkey exist in the fire base
class HelperFunction {
  static String UserLoggedInKey = "loggedinkey";
  static String userNameKey = "usernamekey";
  static String userEmailKey = "useremailkey";

//saving the data to shared preferences
  static Future<bool> saveuserlogin(bool isuserlogedin) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setBool(UserLoggedInKey, isuserlogedin);
  }

  static Future<bool> saveuseremail(String useremail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userEmailKey, useremail);
  }

  static Future<bool> saveusername(String name) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userNameKey, name);
  }

// getting data from shared prefernces
  static Future<bool?> getUserLooggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(UserLoggedInKey);
  }

  static Future<String?> getuseremailkeyfromsf() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getusernamefromSf() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
}
