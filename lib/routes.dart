



import 'package:flutter/cupertino.dart';
import 'package:snm_parking_final/HomeScreen/homeheader.dart';
import 'package:snm_parking_final/HomeScreen/homescreen.dart';
import 'package:snm_parking_final/widgets/bottomnavigationbar.dart';


final Map<String, WidgetBuilder> routes = {
  //Splash.routeName:(context)=>Splash(),
  HomeScreen.routeName: (context) => HomeScreen(),
  HomeHeader.routeName:(context)=>HomeHeader(),
  Bottom.routeName:(context)=>Bottom(),
  
};
