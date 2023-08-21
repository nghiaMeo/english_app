import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_app/models/english_today.dart';
import 'package:english_app/packages/qoute.dart';
import 'package:english_app/packages/qouute_model.dart';
import 'package:english_app/pages/all_page.dart';
import 'package:english_app/pages/all_word_page.dart';
import 'package:english_app/pages/control_page.dart';
import 'package:english_app/values/app_assets.dart';
import 'package:english_app/values/app_colors.dart';
import 'package:english_app/values/app_styles.dart';
import 'package:english_app/values/share_keys.dart';
import 'package:english_app/widgets/app_buttons.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  late PageController _pageController;

  List<EnglishToday> words = [];
  String randomQuote = Quotes().getRandom().content!;

  List<int> fixedListRandom({int len = 1, int max = 120, int min = 1}) {
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

  getEnglishToday() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int _length = preferences.getInt(ShareKeys.counter) ?? 5;
    List<String> newList = [];
    List<int> randoms = fixedListRandom(len: _length, max: nouns.length);
    randoms.forEach((index) {
      newList.add(nouns[index]);
    });
    setState(() {
      words = newList
          .map((e) => getQuote(
                e,
              ))
          .toList();
    });
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
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    getEnglishToday();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
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
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
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
            PageViews(size),

            _currentIndex >= 5
                ? buildShowMore()
                : Padding(
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
                              return buildIndicator(
                                  index == _currentIndex, size);
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
      drawer: Drawer(
        child: Container(
          color: AppColors.lighBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 16),
                child: Text(
                  'Your mind',
                  style: AppStyles.h3.copyWith(
                    color: AppColors.textColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButtons(label: 'Favorites', onTap: () {}),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButtons(
                    label: 'Your control',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ControlPage()));
                    }),
              ),
            ],
          ),
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

  Widget PageViews(Size size) {
    return SizedBox(
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
            padding: const EdgeInsets.all(10),
            child: Material(
              color: AppColors.primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              child: InkWell(
                enableFeedback: false,
                onTap: () {
                  setState(() {
                    words[index].isFavorite = !words[index].isFavorite;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: index > 5
                      ? InkWell(
                          enableFeedback: false,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AllPage(
                                          words: words,
                                        )));
                          },
                          child: Center(
                            child: Text(
                              'Show more...',
                              style: AppStyles.h4.copyWith(
                                  color: AppColors.textColor,
                                  shadows: [
                                    const BoxShadow(
                                      offset: Offset(3, 6),
                                      blurRadius: 6,
                                      color: Colors.black38,
                                    ),
                                  ]),
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            LikeButton(
                              
                              onTap: (bool isLiked) async {
                                setState(() {
                                  words[index].isFavorite =
                                      !words[index].isFavorite;
                                });
                                return words[index].isFavorite;
                              },
                              isLiked: words[index].isFavorite,
                              mainAxisAlignment: MainAxisAlignment.end,
                              size: 42,
                              circleColor: const CircleColor(
                                  start: Color(0xff00ddff),
                                  end: Color(0xff0099cc)),
                              bubblesColor: const BubblesColor(
                                dotPrimaryColor: Color(0xff33b5e5),
                                dotSecondaryColor: Color(0xff0099cc),
                              ),
                              likeBuilder: (bool isLiked) {
                                return ImageIcon(
                                  const AssetImage(AppAssets.heart),
                                  color: words[index].isFavorite
                                      ? Colors.red[400]
                                      : Colors.white,
                                  size: 42,
                                );
                              },
                            ),
                            // Container(
                            //   alignment: Alignment.centerRight,
                            //   child: Image.asset(AppAssets.heart,
                            //       // ignore: dead_code
                            //       color: words[index].isFavorite
                            //           ? Colors.red[400]
                            //           : Colors.white),
                            // ),
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: firstLetter.toUpperCase(),
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
                                child: AutoSizeText(
                                  qoute,
                                  maxFontSize: 26,
                                  style: AppStyles.h5.copyWith(
                                      letterSpacing: 1,
                                      color: AppColors.textColor),
                                  // maxLines: 7,
                                  // overflow: TextOverflow.ellipsis,
                                )),
                          ],
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      curve: Curves.decelerate,
      height: 5,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
        color: isActive ? AppColors.lighBlue : AppColors.lightGrey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: const [
          BoxShadow(color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
        ],
      ),
    );
  }

  Widget buildShowMore() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      alignment: Alignment.centerLeft,
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        color: AppColors.primaryColor,
        elevation: 4,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AllWordPage(words: words),
                ));
          },
          splashColor: Colors.black38,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: AppColors.primaryColor,
            child: Text(
              'Show more',
              style: AppStyles.h5.copyWith(
                color: AppColors.textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
