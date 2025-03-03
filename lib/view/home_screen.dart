import 'package:bluff_brain/storage/storage_keys.dart';
import 'package:bluff_brain/storage/storage_utils.dart';
import 'package:bluff_brain/utils/common_widgets.dart';
import 'package:bluff_brain/utils/first_capital_leter.dart';
import 'package:bluff_brain/utils/imageUtils.dart';
import 'package:bluff_brain/view/level_four_reward.dart';
import 'package:bluff_brain/view/level_two_reward.dart';
import 'package:bluff_brain/view/quiz.dart';
import 'package:bluff_brain/view/quiz_bonus.dart';
import 'package:bluff_brain/view/settings.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  String gender = "";
  bool goToDailyBonus = false;
  int totalPoint = 0;

   int diffMinutes = (24 * 60).toInt();
  //int diffMinutes = 1;

  bool levelTwo = false;
  bool levelThree = false;
  bool levelFour = false;
  WebViewController controller = WebViewController();
  bool viewSite = false;

  @override
  void initState() {
    // TODO: implement initState
    viewSite = false;
    _int();
    super.initState();
  }

  _int() async {
    name = await StorageUtils.getString(kUserName)!;
    gender = await StorageUtils.getString(kUserGender)!;
    totalPoint = await StorageUtils.getInt(kPointsCoin)!;
    levelTwo = await StorageUtils.getBool(kisLevelTwo)!;
    levelThree = await StorageUtils.getBool(kisLevelThree)!;
    levelFour = await StorageUtils.getBool(kisLevelFour)!;
    loadData();
    _checkingBonus();
    setState(() {});
  }

  _checkingBonus() async {
    bool isAvailable = await StorageUtils.isAvailable(kLastBonusTime);

    if (isAvailable) {
      int lastBonusTime = await StorageUtils.getInt(kLastBonusTime);
      print("lastSpinTime : $lastBonusTime");
      int diff =
          (DateTime.now().millisecondsSinceEpoch - lastBonusTime).toInt();
      print("diff : $diff");
      int seconds = (diff / 1000).toInt();
      int min = (seconds / 60).toInt();
      print(min);
      if (min > diffMinutes) {
        goToDailyBonus = true;
      }
    } else {
      goToDailyBonus = true;
      StorageUtils.setInt(
          kLastBonusTime, DateTime.now().millisecondsSinceEpoch);
    }

    print("goToDailyBonus $goToDailyBonus");
    setState(() {});
  }


  Future<void> loadData() async {

    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
      var viewUrl = remoteConfig.getString('siteLink');
      viewSite = remoteConfig.getBool('viewlink');
      print("viewSite $viewSite");
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(viewUrl!));
      setState(() {});

    } catch (exception) {
      print(
          'Unable to fetch remote config. Cached or default values will be used');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Opacity(
                opacity: 0.6,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(bgHome), fit: BoxFit.cover)),
                ),
              ),
            ),
            Positioned(
                top: 50,
                left: 20,
                child: Row(
                  children: [
                    Image.asset(gender == "Male" ? imgMale : imgFemale),
                    spaceHorizontal(),
                    Text(
                      name.isEmpty ? name : name.capitalize(),
                      style: GoogleFonts.novaFlat(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    )
                  ],
                )),
            Positioned(
              top: 50,
              right: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xff927AFF),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Text(
                      '$totalPoint',
                      style: setTextStyle(clr: Colors.white),
                    ),
                    spaceHorizontal(),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundImage: AssetImage(imgCoin),
                      radius: 20,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: VerticalDivider(
                color: Colors.black,
                thickness: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.2,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Divider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              if(levelFour){
                                goToQuiz(level: 4);
                              }else{
                                toastMessage(message: "Please complete level 3");
                              }
                            },
                            child: Image.asset(levelFour ? imgUnlockFour : imgLevelFour)),
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: InkWell(
                              onTap: () {
                                if (levelFour) {
                                  goToRewardFour();
                                } else {
                                  toastMessage(
                                      message: "Please complete level 4");
                                }
                              },
                              child: Image.asset(imgReward)),
                        ),
                      ],
                    ),
                  )),
                  Expanded(
                      child: InkWell(
                        onTap: () {
                          if(levelThree){
                            goToQuiz(level: 3);
                          }else{
                            toastMessage(message: "Please complete level 2");
                          }
                        },
                        child: Image.asset(
                            levelThree ? imgUnlockThree : imgLevelThree),
                      )),
                  Expanded(
                      child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          right: MediaQuery.of(context).size.width * 0.2,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Divider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              if (levelTwo) {
                                goToQuiz(level: 2);
                              } else {
                                toastMessage(
                                    message: "Please complete level 1");
                              }
                            },
                            child: Image.asset(
                                levelTwo ? imgUnlockLevelTwo : imgLevelTwo)),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                              onTap: () {
                                if (levelThree) {
                                   goToRewardTwo();
                                } else {
                                  toastMessage(
                                      message: "Please complete level 2");
                                }
                              },
                              child: Image.asset(imgReward)),
                        ),
                      ],
                    ),
                  )),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () {
                            goToQuiz(level: 1);
                          },
                          child: Image.asset(imgLevelOne)),
                    ],
                  )),
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return ScaleTransition(
                            alignment: Alignment.center,
                            scale: Tween<double>(begin: 0.1, end: 1).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.fastEaseInToSlowEaseOut,
                              ),
                            ),
                            child: child,
                          );
                        },
                        transitionDuration: Duration(seconds: 2),
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return SettingScreen();
                        },
                      ),
                    ).then(
                      (value) {
                        _int();
                      },
                    );
                  },
                  child: Image.asset(imgSettings),
                )),
            Positioned(
                bottom: 0,
                left: 0,
                child: Visibility(
                    visible: goToDailyBonus,
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return ScaleTransition(
                                  alignment: Alignment.center,
                                  scale:
                                      Tween<double>(begin: 0.1, end: 1).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.fastEaseInToSlowEaseOut,
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                              transitionDuration: Duration(seconds: 2),
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation) {
                                return QuizBonus();
                              },
                            ),
                          ).then(
                            (value) {
                              _int();
                            },
                          );
                        },
                        child: Image.asset(imgQuizBounds)))),

            Container(
              child: Visibility(
                visible: viewSite,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 56),
                  padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),
                  child: WebViewWidget(
                      gestureRecognizers: Set()
                        ..add(Factory<VerticalDragGestureRecognizer>(
                                () => VerticalDragGestureRecognizer()
                        )),
                      controller: controller),
                ),
              ),
            ),
            Positioned(
              top: 50,
              right: 0,
              child: Visibility(
                visible: viewSite,
                child: IconButton(
                    onPressed: () {
                      viewSite = false;

                      setState(() {});
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  goToQuiz({required int level}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              alignment: Alignment.center,
              scale: Tween<double>(begin: 0.1, end: 1).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.bounceInOut,
                ),
              ),
              child: child,
            );
          },
          transitionDuration: Duration(seconds: 2),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return LiveQuiz(
              level: level,
            );
          },
        ));
  }

  goToRewardTwo() async {

    bool isCollect = await StorageUtils.getBool(kisLevelTwoRewardCollect)!;
    if(isCollect) {
      Navigator.push(
          context,
          PageRouteBuilder(
            transitionsBuilder: (context, animation, secondaryAnimation,
                child) {
              return ScaleTransition(
                alignment: Alignment.center,
                scale: Tween<double>(begin: 0.1, end: 1).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.bounceInOut,
                  ),
                ),
                child: child,
              );
            },
            transitionDuration: Duration(seconds: 2),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return LevelTwoReward();
            },
          ));
    }else{
      toastMessage(message: "Reward already collect");
    }
  }
  goToRewardFour() async {
    bool isCollect = await StorageUtils.getBool(kisLevelFourRewardCollect)!;
    if(isCollect) {
      Navigator.push(
          context,
          PageRouteBuilder(
            transitionsBuilder: (context, animation, secondaryAnimation,
                child) {
              return ScaleTransition(
                alignment: Alignment.center,
                scale: Tween<double>(begin: 0.1, end: 1).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.bounceInOut,
                  ),
                ),
                child: child,
              );
            },
            transitionDuration: Duration(seconds: 2),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return LevelFourReward();
            },
          ));
    }else{
      toastMessage(message: "Reward already collect");
    }
  }
}
