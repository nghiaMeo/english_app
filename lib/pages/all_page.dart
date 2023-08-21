import 'package:english_app/models/english_today.dart';
import 'package:english_app/values/app_assets.dart';
import 'package:english_app/values/app_colors.dart';
import 'package:english_app/values/app_styles.dart';
import 'package:flutter/material.dart';

class AllPage extends StatelessWidget {
  final List<EnglishToday> words;
  const AllPage({Key? key, required this.words}) : super(key: key);

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
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: (index % 2 == 0)
                  ? AppColors.primaryColor
                  : AppColors.secondColor,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Icon(
                Icons.favorite,
                color: words[index].isFavorite ? Colors.red : Colors.grey,
              ),
              title: Text(
                words[index].noun ?? '',
                style: AppStyles.h5.copyWith(color: AppColors.textColor),
              ),
              subtitle: Text(
                words[index].quote ?? '',
                style: AppStyles.h6.copyWith(color: AppColors.textColor),
              ),
            ),
          );
        },
      ),
    );
  }
}
