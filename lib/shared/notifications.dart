import 'package:firebase_messaging/firebase_messaging.dart';

class NotiMessages{
  static  FirebaseMessaging messaging= FirebaseMessaging.instance;
  static String? token;


  static Future<void> getToken()async{
    token = await messaging.getToken();
  }
}