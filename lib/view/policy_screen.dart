import 'package:bluff_brain/utils/imageUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  String policyText =
      "Bluff & Brain Quiz Casino is an engaging app that combines the thrill of casino games with challenging quizzes. Test your knowledge and strategy skills in a vibrant, animated 3D environment. Perfect for trivia enthusiasts and casino lovers alike."
      "Bluff & Brain Quiz Casino is an engaging app that combines the thrill of casino games with challenging quizzes. Test your knowledge and strategy skills in a vibrant, animated 3D environment. Perfect for trivia enthusiasts and casino lovers alike."
      "Bluff & Brain Quiz Casino is an engaging app that combines the thrill of casino games with challenging quizzes. Test your knowledge and strategy skills in a vibrant, animated 3D environment. Perfect for trivia enthusiasts and casino lovers alike."
      "Bluff & Brain Quiz Casino is an engaging app that combines the thrill of casino games with challenging quizzes. Test your knowledge and strategy skills in a vibrant, animated 3D environment. Perfect for trivia enthusiasts and casino lovers alike."
      "Bluff & Brain Quiz Casino is an engaging app that combines the thrill of casino games with challenging quizzes. Test your knowledge and strategy skills in a vibrant, animated 3D environment. Perfect for trivia enthusiasts and casino lovers alike."
      "Bluff & Brain Quiz Casino is an engaging app that combines the thrill of casino games with challenging quizzes. Test your knowledge and strategy skills in a vibrant, animated 3D environment. Perfect for trivia enthusiasts and casino lovers alike."
      "Bluff & Brain Quiz Casino is an engaging app that combines the thrill of casino games with challenging quizzes. Test your knowledge and strategy skills in a vibrant, animated 3D environment. Perfect for trivia enthusiasts and casino lovers alike."
      "Bluff & Brain Quiz Casino is an engaging app that combines the thrill of casino games with challenging quizzes. Test your knowledge and strategy skills in a vibrant, animated 3D environment. Perfect for trivia enthusiasts and casino lovers alike.";

  var style = GoogleFonts.novaFlat(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Color(0xff5CA1DC),
              image: DecorationImage(
                  image: AssetImage(imgBgPolicy), fit: BoxFit.cover)),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Positioned(
                top: 50,
                left: 25,
                child: InkWell(onTap: () {
                  Navigator.pop(context);
                }, child: Image.asset(imgBackArrow)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 24, bottom: 120, top: 120),
                child: SingleChildScrollView(
                  child: Text(
                    policyText,
                    style: style,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
