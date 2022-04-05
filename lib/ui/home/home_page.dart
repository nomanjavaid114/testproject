
import 'package:antrakuser/ui/values/size_config.dart';
import 'package:antrakuser/ui/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../values/values.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var mediaQuery = MediaQuery
        .of(context)
        .size;
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.size15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [



              ],
            ),
          ),
        ),
      ),
    );
  }

}