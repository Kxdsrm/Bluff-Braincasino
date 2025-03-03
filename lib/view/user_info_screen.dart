import 'package:bluff_brain/storage/storage_keys.dart';
import 'package:bluff_brain/utils/common_widgets.dart';
import 'package:bluff_brain/utils/imageUtils.dart';
import 'package:bluff_brain/utils/music_manager.dart';
import 'package:bluff_brain/view/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../storage/storage_utils.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {

  bool clickBtn = false;
  TextEditingController _txtName = TextEditingController();
  bool isShowGender = false;
  String selectedGender = "";
  var style = GoogleFonts.novaFlat(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.white,);
  final GlobalKey<FormState> _cadastroKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Color(0xff1E0058),
            image: DecorationImage(image: AssetImage(bgOnboarding),fit: BoxFit.cover)
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [


            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.30,vertical: 8),
              child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 70,),
                  TextFormField(
                    controller:_txtName,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.transparent,
                      hintStyle: style,
                      hintText: "Enter a nickname",
                      contentPadding: EdgeInsets.all(0),

                    ),
                  ),
                  Image.asset(imgLine),
                  InkWell(
                    onTap: () {
                      isShowGender = !isShowGender;
                      setState(() {});
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       Text(selectedGender.isEmpty ? "Select Gender" : selectedGender,style: style,),
                       Icon(isShowGender ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down,color: Colors.white,),
                    ],),
                  ),
                  Image.asset(imgLine),
                  Visibility(
                    visible: isShowGender,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(children: [
                        InkWell(
                            onTap: () {
                              isShowGender = false;
                              selectedGender = "Male";
                              setState(() {});
                            },
                            child: Text("Male",style: GoogleFonts.novaFlat(fontSize: 16, fontWeight: FontWeight.w400,color: selectedGender == "Male" ? Colors.green : Colors.white,),)),
                        Image.asset(imgLine),
                        SizedBox(height: 8,),
                        InkWell(
                            onTap: () {
                              isShowGender = false;
                              selectedGender = "Female";
                              setState(() {});
                            },
                            child: Text("Female",style: GoogleFonts.novaFlat(fontSize: 16, fontWeight: FontWeight.w400,color: selectedGender == "Female" ? Colors.green : Colors.white,),)),
                        Image.asset(imgLine),
                      ],),
                    ),
                  ),
                  spaceVertical(),
                  InkWell(
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
                      _checkValidation();
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      curve: Curves.easeInOut,
                      transform: clickBtn ? Matrix4.diagonal3Values(0.95, 0.95, 1.0) : Matrix4.identity(),
                      child:Image.asset(
                        btnSubmit,
                        fit: BoxFit.fitWidth,
                      ),),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  _checkValidation() async {
    String name = _txtName.text.toString();
    if(name.isEmpty){
      toastMessage(message: "Please enter name");
    }else if(name.length < 3){
      toastMessage(message: "Name should be at least 3 characters");
    }else if(selectedGender.isEmpty){
      toastMessage(message: "Please select gender");
    }else{
      await StorageUtils.setString(kUserName,name);
      await StorageUtils.setString(kUserGender,selectedGender);
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
            return HomeScreen();
          },
        ),
            (Route<dynamic> route) => false,

      );
    }
  }
}
