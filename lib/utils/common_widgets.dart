

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> toastMessage({required String message}) async {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.indigo[900],
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void launchURL(String url) async {
  if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
}


Widget spaceVertical({double space = 16}){
  return SizedBox(height: space,);
}


Widget spaceHorizontal({double space = 16}){
  return SizedBox(width: space,);
}

setTextStyle({double size = 16,Color clr = Colors.black,FontWeight fontWeight = FontWeight.w400}){
  return GoogleFonts.novaFlat(
    fontSize: size,
    fontWeight: fontWeight,
    color: clr,
  );
}