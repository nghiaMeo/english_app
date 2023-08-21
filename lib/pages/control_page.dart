import 'package:english_app/values/app_assets.dart';
import 'package:english_app/values/app_colors.dart';
import 'package:english_app/values/app_styles.dart';
import 'package:english_app/values/share_keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  double sliderValue = 5;
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    initDefaultValue();
  }

  initDefaultValue() async {
    preferences = await SharedPreferences.getInstance();
    int value = preferences.getInt(ShareKeys.counter) ?? 5;
    setState(() {
      sliderValue = value.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        title: Text(
          'Your control',
          style:
              AppStyles.h4.copyWith(color: AppColors.textColor, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.setInt(ShareKeys.counter, sliderValue.toInt());
            Navigator.pop(context);
          },
          child: Image.asset(AppAssets.leftArrow),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 70),
        alignment: Alignment.center,
        width: double.infinity,
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Text(
              'How much a number at once',
              style: AppStyles.h1.copyWith(
                color: AppColors.lightGrey,
                fontSize: 18,
              ),
            ),
          ),
          Text(
            sliderValue.toInt().toString(),
            style: AppStyles.h1.copyWith(
                color: AppColors.primaryColor,
                fontSize: 150,
                fontWeight: FontWeight.bold),
          ),
          Slider(
            value: sliderValue,
            min: 5,
            max: 100,
            activeColor: AppColors.primaryColor,
            inactiveColor: AppColors.primaryColor,
            divisions: 95,
            onChanged: (value) {
              setState(() {
                sliderValue = value;
              });
            },
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Slide to set',
              style: AppStyles.h5.copyWith(
                color: AppColors.textColor,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
