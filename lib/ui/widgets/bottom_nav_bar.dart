import 'package:antrakuser/controllers/auth_controller/auth_controller.dart';
import 'package:antrakuser/ui/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../values/values.dart';

class BottomNavBar extends StatelessWidget {
  AuthController authController=Get.find();
  BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: mediaQuery.height * 0.145,
      width: mediaQuery.width,
      color: Colors.transparent,
      child: Stack(children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: mediaQuery.height * 0.086,
            width: mediaQuery.width,
            color: MyColors.primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {

                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu),
                        Text(
                          "Orders",
                          style: textTheme.bodyText1!
                              .copyWith(fontSize: 12, color: MyColors.white),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      authController.onlogout();

                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       Icon(Icons.person),
                        Text(
                          "Logout",
                          style: textTheme.bodyText1!
                              .copyWith(fontSize: 12, color: MyColors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () {
                Get.offAll(() => HomePage(),
                    transition: Transition.noTransition);
              },
              child: SizedBox(
                  width: mediaQuery.width * 0.23,
                  height: mediaQuery.height * 0.12,
                  child: CircleAvatar(
                    backgroundColor: MyColors.white,
                    child: Card(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Icon(Icons.local_airport_outlined),
                        )),
                  )),
            )),
      ]),
    );
  }
}
