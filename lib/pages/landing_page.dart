import 'package:english_app/pages/home_page.dart';
import 'package:english_app/values/app_assets.dart';
import 'package:english_app/values/app_colors.dart';
import 'package:english_app/values/app_styles.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Welcome to',
                  style: AppStyles.h3,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'English',
                      style: AppStyles.h2.copyWith(
                        color: AppColors.blackGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 65),
                      child: Text(
                        'Qoutes”',
                        style: AppStyles.h4.copyWith(height: 0.1),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: RawMaterialButton(
                padding: const EdgeInsets.symmetric(vertical: 16),
                // ignore: sort_child_properties_last
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      // ignore: prefer_const_constructors
                      MaterialPageRoute(builder: (_) => HomePage()),
                      (route) => false);
                },
                shape: const CircleBorder(),
                fillColor: AppColors.lighBlue,
                child: Image.asset(AppAssets.rightArrow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
