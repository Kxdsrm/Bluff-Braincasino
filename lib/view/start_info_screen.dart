import 'package:bluff_brain/storage/storage_keys.dart';
import 'package:bluff_brain/storage/storage_utils.dart';
import 'package:bluff_brain/utils/imageUtils.dart';
import 'package:bluff_brain/utils/music_manager.dart';
import 'package:bluff_brain/view/home_screen.dart';
import 'package:bluff_brain/view/user_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartInfoScreen extends StatefulWidget {
  const StartInfoScreen({super.key});

  @override
  State<StartInfoScreen> createState() => _StartInfoScreenState();
}

class _StartInfoScreenState extends State<StartInfoScreen> {

  bool clickBtn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Color(0xff1E0058),
            image: DecorationImage(image: AssetImage(imgOnboarding),fit: BoxFit.cover)
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
             mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 75,),
                Image.asset(txtTitle),
                Image.asset(txtPlayQuizz),
              ],
            ),
            Positioned(
                bottom: MediaQuery.of(context).size.height * 0.18,
                child: InkWell(
                  onTap: () async {
                    MusicManager().playMusic(
                        MusicManager.mBtnClick);
                     clickBtn = true;
                     setState(() {});
                     String userName = await StorageUtils.getString(kUserName)!;
                     Future.delayed(Duration(milliseconds: 100), () {
                       setState(() {
                         clickBtn = false;
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
                               return userName.isNotEmpty ? HomeScreen() : UserInfoScreen();
                             },
                           ),
                               (Route<dynamic> route) => false,

                         );
                       });
                     });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    transform: clickBtn ? Matrix4.diagonal3Values(0.95, 0.95, 1.0) : Matrix4.identity(),
                    child:Image.asset(
                      btnNext,
                      fit: BoxFit.fitWidth,
                    ),),
                ),)
          ],
        ),
      ),
    );
  }
}
