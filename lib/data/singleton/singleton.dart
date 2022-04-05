
import 'package:antrakuser/ui/values/strings.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SingleToneValue {
  var storage = GetStorage();

  String? status;
  String? dvToken;


  String? userId;
String  code='+1';




  String socialEmail = '';
  String? socialName;
  String? socialPhone;

  bool? emailReadonly = false;
  String? contactEmail;
  String? contactPhone;

  String? resendEmail;


  SingleToneValue._privateConstructor();

  static SingleToneValue get instance => _instance;

  static final SingleToneValue _instance =
      SingleToneValue._privateConstructor();

  factory SingleToneValue() {
    return _instance;
  }
}
