import 'dart:async';
import 'dart:io';

import 'package:antrakuser/data/model/signup_modal/signup_modal.dart';
import 'package:antrakuser/data/model/signup_modal/verify_email_modal.dart';
import 'package:antrakuser/data/singleton/singleton.dart';
import 'package:antrakuser/data/validation.dart';
import 'package:antrakuser/ui/auth/email_verification.dart';
import 'package:antrakuser/ui/auth/login/login.dart';
import 'package:antrakuser/ui/home/home_page.dart';
import 'package:antrakuser/ui/values/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:antrakuser/data/api/auth_api.dart';
import 'package:antrakuser/data/repository.dart';
import 'package:antrakuser/data/singleton/singleton.dart';
import 'package:antrakuser/ui/auth/signup/signup.dart';
import 'package:antrakuser/ui/auth/welcome.dart';
import 'package:antrakuser/ui/home/home_page.dart';
import 'package:antrakuser/ui/widgets/progress_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../GetServices/CheckConnectionService.dart';
import '../../ui/values/my_colors.dart';

import '../../data/repository.dart';
import '../../ui/widgets/progress_bar.dart';

class AuthController extends GetxController {
  var isLoading = true.obs;
  bool noInternet = false;
  bool resendOtp = false;
  final _repository = Repository();
  final validation = ValidationOfField();

  CheckConnectionService connectionService = CheckConnectionService();

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController otp = TextEditingController();

  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> changePasswordKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  /// login button

