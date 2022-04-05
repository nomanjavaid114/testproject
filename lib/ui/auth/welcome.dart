
import 'package:antrakuser/ui/auth/signup/signup.dart';
import 'package:antrakuser/ui/values/dimens.dart';
import 'package:antrakuser/ui/values/my_colors.dart';
import 'package:antrakuser/ui/values/my_imgs.dart';
import 'package:antrakuser/ui/values/size_config.dart';
import 'package:antrakuser/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../values/strings.dart';
import 'login/login.dart';


class WelcomeScreen extends StatelessWidget {

   WelcomeScreen({Key? key}) : super(key: key);

  int id=1;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
        body: Container(
          width: getWidth(double.infinity),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: getHeight(Dimens.size120),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: Dimens.size250),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(

                      children: [

                        CustomButton(text: Strings.createNewAccount, width: Dimens.size374, height: Dimens.size40,
                          color: MyColors.white,
                          textColor: MyColors.primaryColor,
                          borderColor:MyColors.white,
                          onPressed: () {
                            Get.off(SignUp());
                        },

                        ),
                        SizedBox(height: getHeight(Dimens.size10),),
                        CustomButton(text: Strings.loginExisting, width: Dimens.size374, height: Dimens.size40,
                          color: Colors.transparent,
                          textColor: MyColors.white,
                          borderColor:MyColors.white,
                          onPressed: () {
                           Get.off(Login());
                          },

                        ),
                      ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: getHeight(Dimens.size16),),
                Text(Strings.or, style: Get.textTheme.subtitle2!.copyWith(fontSize: getFont(18),fontWeight: FontWeight.w500)),
                Padding(
                  padding: const EdgeInsets.all(Dimens.size20),
                  child: GoogleButton(
                    borderColor: MyColors.white,
                    textColor: MyColors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Strings.welcomeBottomTxt1, style: Get.textTheme.subtitle2!.copyWith(fontSize: getFont(14),fontWeight: FontWeight.normal,
                        color: MyColors.white
                      )),

                    ],
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }
}

