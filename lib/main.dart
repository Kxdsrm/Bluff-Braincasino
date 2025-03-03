
import 'package:bluff_brain/view/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyAX130irRkLm_e4bZWtJcwc0AMhamDTh-8',
          appId: '1:354668593589:android:52f5c0dd94575d4a3a59fc',
          projectId: 'bluff-brain',
          messagingSenderId: ''));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const StartScreen(),
    );
  }
}


