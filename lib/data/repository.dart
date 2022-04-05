
import 'package:antrakuser/data/api/auth_api.dart';
import 'package:antrakuser/data/model/logout_modal/logout_modal.dart';
import 'package:antrakuser/data/model/session_modal/session_modal.dart';
import 'package:antrakuser/data/model/signup_modal/signup_modal.dart';
import 'package:antrakuser/data/model/signup_modal/verify_email_modal.dart';
import 'package:antrakuser/data/closable.dart';

class Repository implements Closable {
  final _authClient = AuthProvider();


  ///signup user

  Future<SignUpModal> signupUserRepo({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String dvToken,
    required String countryCode,
    required String gKey,
  }) async {
    return await _authClient.signupUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phone: phone,
        dvToken: dvToken,
        countryCode: countryCode,
        gKey: gKey);
  }

  /// verify user email

  Future<VerifyEmailModal> verifyUserEmail({
    required String userID,
    required String otp,
  }) async {
    return await _authClient.verifySignupEmailApi(userID: userID, otp: otp);
  }


  /// login api call
  Future<SignUpModal> login({
    required String email,
    required String password,
  }) async {
    return await _authClient.loginApi(
      email: email,
      password: password,
    );
  }

  /// google sign in api call
  Future<SignUpModal> socialAuth(String email) async {
    return await _authClient.socialAuthApi(email: email);
  }





  ///otp resend api
  Future<SignUpModal> otpResendRepo({
    required String email,
  }) async {
    return await _authClient.otpResendAPi(email: email);
  }



  ///logout repo
  Future<LogoutModal> logoutRepo() async {
    return await _authClient.logoutApi();
  }

  @override
  void close() {}
}
