import 'package:antrakuser/data/data_bindings/data_bindings.dart';
import 'package:antrakuser/data/firebase_notification/firebase_notification.dart';

import 'package:antrakuser/ui/auth/welcome.dart';
import 'package:antrakuser/ui/values/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


Future<void> main() async {
  await GetStorage.init();
  await Firebase.initializeApp();
  FirebaseNotifications.instance.getDeviceToken();


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Styles.appTheme,
      getPages: [
        GetPage<void>(
          name: '/',
          page: () => WelcomeScreen(),
          binding: DataBindings(),
        ),
      ],
    );
  }
}
