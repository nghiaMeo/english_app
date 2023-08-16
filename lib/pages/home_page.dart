import 'dart:math';

import 'package:english_app/models/english_today.dart';
import 'package:english_app/packages/qoute.dart';
import 'package:english_app/packages/qouute_model.dart';
import 'package:english_app/values/app_assets.dart';
import 'package:english_app/values/app_colors.dart';
import 'package:english_app/values/app_styles.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  List<EnglishToday> words = [];
  String randomQuote = Quotes().getRandom().content!;

  List<int> fixedListRadom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];

    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday() {
    List<String> newList = [];
    List<int> rans = fixedListRadom(len: 5, max: nouns.length);
    rans.forEach((index) {
      newList.add(nouns[index]);
    });
    words = newList
        .map((e) => getQuote(
              e,
            ))
        .toList();
  }

  EnglishToday getQuote(String noun) {
    Quote? quote;
    quote = Quotes().getByWord(noun);
    return EnglishToday(
      noun: noun,
      quote: quote?.content,
      id: quote?.id,
    );
  }

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.8);
    getEnglishToday();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        title: Text(
          'English today',
          style:
              AppStyles.h4.copyWith(color: AppColors.textColor, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () {},
          child: Image.asset(AppAssets.menu),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            // quote Note
            QuoteNote(size),
            // Page View
            listViewQuote(size),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: size.height * 1 / 20,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return buildIndicator(index == _currentIndex, size);
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () => {
          setState(() {
            getEnglishToday();
          })
        },
        child: Image.asset(
          AppAssets.exchange,
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget QuoteNote(Size size) {
    return Container(
      height: size.height * 1 / 10,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.topLeft,
      child: Text(
        randomQuote,
        //"It is amazing how complete is the delusion that beauty is gooodness"
        style: AppStyles.h5.copyWith(fontSize: 12, color: AppColors.textColor),
      ),
    );
  }

  Widget listViewQuote(Size size) {
    return Container(
      height: size.height * 2 / 3,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: words.length,
        itemBuilder: (context, index) {
          String firstLetter = words[index].noun!.substring(0, 1);
          String leftLetter =
              words[index].noun!.substring(1, words[index].noun!.length);
          String quoteDefault =
              '“Think of all the beauty still left around you and be happy.”';
          String qoute =
              words[index].quote != null ? words[index].quote! : quoteDefault;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(3, 6),
                    blurRadius: 6,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerRight,
                      child: Image.asset(AppAssets.heart)),
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: '${firstLetter.toUpperCase()}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: FontFamily.sen,
                          fontSize: 89,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            BoxShadow(
                              offset: Offset(3, 6),
                              blurRadius: 6,
                              color: Colors.black38,
                            ),
                          ]),
                      children: [
                        TextSpan(
                          // ignore: unnecessary_string_interpolations
                          text: '$leftLetter',
                          style: const TextStyle(
                              fontFamily: FontFamily.sen,
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                BoxShadow(
                                  offset: Offset(3, 6),
                                  blurRadius: 6,
                                  color: Colors.black38,
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        '${qoute}',
                        style: AppStyles.h4.copyWith(
                            letterSpacing: 1, color: AppColors.textColor),
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
    ;
  }

  Widget buildIndicator(bool isAcive, Size size) {
    return Container(
      height: 5,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: isAcive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
        color: isAcive ? AppColors.lighBlue : AppColors.lightGrey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: const [
          BoxShadow(color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
        ],
      ),
    );
  }
}
