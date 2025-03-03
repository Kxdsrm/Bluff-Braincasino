import 'package:bluff_brain/storage/storage_keys.dart';
import 'package:bluff_brain/utils/common_widgets.dart';
import 'package:bluff_brain/utils/imageUtils.dart';
import 'package:bluff_brain/view/home_screen.dart';
import 'package:bluff_brain/view/quiz.dart';
import 'package:bluff_brain/view/start_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../storage/storage_utils.dart';
import '../utils/music_manager.dart';

class QuizResult extends StatefulWidget {
  int level;
  String totalQuestion;
  String totalCorrect;
  String totalWrong;

  QuizResult({super.key, required this.level,required this.totalQuestion,required this.totalCorrect,required this.totalWrong});

  @override
  State<QuizResult> createState() => _QuizResultState();
}

class _QuizResultState extends State<QuizResult> {

  bool clickBtn = false;
  bool clickBtnAgain = false;
  bool isNextStage = false;
  @override
  void initState() {
    // TODO: implement initState
    _setLevelUnlock();
    super.initState();
  }
  _setLevelUnlock(){
    int tQuestion = int.parse(widget.totalQuestion);
    int tNumberOfRightAns = int.parse(widget.totalCorrect);
    StorageUtils.addCoin(pointsCoin: (tNumberOfRightAns * 10));
    if(tNumberOfRightAns >= (tQuestion / 2).toInt()){
      isNextStage = true;
      setState(() {});
      switch (widget.level) {
        case 1:
          StorageUtils.setBool(kisLevelTwo, true);
          break;
        case 2:
          StorageUtils.setBool(kisLevelThree, true);
          StorageUtils.setBool(kisLevelTwoRewardCollect, true);
          break;
        case 3:
          StorageUtils.setBool(kisLevelFour, true);
          break;
        case 4:
          StorageUtils.setBool(kisLevelFourRewardCollect, true);
          break;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(bgQuizResult), fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              spaceVertical(space: 100),
              Image.asset(imgResultCheck),
              Image.asset(imgStar),
              spaceHorizontal(),
              Text(
                "You Earned ${int.parse(widget.totalCorrect) * 10} pts",
                style: setTextStyle(
                    clr: Colors.white, size: 24, fontWeight: FontWeight.bold),
              ),
              spaceVertical(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                       Expanded(child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: CircleAvatar(backgroundColor: Color(0xffA42FC1),radius: 6,),
                           ),
                           Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text("100%",style: setTextStyle(clr:Color(0xffA42FC1),size: 20),),
                               Text("Completion",style: setTextStyle(),),
                             ],
                           )
                         ],),),
                       Expanded(child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: CircleAvatar(backgroundColor: Color(0xffA42FC1),radius: 6,),
                           ),
                           Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text("${widget.totalQuestion}",style: setTextStyle(clr:Color(0xffA42FC1),size: 20),),
                               Text("Total Question",style: setTextStyle(),),
                             ],
                           )
                         ],),)
                    ],),
                    spaceVertical(),
                    Row(
                      children: [
                        Expanded(child:  Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(backgroundColor: Color(0xff1F8435),radius: 6,),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${widget.totalCorrect}",style: setTextStyle(clr:Color(0xff1F8435),size: 20),),
                                Text("Completion",style: setTextStyle(),),
                              ],
                            )
                          ],),),
                        Expanded(child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(backgroundColor: Color(0xFFFA3939),radius: 6,),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${widget.totalWrong}",style: setTextStyle(clr:Color(0xffA42FC1),size: 20),),
                                Text("Wrong",style: setTextStyle(),),
                              ],
                            )
                          ],),)
                      ],),
                  ],
                ),
              ),
              spaceVertical(),

              Visibility(
                visible: isNextStage,
                child: InkWell(
                onTap: () {
                  MusicManager().playMusic(
                      MusicManager.mBtnClick);
                  clickBtn = true;
                  setState(() {});
                  Future.delayed(Duration(milliseconds: 100), () {
                    setState(() {
                      clickBtn = false;
                    });
                  });
                  goToHome();
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  transform: clickBtn ? Matrix4.diagonal3Values(0.95, 0.95, 1.0) : Matrix4.identity(),
                  child:Image.asset(
                    btnNextStage,
                    fit: BoxFit.fitWidth,
                  ),),
              ),),

              InkWell(
                onTap: () {
                  MusicManager().playMusic(
                      MusicManager.mBtnClick);
                  clickBtnAgain = true;
                  setState(() {});
                  Future.delayed(Duration(milliseconds: 100), () {
                    setState(() {
                      clickBtnAgain = false;
                    });
                  });
                  goToQuiz(level: widget.level);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  transform: clickBtnAgain ? Matrix4.diagonal3Values(0.95, 0.95, 1.0) : Matrix4.identity(),
                  child:Image.asset(
                    btnPlayAgain,
                    fit: BoxFit.fitWidth,
                  ),),
              )
            ],
          ),
        ),
      ),
    );
  }

  goToQuiz({required int level}) {
    Navigator.pushReplacement(
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

  void goToHome() {
    Navigator.pushReplacement(
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
            return HomeScreen();
          },
        ));
  }
}
