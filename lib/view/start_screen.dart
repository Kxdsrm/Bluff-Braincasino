import 'package:bluff_brain/storage/storage_keys.dart';
import 'package:bluff_brain/utils/imageUtils.dart';
import 'package:bluff_brain/view/start_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../storage/storage_utils.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {


  @override
  void initState() {
    // TODO: implement initState
    _init();
    super.initState();
  }

  _init() async {
    bool isFirstTime = await StorageUtils.isAvailable(kFirstTime);
    bool isMusic = await StorageUtils.isAvailable(kMusic);
    bool isQuizMusic = await StorageUtils.isAvailable(kQuizMusic);

    if(!isFirstTime){
      await StorageUtils.setBool(kFirstTime,false);
    }
    if(!isMusic){
      await StorageUtils.setBool(kMusic,true);
    }
    if(!isQuizMusic){
      await StorageUtils.setBool(kQuizMusic,true);
    }
    Future.delayed(Duration(seconds: 3),() {
      Navigator.pushAndRemoveUntil(
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
          pageBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return StartInfoScreen();
          },
        ),
            (Route<dynamic> route) => false,

      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xff5CA1DC),
            image: DecorationImage(image: AssetImage(imgStart),fit: BoxFit.cover)
        ),
      ),
    );
  }
}
