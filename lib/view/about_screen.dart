import 'package:bluff_brain/utils/imageUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String aboutText ="We created Bluff & Brain Quiz Casino for all casino lovers who enjoy a good challenge! Whether you're new to casino games or a seasoned player, this game is the perfect way to test and improve your knowledge of Blackjack, Baccarat, Craps, and Poker—all while having fun. The idea behind this game is simple: learning casino games should be exciting, not boring! That’s why we designed a free-to-play casino quiz with innovative graphics and engaging questions that make every level feel like a real casino challenge. You don’t need to spend real money—just log in daily, earn free coins, and unlock new levels as you master different casino games. We wanted to create a game that’s both fun and educational. Whether you're brushing up on Blackjack rules, testing your poker knowledge, or just curious about different casino games, Bluff & Brain Quiz Casino is for you. So, if you love casinos, quizzes, and a little friendly competition, give it a try! Answer questions, win coins, and see how much you really know about the casino world. No risk, just fun!";

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
                    aboutText,
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
