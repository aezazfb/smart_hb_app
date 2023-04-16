
// We use name route
// All our routes will be available here
import 'package:flutter/cupertino.dart';
import 'package:smart_hb_app/main.dart';
import 'package:smart_hb_app/ui/LoginPage.dart';
import 'package:smart_hb_app/ui/Menu/profiles.dart';
import 'package:smart_hb_app/ui/dataScreen.dart';
import 'package:smart_hb_app/ui/device_list.dart';
import 'package:smart_hb_app/ui/loginCheck.dart';
import 'package:smart_hb_app/ui/profile/profile_screen.dart';

import 'globalVars.dart';

final Map<String, WidgetBuilder> routes = {
  HbsPage.routeName: (context) => HbsPage(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  dataScreen.routeName: (context) => dataScreen(thedevice: theGlobalDevice!),
  DeviceListScreen.routeName: (context) => const DeviceListScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  LoginScreen2.routeName: (context) => LoginScreen2(),
  UserCheck.routeName: (context) => const UserCheck(),
  // HomeScreen.routeName: (context) => HomeScreen(),
  // DetailsScreen.routeName: (context) => DetailsScreen(),
  // CartScreen.routeName: (context) => CartScreen(),
  // ProfileScreen.routeName: (context) => ProfileScreen(),
};
