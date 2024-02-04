import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:snm_parking_final/HomeScreen/homeheader.dart';
import 'package:snm_parking_final/HomeScreen/homescreen.dart';
import 'package:snm_parking_final/routes.dart';
import 'package:snm_parking_final/size_config.dart';
import 'package:snm_parking_final/widgets/bottomnavigationbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  Platform.isAndroid ? await Firebase.initializeApp(
    options:const  FirebaseOptions(
               
      apiKey: 'AIzaSyAyGqCbRTSeiCHnY-8HHVs-bpgnc4hnm9I',
      appId: '1:157869329668:android:328d0e1c40d9b750709451',
      messagingSenderId: '157869329668',
      projectId: 'snsd-project',
      storageBucket: 'snsd-project.appspot.com'
    ),) : await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Bottom.routeName,
      routes: routes,
    );
  }
}