  loginButton() async {
    if (formKey.currentState!.validate()) {
      try {
        final result =      await InternetAddress.lookup('google.com').timeout(Duration(
          seconds: 5,
        ));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // when connected
          Get.dialog(ProgressBar(), barrierDismissible: false);
          loginFunction(emailController.text, passwordController.text);
        } else {
          //when no internet
          Get.snackbar("Error", "Please check your internet connection!",
              backgroundColor: MyColors.red500, colorText: MyColors.white);
        }
      } catch (e) {
        Get.snackbar("Error", "Please check your internet connection!",
            backgroundColor: MyColors.red500, colorText: MyColors.white);
      }
    }
  }

  emailCheck(String value) {
    bool boolCheck = false;
    if (value.isEmpty) {
      return Fluttertoast.showToast(
        msg: 'Please Enter Email', // message
        toastLength: Toast.LENGTH_LONG, // length
        gravity: ToastGravity.CENTER,
        backgroundColor: MyColors.red500,
        textColor: MyColors.white,
        // location// duration
      );
    }
    if (GetUtils.isEmail(value)) {
      return loginButton();
    }
    if (!GetUtils.isEmail(value)) {
      return Fluttertoast.showToast(
        msg: "Please enter valid email", // message
        toastLength: Toast.LENGTH_LONG, // length
        gravity: ToastGravity.CENTER,
        backgroundColor: MyColors.red500,
        textColor: MyColors.white,
        // location// duration
      );
    }
  }

  loginFunction(
    String email,
    String password,
  ) {
    _repository.login(email: email, password: password).then((value) {
      if (value is SignUpModal) {
        if (value.responseCode == '1') {
          GetStorage().write("logged_user", value);
          Get.snackbar(
            "Message",
            value.responseMessage.toString(),
            backgroundColor: MyColors.green600,
            duration: Duration(seconds: 5),
            colorText: MyColors.white,
          );
          Get.offAll(() => HomePage());
        } else if (value.responseCode == '2') {
          SingleToneValue.instance.userId = value.response![0].userId;
          Get.snackbar(
            "Error",
            value.responseMessage.toString(),
            backgroundColor: MyColors.red500,
            duration: Duration(seconds: 5),
            colorText: MyColors.white,
          );
          Get.to(EmailVerification());
        } else {
          Get.snackbar(
            "Error",
            value.responseMessage.toString(),
            backgroundColor: MyColors.red500,
            duration: Duration(seconds: 5),
            colorText: MyColors.white,
          );
        }
      }
    }, onError: (error) {
      Get.snackbar("Error", error.toString(),
          backgroundColor: MyColors.red500,
          duration: Duration(seconds: 5),
          colorText: MyColors.white);
    });
  }

  ///sign up user
  signUpUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String dvToken,
    required String countryCode,
    required String gKey,
  }) async {
    try {
      await _repository
          .signupUserRepo(
              firstName: firstName,
              lastName: lastName,
              email: email,
              password: password,
              phone: phone,
              dvToken: dvToken,
              countryCode: countryCode,
              gKey: gKey)
          .then((value) {
        if (value.responseCode == '1') {
          SingleToneValue.instance.userId = value.response![0].userId;
          signUpDataDelete();
          if (gKey == '1') {
            GetStorage().write("name", value.response![0].firstName!);
            GetStorage().write("last_name", value.response![0].firstName!);
            GetStorage().write("user_id", value.response![0].userId!);
            GetStorage().write("bearer_token", value.response![0].accessToken);
            Get.offAll(() => HomePage());
          } else {
            Get.offAll(() => EmailVerification());
            Get.snackbar(
              "Signup",
              value.responseMessage.toString(),
              backgroundColor: MyColors.green600,
              colorText: MyColors.white,
            );
          }
        }
      });
    } catch (e) {
      Get.snackbar(
        "Exception",
        e.toString().replaceAll('Exception:', ''),
        backgroundColor: MyColors.red500,
        colorText: MyColors.white,
      );
    }
  }

  /// login with google
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      Get.dialog(ProgressBar(), barrierDismissible: false);
      final authResult = await _auth.signInWithCredential(credential);

      final User? user = authResult.user;
      assert(!user!.isAnonymous);
      assert(await user!.getIdToken() != null);
      final User? currentUser = _auth.currentUser;
      assert(user!.uid == currentUser!.uid);
      SingleToneValue.instance.socialName = user!.displayName!;

      socialAuth(semail: "${user.email}");

      return user;
    } catch (e) {
      throw (e);
    }
  }

  ///verify signup email
  verifyEmail({
    required String userID,
    required String otp,
  }) async {
    try {
      await _repository.verifyUserEmail(userID: userID, otp: otp).then((value) {
        if (value.responseCode == '1') {
          otpClear();
          Get.offAll(() => HomePage());
        }
      });
    } catch (e) {
      Get.snackbar(
        "Exception",
        e.toString().replaceAll('Exception:', ''),
        backgroundColor: MyColors.red500,
        colorText: MyColors.white,
      );
    }
  }

  ///on verify button
  verifyButton() async {
    var flagConnected = false;
    final result = await InternetAddress.lookup('google.com').timeout(Duration(
      seconds: 5,
    ));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      // when connected
      flagConnected = true;

      if (flagConnected) {
        final isValid = otpFormKey.currentState!.validate();
        if (!isValid) {
          return;
        } else {
          Get.dialog(ProgressBar(), barrierDismissible: false);
          verifyEmail(userID: SingleToneValue.instance.userId!, otp: otp.text);
        }
      }
    } else {
      //when no internet
      Get.snackbar("Error", "Please check your internet connection!",
          backgroundColor: MyColors.red500, colorText: MyColors.white);
    }
  }

  ///otp resend api
  otpResendApi() async {
    Get.dialog(ProgressBar(), barrierDismissible: false);
    await _repository
        .otpResendRepo(email: "${SingleToneValue.instance.resendEmail}")
        .then((value) {
      if (value.responseCode == '1') {
        resendOtp = false;
        update();
        Get.snackbar("OTP Resend", value.responseMessage.toString(),
            backgroundColor: MyColors.green600, colorText: MyColors.white);
      } else {
        Get.snackbar(
          "Error",
          value.responseMessage.toString(),
          backgroundColor: MyColors.red500,
          duration: Duration(seconds: 5),
          colorText: MyColors.white,
        );
      }
    });
  }

  /// social auth
  socialAuth({
    required String semail,
  }) async {
    await _repository.socialAuth(semail).then((value) async {
      //  Get.back();
      if (value.responseCode == "1") {
        Get.snackbar("Login", value.responseMessage.toString(),
            backgroundColor: MyColors.green600, colorText: MyColors.white);
        Get.offAll(() => HomePage());
      } else {
        Get.snackbar("Login", value.errors.toString(),
            backgroundColor: MyColors.red500, colorText: MyColors.white);
        email.text = SingleToneValue.instance.socialEmail;
        Get.off(SignUp(
          readOnly: true,
        ));
        update();
      }
    }, onError: (error) {
      print("value Erorr $error");
      Get.snackbar(
        "Login",
        error.toString(),
        backgroundColor: MyColors.red500,
        colorText: MyColors.white,
      );
    });
  }

  ///logout data clear
  onlogout() async {
    await googleSignIn.signOut();
    GetStorage().remove('name');
    GetStorage().remove('email');
    GetStorage().remove('last_name');
    GetStorage().write('bearer_token', "");
  }



  /// email check
  emailCheckRegister(String value, String key) {
    if (registerFormKey.currentState!.validate()) {
      if (value.isEmpty) {
        return Fluttertoast.showToast(
          msg: 'Please Enter Email',
          // message
          toastLength: Toast.LENGTH_LONG,
          // length
          gravity: ToastGravity.CENTER,
          backgroundColor: MyColors.red500,
          textColor: MyColors.white,
          // location// duration
        );
      }
      if (GetUtils.isEmail(value)) {
        return onRegisterButton(key);
      }
      if (!GetUtils.isEmail(value)) {
        return Fluttertoast.showToast(
          msg: "Please enter valid email",
          // message
          toastLength: Toast.LENGTH_LONG,
          // length
          gravity: ToastGravity.CENTER,
          backgroundColor: MyColors.red500,
          textColor: MyColors.white,
          // location// duration
        );
      }
    }
  }

  ///on register button
  onRegisterButton(String gKey) async {
    var flagConnected = false;
    final result = await InternetAddress.lookup('google.com').timeout(Duration(
      seconds: 5,
    ));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      // when connected
      flagConnected = true;

      if (flagConnected) {
        if (password.text == confirmpassword.text) {
          Get.dialog(ProgressBar(), barrierDismissible: false);
          signUpUser(
              firstName: firstName.text,
              lastName: lastName.text,
              email: email.text,
              password: password.text,
              phone: phone.text,
              countryCode: SingleToneValue.instance.code + "-",
              dvToken: SingleToneValue.instance.dvToken!,
              gKey: gKey);
        } else {
          Get.snackbar("Error", 'Your Password does not match',
              backgroundColor: MyColors.red500, colorText: MyColors.white);
        }
      }
    } else {
      //when no internet
      Get.snackbar("Error", "Please check your internet connection!",
          backgroundColor: MyColors.red500, colorText: MyColors.white);
    }
  }

  onLoginPopScope() {
    Get.off(WelcomeScreen());
  }


  /// time counter
  Timer timer = Timer(Duration(milliseconds: 1), () {});
  int start = 30;

  startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          timer.cancel();
          update();
        } else {
          start--;
          update();
        }
      },
    );
  }

  ///

  signUpDataDelete() {
    firstName.clear();
    lastName.clear();
    email.clear();
    phone.clear();
    confirmpassword.clear();
    password.clear();
    SingleToneValue.instance.code = "+1";
  }

  changePasswordDelete() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
  }

  otpClear() {
    otp.clear();
  }

  /// pop scope
  onVerifyPopScope() {
    Get.offAll(Login());
    resendOtp = false;
  }

  String? first_name;
  String? last_name;
  @override
  void onInit() {
    first_name = GetStorage().read("name");
    last_name = GetStorage().read("last_name");

    // TODO: implement onInit
    super.onInit();
  }
}
