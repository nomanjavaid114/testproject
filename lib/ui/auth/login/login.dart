import 'package:antrakuser/controllers/auth_controller/auth_controller.dart';
import 'package:antrakuser/ui/auth/signup/signup.dart';
import 'package:antrakuser/ui/values/dimens.dart';
import 'package:antrakuser/ui/values/my_colors.dart';
import 'package:antrakuser/ui/values/my_fonts.dart';
import 'package:antrakuser/ui/values/my_imgs.dart';
import 'package:antrakuser/ui/values/size_config.dart';
import 'package:antrakuser/ui/values/strings.dart';
import 'package:antrakuser/ui/widgets/custom_button.dart';
import 'package:antrakuser/ui/widgets/custom_textfield.dart';
import 'package:antrakuser/ui/widgets/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          return authController.onLoginPopScope();
        },
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(Dimens.size20),
              child: Column(
                children: [
                  Container(
                    height: getHeight(Dimens.size250),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: getHeight(Dimens.size50),),
                        Text(
                          Strings.login,
                          style: textTheme.headline1,
                        ),
                        Text(
                          Strings.sign_in,
                          style: textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: getHeight(300),
                    // color: MyColors.yellow,
                    child: Form(
                      key: authController.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Strings.email,
                            style: textTheme.subtitle2!
                                .copyWith(fontSize: getFont(12)),
                          ),
                          // EmailTextField(
                          //   text: Strings.enterEmail,
                          //   controller: authController.emailController,
                          // ),
                          GetBuilder<AuthController>(
                            builder: (context) {
                              return CustomTextField(
                                  text: Strings.example_email,
                                  length: 30,
                                  controller: authController.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                autovalidateMode: authController.emailController.text.length>=1 ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                                onChanged: (value){
                                  authController.update();
                                },
                                inputFormatters: FilteringTextInputFormatter.deny(RegExp('[ ]')),

                              );
                            }
                          ),
                          Text(
                            Strings.password,
                            style: textTheme.subtitle2!
                                .copyWith(fontSize: getFont(12)),
                          ),
                          CustomTextField(
                              text: "*********",
                              controller: authController.passwordController,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              sufficon: 1,
                              length: 50,
                              keyboardType: TextInputType.emailAddress,
                              inputFormatters: FilteringTextInputFormatter.singleLineFormatter,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {

                                },
                                child: Text(Strings.forgot_password,
                                    style: textTheme.caption!.copyWith(
                                      color: MyColors.darkBlue,
                                    )),
                              ),
                            ],
                          ),
                          CustomButton(
                              height: Dimens.size40,
                              width: 374,
                              text: Strings.login,
                              onPressed: () {
                                authController.emailCheck(authController.emailController.text);
                              }),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Dimens.size16,
                      ),
                      Text(Strings.or,
                          style: textTheme.subtitle2!
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: Dimens.size16,
                      ),
                      GoogleButton(),
                      SizedBox(
                        height: Dimens.size30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(Strings.have_acoount, style: textTheme.caption),
                          GestureDetector(
                              onTap: () {
                                Get.offAll(() => SignUp());
                              },
                              child: Text(Strings.create_account,
                                  style: textTheme.subtitle1!.copyWith(
                                      color: MyColors.darkBlue,
                                      fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
  final Color? borderColor;
  final Color? textColor;

  GoogleButton({
    this.textColor,
    this.borderColor,
  });
  AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        authController.googleSignIn.signOut();
        authController.loginWithGoogle();
      },
      child: Container(
        height: getHeight(Dimens.size40),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
                color:
                    borderColor == null ? MyColors.primaryColor : borderColor!),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: Dimens.size50, right: Dimens.size14),
              child: Image.asset(
                MyImgs.google,
                height: Dimens.size24,
              ),
            ),
            Text(
              Strings.google,
              style: textColor == null
                  ? textTheme.headline3
                  : textTheme.headline3!.copyWith(color: textColor),
            )
          ],
        ),
      ),
    );
  }
}

// class EmailTextField extends StatelessWidget {
//
//   final String text;
//   TextEditingController? controller;
//   EmailTextField({
//     Key? key,
//
//     this.controller,
//     required this.text,
//
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     var textTheme = theme.textTheme;
//     var mediaQuery = MediaQuery.of(context).size;
//     SizeConfig().init(context);
//
//     return Container(
//       padding: EdgeInsets.only(left: 10, right: 15),
//       margin: EdgeInsets.symmetric(vertical: 5),
//       height: getHeight(Dimens.size40),
//       width:  mediaQuery.width ,
//       decoration: BoxDecoration(
//           //  color: MyColors.appBackground,
//           borderRadius: BorderRadius.circular(5),
//           border: Border.all(color: MyColors.greyFont, width: 0.2)),
//       child: TextFormField(
//         // autovalidateMode: AutovalidateMode.onUserInteraction,
//         maxLength: 35,
//         cursorHeight: 25,
//         maxLines: 1,
//         validator: (value) {
//           if (value!.isEmpty) {
//             return 'please Enter Email';
//           }
//           if (GetUtils.isEmail(value)) {
//             return null;
//           }
//           if (!GetUtils.isEmail(value)) {
//             return " Enter Valid Email ";
//           }
//           return null;
//         },
//         style: textTheme.bodyText2!.copyWith(),
//         controller: controller,
//         keyboardType: TextInputType.emailAddress,
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           counterText: "",
//           border: InputBorder.none,
//           hintText: text,
//           hintStyle: TextStyle(
//             color: MyColors.greyFont,
//             fontFamily: MyFonts.ubuntu,
//             fontWeight: FontWeight.normal,
//             fontSize: Dimens.size14,
//           ),
//           contentPadding: const EdgeInsets.only(left: 8, bottom: 12),
//         ),
//       ),
//     );
//   }
// }
