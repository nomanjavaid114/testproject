

import 'dart:io';

import 'package:antrakuser/data/singleton/singleton.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications{

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static String? deviceToken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static FirebaseNotifications get instance => FirebaseNotifications();

  Future<String?> getDeviceToken() async {

    await  FirebaseMessaging.instance.getToken().then((token) {
      if (token != null) {
        deviceToken = token;
        SingleToneValue.instance.dvToken=deviceToken;
        print("Dv token ${SingleToneValue.instance.dvToken}");
      }
    }).catchError((onError) {
      print("the error is ${onError}");
    });
    return deviceToken;
  }



}