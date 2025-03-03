import 'dart:convert';

import 'package:bluff_brain/model/more_site.dart';
import 'package:bluff_brain/utils/imageUtils.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SiteViewScreen extends StatefulWidget {
  const SiteViewScreen({super.key});

  @override
  State<SiteViewScreen> createState() => _SiteViewScreenState();
}

class _SiteViewScreenState extends State<SiteViewScreen> {
  var style = GoogleFonts.novaFlat(
    fontSize: 8,
    fontWeight: FontWeight.w400,
    color: Color(0xffFFA200),
  );

  var styleGray = GoogleFonts.novaFlat(
    fontSize: 8,
    fontWeight: FontWeight.w400,
    color: Color(0xff595959),
  );

  var styleBlack = GoogleFonts.novaFlat(
    fontSize: 6,
    fontWeight: FontWeight.w400,
    color: Color(0xff2D445C),
  );

  List<Moresite> list = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
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

      var response = jsonDecode(remoteConfig.getString('moresite'));
      list.addAll(
          response.map<Moresite>((json) => Moresite.fromJson(json)).toList());
      isLoading = false;
      setState(() {});
    } catch (exception) {
      print(
          'Unable to fetch remote config. Cached or default values will be used');
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Color(0xff5CA1DC),
            image: DecorationImage(
                image: AssetImage(imgBgPolicy), fit: BoxFit.cover)),
        child: Stack(
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
                  left: 24.0, right: 24, bottom: 120, top: 80),
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: (0.6),
                shrinkWrap: true,
                children: List.generate(list.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FadeInImage(
                              placeholder: const AssetImage(appLogo),
                              image: NetworkImage(list[index].image!),
                              placeholderColor: Colors.white,
                              fit: BoxFit.fitHeight,
                              fadeInDuration: const Duration(seconds: 1),
                              fadeOutDuration: const Duration(milliseconds: 400),
                              height: 40,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Color(0xffFFA200),
                              ),
                              Text(list[index].rating.toString(),style: style,)
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              launchURL(list[index].url!);
                            },
                              child: Image.asset(btnJoinNow)),

                          Text("Welcome bonus",style: styleGray,),
                          Text(list[index].welcomeBonus.toString(),style: styleBlack,maxLines: 1,),

                          Text("Deposit Bonus",style: styleGray,),
                          Text(list[index].depositeBonus.toString(),style: styleBlack,maxLines: 1,),


                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }
}
