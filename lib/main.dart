import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubercourserider/providers/app.dart';
import 'package:ubercourserider/screens/home.dart';

import 'helpers/constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  LocationPermission permission = await Geolocator.checkPermission();
  bool _isLocationEnabled  = await Geolocator.isLocationServiceEnabled();

  bool _hasLocationPermission = prefs.getBool(HAS_PERMISSION) ?? false;

  if(!_isLocationEnabled){
    await Geolocator.openLocationSettings();
  }else{
    if(!_hasLocationPermission){
      if(permission != LocationPermission.always){
        LocationPermission requestPermission = await Geolocator.requestPermission();
        if(requestPermission == LocationPermission.always){
          await prefs.setBool(HAS_PERMISSION, true);
        }else{
          //TODO:: do something when the permission is not LocationPermission.always
        }
      }
    }
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: AppProvider.initialize())
  ],
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Uber Clone",
    home: HomeScreen(),
  ),));
}
