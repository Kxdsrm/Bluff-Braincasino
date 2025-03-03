import 'package:bluff_brain/storage/storage_keys.dart';
import 'package:bluff_brain/storage/storage_utils.dart';
import 'package:bluff_brain/utils/common_widgets.dart';
import 'package:bluff_brain/utils/imageUtils.dart';
import 'package:bluff_brain/view/about_screen.dart';
import 'package:bluff_brain/view/policy_screen.dart';
import 'package:bluff_brain/view/view_sites_screen.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var style = GoogleFonts.novaFlat(
    fontSize: 30,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  bool isMusicOn = false;

  bool isViewSites = false;

  @override
  void initState() {
    // TODO: implement initState
    _init();
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

      isViewSites = remoteConfig.getBool('isViewSites');
      setState(() {});

    } catch (exception) {
      print(
          'Unable to fetch remote config. Cached or default values will be used');
    }

  }

  _init() async {
    isMusicOn = await StorageUtils.getBool(kMusic);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Color(0xff5CA1DC),
            image: DecorationImage(
                image: AssetImage(imgBgSetting), fit: BoxFit.cover)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.20,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      isMusicOn = !isMusicOn;
                      StorageUtils.setBool(kMusic, isMusicOn);
                      setState(() {});
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        color: isMusicOn ? Colors.green: Colors.red,
                      ),
                      child: Center(
                        child: Text(
                          "Sounds".toUpperCase(),
                          style: GoogleFonts.novaFlat(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  spaceVertical(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                            return const PolicyScreen();
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "Policy".toUpperCase(),
                          style: style,
                        ),
                      ),
                    ),
                  ),
                  spaceVertical(),
                  Visibility(
                    visible: isViewSites,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                                  return const SiteViewScreen();
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                "Sites".toUpperCase(),
                                style: style,
                              ),
                            ),
                          ),
                        ),
                        spaceVertical(),
                      ],
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                            return const AboutScreen();
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "About".toUpperCase(),
                          style: style,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
