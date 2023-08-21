import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_app/models/english_today.dart';
import 'package:english_app/values/app_assets.dart';
import 'package:english_app/values/app_colors.dart';
import 'package:english_app/values/app_styles.dart';
import 'package:flutter/material.dart';

class AllWordPage extends StatelessWidget {
  final List<EnglishToday> words;
  const AllWordPage({Key? key, required this.words}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        title: Text(
          'English today',
          style:
              AppStyles.h4.copyWith(color: AppColors.textColor, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(AppAssets.leftArrow),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: words
              .map(
                (e) => Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: AutoSizeText(
                    e.noun ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: AppStyles.h3.copyWith(shadows: [
                      const BoxShadow(
                          color: Colors.black38,
                          offset: Offset(3, 6),
                          blurRadius: 6),
                    ], color: AppColors.textColor),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
