import 'package:bluff_brain/storage/storage_keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../storage/storage_utils.dart';
import '../utils/imageUtils.dart';
import '../utils/music_manager.dart';
import 'home_screen.dart';

class LevelFourReward extends StatefulWidget {
  const LevelFourReward({super.key});

  @override
  State<LevelFourReward> createState() => _LevelFourRewardState();
}

class _LevelFourRewardState extends State<LevelFourReward> {

  bool clickBtn = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 0),
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
            color: Color(0xff5CA1DC),
            image: DecorationImage(image: AssetImage(imgLevelFourReward),fit: BoxFit.cover)
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
                top: 50,
                child: Image.asset(imgYouWinCoin)),
            Positioned(
              bottom: 0,
              child: InkWell(
                onTap: () {
                  MusicManager().playMusic(
                      MusicManager.mBtnClick);
                  MusicManager().playMusic(
                      MusicManager.mSpellOfReward);
                  clickBtn = true;
                  setState(() {});
                  Future.delayed(Duration(milliseconds: 100), () {
                    setState(() {
                      clickBtn = false;
                    });
                  });
                  StorageUtils.addCoin(pointsCoin: 3000);
                  StorageUtils.setBool(kisLevelFourRewardCollect, false);
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
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  transform: clickBtn ? Matrix4.diagonal3Values(0.95, 0.95, 1.0) : Matrix4.identity(),
                  child:Image.asset(
                    btnCollectRewards,
                  ),),
              ),
            ),
          ],
        )
      ),
    );
  }
}
