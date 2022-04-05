
import 'package:antrakuser/data/model/logout_modal/logout_modal.dart';
import 'package:antrakuser/data/model/session_modal/session_modal.dart';
import 'package:antrakuser/data/model/signup_modal/signup_modal.dart';
import 'package:antrakuser/data/model/signup_modal/verify_email_modal.dart';
import 'package:antrakuser/data/singleton/singleton.dart';
import 'package:antrakuser/ui/home/home_page.dart';
import 'package:antrakuser/ui/values/my_colors.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../ui/auth/signup/signup.dart';
import '../constants/constants.dart';
import '../repository.dart';

class AuthProvider extends GetConnect {
  static const String _name = "name";
  static const String _bearer_token = "bearer_token";

  /// login
  Future<dynamic> loginApi({
    required String email,
    required String password,
  }) async {
    httpClient.timeout = Duration(seconds: 100);
    final response = await post(
      "${Constants.baseUrl}users/login",
      {
        "email": email,
        "password": password,
        "deviceToken": SingleToneValue.instance.dvToken!
      },
    ).whenComplete(() => Get.back());
    if (response.statusCode == 200) {
      SignUpModal loginModal = SignUpModal.fromJson(response.body);
      if (loginModal.responseCode == '1') {
        GetStorage().write("name", loginModal.response![0].firstName!);
        GetStorage().write("last_name", loginModal.response![0].lastName!);
        GetStorage().write("user_id", loginModal.response![0].userId!);
        GetStorage().write("bearer_token", loginModal.response![0].accessToken);
        print("access token:  ${GetStorage().read("bearer_token")}    end");
        print("value $loginModal");
        return loginModal;
      } else {
        return loginModal;
      }
    } else {
      return Future.error(response.statusText!);
    }
  }

  /// google sign in api
  Future<dynamic> socialAuthApi({
    required String email,
  }) async {
    httpClient.timeout = Duration(seconds: 100);

    final response = await post(
      "${Constants.baseUrl}users/googlesignin",
      {"email": email, 'deviceToken': SingleToneValue.instance.dvToken},
    ).whenComplete(() => Get.back());
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      SignUpModal loginModal = SignUpModal.fromJson(response.body);
      print("value $loginModal");
      if (loginModal.responseCode == '1') {
        GetStorage().write(_name, loginModal.response![0].firstName!);
        GetStorage().write("last_name", loginModal.response![0].lastName!);
        GetStorage().write("user_id", loginModal.response![0].userId!);
        GetStorage().write("bearer_token", loginModal.response![0].accessToken);
        print("access token:  ${GetStorage().read(_bearer_token)}    end");
      }

      return loginModal;
    }
  }

  ///user sign up
  Future<SignUpModal> signupUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String dvToken,
    required String countryCode,
    required String gKey,
  }) async {
    SignUpModal? model;
    httpClient.timeout = Duration(seconds: 100);
    try {
      var response = await post("${Constants.baseUrl}users/register", {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "phoneNum": phone,
        "deviceToken": dvToken,
        "gkey": gKey,
        "countryCode": countryCode,
      }, headers: {
        'Accept': 'application/json',
      }).whenComplete(() => Get.back());
      if (response.statusCode == 200) {
        model = SignUpModal.fromJson(response.body);
        if (model.responseCode == "1") {
          if(model.response![0].accessToken!.length>5){
            GetStorage().write(_name, model.response![0].firstName!);
            GetStorage().write("last_name", model.response![0].lastName!);
            GetStorage().write("user_id", model.response![0].userId!);
            GetStorage().write("bearer_token", model.response![0].accessToken);
          }
          return model;

        } else {
          throw Exception(model.errors);
        }
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception(model!.errors!);
    }
  }

  ///verify email api
  Future<VerifyEmailModal> verifySignupEmailApi({
    required String userID,
    required String otp,
  }) async {
    VerifyEmailModal? model;
    httpClient.timeout = Duration(seconds: 100);
    try {
      var response = await post("${Constants.baseUrl}users/vemail", {
        "userId": userID,
        "OTP": otp,
      }, headers: {
        'Accept': 'application/json',
      }).whenComplete(() => Get.back());
      if (response.statusCode == 200) {
        model = VerifyEmailModal.fromJson(response.body);
        if (model.responseCode == "1") {
          GetStorage().write(_name, model.response![0].firstName!);
          GetStorage().write("last_name", model.response![0].lastName!);
          GetStorage().write("user_id", model.response![0].userId!);
          GetStorage().write("bearer_token", model.response![0].accessToken);
          return model;
        } else {
          throw Exception(model.errors);
        }
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception(model!.errors!);
    }
  }





  /// otp resend api
  Future<dynamic> otpResendAPi({
    required String email,
  }) async {
    httpClient.timeout = Duration(seconds: 100);
    final response = await post(
      "${Constants.baseUrl}users/resendotp",
      {
        "email": email,
      },
    ).whenComplete(() => Get.back());
    if (response.statusCode == 200) {
      SignUpModal resetPasswordModel = SignUpModal.fromJson(response.body);
      return resetPasswordModel;
    } else {
      return Future.error(response.statusText!);
    }
  }


  ///logout api
  Future<LogoutModal> logoutApi() async {
    LogoutModal? model;
    httpClient.timeout = Duration(seconds: 100);
    var response = await get("${Constants.baseUrl}users/logout", headers: {
      'Accept': 'application/json',
      'accessToken': '${GetStorage().read("bearer_token")}',
    }).whenComplete(() => Get.back());
    if (response.statusCode == 200) {
      model = LogoutModal.fromJson(response.body);
      if (model.responseCode == "1") {
        return model;
      } else {
        return onApiError(model.errors!);
      }
    } else {
      return Future.error(response.statusText!);
    }
  }

  onApiError(String errors) {
    Get.snackbar("Error", errors,
      backgroundColor: MyColors.red500,
      colorText: MyColors.white,
    );
  }
}
