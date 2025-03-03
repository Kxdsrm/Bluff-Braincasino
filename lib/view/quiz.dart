import 'dart:convert';

import 'package:bluff_brain/utils/common_widgets.dart';
import 'package:bluff_brain/utils/imageUtils.dart';
import 'package:bluff_brain/utils/music_manager.dart';
import 'package:bluff_brain/view/quiz_result.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../model/question.dart';

class LiveQuiz extends StatefulWidget {
  final int level;

  const LiveQuiz({Key? key, required this.level}) : super(key: key);

  @override
  _LiveQuizState createState() => _LiveQuizState();
}

class _LiveQuizState extends State<LiveQuiz>
    with SingleTickerProviderStateMixin {
  String id = "";
  String question = '';
  List<Question> quizquestionList = [];
  int questionIndex = 0;
  bool isLoading = true;

  int selectedAns = -1;
  bool isAns = false;

  bool isCheckAns = false;

  bool disableAnsSelect = false;
  String correctAns = "";
  String selectedAnsName = "";

  final int _duration = 20;
  final CountDownController _controller = CountDownController();

  int totalRightAns = 0;
  int totalWrongAns = 0;
  int totalSkipped = 0;

  late SharedPreferences sharedPreferences;
  String lastQuestionId = "0";
  String languageCode = "";

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    loadQuestion();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    MusicManager().stopMusic();
    super.deactivate();
  }

  Future<void> loadQuestion() async {
    setState(() {
      isLoading = true;
    });
    quizquestionList.clear();
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
      if(widget.level == 1) {
        var response = jsonDecode(remoteConfig.getString('level1'));
        quizquestionList.addAll(
            response.map<Question>((json) => Question.fromJson(json)).toList());
      }else if(widget.level == 2) {
        var response = jsonDecode(remoteConfig.getString('level2'));
        quizquestionList.addAll(
            response.map<Question>((json) => Question.fromJson(json)).toList());
      }else if(widget.level == 3) {
        var response = jsonDecode(remoteConfig.getString('level3'));
        quizquestionList.addAll(
            response.map<Question>((json) => Question.fromJson(json)).toList());
      }else if(widget.level == 4) {
        var response = jsonDecode(remoteConfig.getString('level4'));
        quizquestionList.addAll(
            response.map<Question>((json) => Question.fromJson(json)).toList());
      }
      isLoading = false;
      _controller.start();
      MusicManager().playMusic(MusicManager.mQuizCountdown);
    } catch (exception) {
      print(
          'Unable to fetch remote config. Cached or default values will be used');
    }
    setState(() {
      print("quizquestionList ${quizquestionList.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    widget.level == 1
                    ? imgBgQuiz
                    : widget.level == 2
                        ? imgBgLevelTwo
                        : widget.level == 3
                            ? imgBgLevelThree
                            : imgBgLevelFour),
                fit: BoxFit.cover)),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                isLoading
                    ? Container()
                    : Container(
                        width: double.infinity,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Image.asset(
                                  imgBackArrow,
                                  color: Colors.amber,
                                )),
                          ],
                        ),
                      ),
                Image.asset( widget.level == 1
                    ? imgLevelOneTop
                    : widget.level == 2
                    ? imgLevelTwoTop
                    : widget.level == 3
                    ? imgTopThree
                    : imgTopFour),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                            children: [
                              spaceVertical(space: 30),
                              Container(
                                // height: MediaQuery.of(context).size.height - 140,
                                // width: double.infinity,
                                margin: const EdgeInsets.only(
                                    left: 16, top: 0, right: 16, bottom: 0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF),
                                    borderRadius: BorderRadius.circular(30),
                                    border:
                                        Border.all(color: Color(0xffA42FC1))),
                                child: Column(
                                  children: [
                                    spaceVertical(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${totalRightAns < 10 ? '0$totalRightAns' : totalRightAns}',
                                              style: setTextStyle(
                                                  clr: Color(0xff1F8435),
                                                  size: 18),
                                            ),
                                            Image.asset(imgRectangleGreen),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${totalWrongAns < 10 ? '0$totalWrongAns' : totalWrongAns}',
                                              style: setTextStyle(
                                                  clr: Color(0xff1F8435),
                                                  size: 18),
                                            ),
                                            Image.asset(imgRectangleRed),
                                          ],
                                        ),
                                      ],
                                    ),
                                    spaceVertical(),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        child: Text(
                                          "QUESTION ${questionIndex + 1} / ${quizquestionList.length}",
                                          style: setTextStyle(
                                              clr: Color(0xffA42FC1),
                                              fontWeight: FontWeight.bold),
                                        )),
                                    spaceVertical(),
                                    Visibility(
                                      visible: quizquestionList.isNotEmpty &&
                                          quizquestionList.length >
                                              questionIndex,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          quizquestionList[questionIndex]
                                              .question!,
                                          textAlign: TextAlign.center,
                                          style: setTextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              spaceVertical(),
                              _questionAnswerList(
                                  quizquestionList[questionIndex]
                                      .quizQuestionOptionMobBean!,
                                  selectedAns),
                              Visibility(
                                visible:
                                    selectedAns != -1 && isAns && isCheckAns,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text("That’s the right Answer: +10 Coins",
                                        style: setTextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible:
                                    selectedAns != -1 && !isAns && isCheckAns,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text("That’s the wrong Answer",
                                        style: setTextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: selectedAns != -1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 50),
                                  child: isCheckAns
                                      ? InkWell(
                                          onTap: () {
                                            MusicManager().playMusic(
                                                MusicManager.mBtnClick);
                                            if (quizquestionList.length - 1 ==
                                                questionIndex) {
                                              print(totalRightAns);
                                              totalSkipped =
                                                  quizquestionList.length -
                                                      totalWrongAns -
                                                      totalRightAns;
                                              double per = 0.0;
                                              per = (totalRightAns /
                                                      quizquestionList.length) *
                                                  100.00;
                                              per.toStringAsFixed(2);
                                              print(per.toStringAsFixed(2));

                                              Navigator.pushReplacement(
                                                  context,
                                                  PageRouteBuilder(
                                                    transitionsBuilder:
                                                        (context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child) {
                                                      return ScaleTransition(
                                                        alignment:
                                                            Alignment.center,
                                                        scale: Tween<double>(
                                                                begin: 0.1,
                                                                end: 1)
                                                            .animate(
                                                          CurvedAnimation(
                                                            parent: animation,
                                                            curve: Curves
                                                                .bounceInOut,
                                                          ),
                                                        ),
                                                        child: child,
                                                      );
                                                    },
                                                    transitionDuration:
                                                        Duration(seconds: 2),
                                                    pageBuilder: (BuildContext
                                                            context,
                                                        Animation<double>
                                                            animation,
                                                        Animation<double>
                                                            secondaryAnimation) {
                                                      return QuizResult(
                                                        level: widget.level,
                                                        totalCorrect:
                                                            totalRightAns
                                                                .toString(),
                                                        totalWrong:
                                                            totalWrongAns
                                                                .toString(),
                                                        totalQuestion:
                                                            quizquestionList
                                                                .length
                                                                .toString(),
                                                      );
                                                    },
                                                  ));
                                            } else {
                                              selectedAns = -1;
                                              isAns = false;
                                              isCheckAns = false;
                                              disableAnsSelect = false;
                                              questionIndex = questionIndex + 1;
                                              _controller.restart(
                                                  duration: _duration);
                                              _controller.start();
                                              try {
                                                MusicManager().stopMusic();
                                                MusicManager().playMusic(
                                                    MusicManager
                                                        .mQuizCountdown);
                                              } catch (e) {}
                                              setState(() {});
                                            }
                                            setState(() {});
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text("Next",
                                                  style: setTextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              spaceHorizontal(),
                                              Image.asset(btnCircle)
                                            ],
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            MusicManager().stopMusic();
                                            MusicManager().playMusic(
                                                MusicManager.mBtnClick);
                                            if (isAns) {
                                              totalRightAns = totalRightAns + 1;
                                            } else {
                                              totalWrongAns = totalWrongAns + 1;
                                            }
                                            disableAnsSelect = true;
                                            isCheckAns = true;
                                            _controller.pause();
                                            setState(() {});
                                          },
                                          child: Image.asset(btnCircle),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Center(
                              child: CircularCountDownTimer(
                                duration: _duration,
                                initialDuration: 0,
                                controller: _controller,
                                width: 70,
                                height: 70,
                                ringColor: Colors.green,
                                ringGradient: null,
                                fillColor: Colors.white,
                                fillGradient: null,
                                backgroundColor: Colors.white,
                                backgroundGradient: null,
                                strokeWidth: 5.0,
                                strokeCap: StrokeCap.round,
                                textStyle: setTextStyle(clr: Colors.green),
                                textFormat: CountdownTextFormat.S,
                                isReverse: false,
                                isReverseAnimation: false,
                                isTimerTextShown: true,
                                autoStart: true,
                                onStart: () {
                                  selectedAns = -1;
                                  isAns = false;
                                  isCheckAns = false;
                                  disableAnsSelect = false;
                                  setState(() {});
                                },
                                onComplete: () {
                                  debugPrint('Countdown Ended');
                                  setState(() {
                                    MusicManager().stopMusic();
                                    selectedAns = -2;
                                    disableAnsSelect = true;
                                    isCheckAns = true;
                                    _controller.pause();
                                    _controller.reset();
                                  });
                                },
                                onChange: (String timeStamp) {
                                  debugPrint('Countdown Changed $timeStamp');
                                },
                                timeFormatterFunction:
                                    (defaultFormatterFunction, duration) {
                                  if (duration.inSeconds == 0) {
                                    return "0";
                                  } else {
                                    return Function.apply(
                                        defaultFormatterFunction, [duration]);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _questionAnswerList(
      List<QuizQuestionOptionMobBean> questionOptionMobBean, int ans) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: questionOptionMobBean.length,
      itemBuilder: (context, index) {
        if (questionOptionMobBean[index].isOption!) {
          correctAns = questionOptionMobBean[index].name!;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: InkWell(
            onTap: () {
              print(index);
              if (!disableAnsSelect) {
                selectedAns = index;
                selectedAnsName = questionOptionMobBean[index].name!;
                isAns = questionOptionMobBean[index].isOption!;
                setState(() {});
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      questionOptionMobBean[index].name!,
                      style: setTextStyle(),
                    ),
                  ),
                  Image.asset(selectedAns == index && !isCheckAns
                      ? imgRight
                      : isCheckAns
                          ? questionOptionMobBean[index].isOption!
                              ? imgRight
                              : imgWrong
                          : imgDefaultQuestion)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
