import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late  SharedPreferences sharedPreferences;
  static Future<void> init()async => sharedPreferences = await SharedPreferences.getInstance();


  static void setBool({required String key,required bool value}){
    sharedPreferences.setBool(key, value);
  }
  static bool? getBool({required String key}){
    return sharedPreferences.getBool(key);
  }
}
